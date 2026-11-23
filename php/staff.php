<?php
require_once __DIR__ . '/lib/auth.php';
require_once __DIR__ . '/lib/staff_account.php';
require_once __DIR__ . '/../db.php';

$roleStmt = $pdo->prepare('SELECT user_type FROM user WHERE user_id = ?');
$roleStmt->execute([$_SESSION['user_id']]);
$myRole = (string) $roleStmt->fetchColumn();
$_SESSION['user_type'] = $myRole;
if ($myRole !== 'Librarian') {
    header('Location: librarian_dashboard.php');
    exit;
}
$myUserId = (int) $_SESSION['user_id'];

if (!isset($_SESSION['csrf_token'])) {
    $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
}

$pageTitle = 'Staff';
$pageStyles = ['staff.css?v=20261123-1'];

$messages = ['added' => 'Staff account created.', 'reset' => 'Password reset.', 'role' => 'Role updated.'];
$doneKey = is_string($_GET['done'] ?? null) ? $_GET['done'] : '';
$success = $messages[$doneKey] ?? '';
$pageError = '';
$openDialog = '';
$resetId = '';
$roles = ['Librarian', 'Library Clerk'];
$add = ['user_fname' => '', 'user_midInit' => '', 'user_lname' => '', 'birth_date' => '', 'gender' => '', 'email' => '', 'role' => 'Library Clerk'];

function post_text(string $key): string
{
    return is_string($_POST[$key] ?? null) ? trim($_POST[$key]) : '';
}

if (($_SERVER['REQUEST_METHOD'] ?? 'GET') === 'POST') {
    $action = post_text('action');
    $csrfToken = is_string($_POST['csrf_token'] ?? null) ? $_POST['csrf_token'] : '';

    if (!hash_equals($_SESSION['csrf_token'], $csrfToken)) {
        $pageError = 'Your session expired. Refresh the page and try again.';
    } else {
        try {
            if ($action === 'add_staff') {
                foreach (['user_fname', 'user_midInit', 'user_lname', 'birth_date', 'gender', 'email'] as $key) {
                    $add[$key] = post_text($key);
                }
                $add['role'] = post_text('role');
                $pw = is_string($_POST['password'] ?? null) ? $_POST['password'] : '';
                $confirm = is_string($_POST['confirm_password'] ?? null) ? $_POST['confirm_password'] : '';

                $pageError = create_staff_account($pdo, $add, $add['role'], $pw, $confirm);
                if ($pageError === '') {
                    header('Location: staff.php?done=added');
                    exit;
                }
                $openDialog = 'add';
            } elseif ($action === 'reset_password') {
                $resetId = post_text('libstaff_id');
                $pw = is_string($_POST['new_password'] ?? null) ? $_POST['new_password'] : '';
                $confirm = is_string($_POST['confirm_password'] ?? null) ? $_POST['confirm_password'] : '';

                $existsStmt = $pdo->prepare('SELECT 1 FROM library_staff WHERE libstaff_id = ?');
                $existsStmt->execute([$resetId]);
                if (!$existsStmt->fetchColumn()) {
                    $pageError = 'Staff account not found.';
                } elseif (strlen($pw) < 8) {
                    $pageError = 'Password must be at least 8 characters.';
                    $openDialog = 'reset';
                } elseif ($pw !== $confirm) {
                    $pageError = 'Passwords do not match.';
                    $openDialog = 'reset';
                } else {
                    $pdo->prepare('UPDATE library_staff SET password = ? WHERE libstaff_id = ?')
                        ->execute([password_hash($pw, PASSWORD_DEFAULT), $resetId]);
                    header('Location: staff.php?done=reset');
                    exit;
                }
            } elseif ($action === 'change_role') {
                $targetId = post_text('libstaff_id');
                $newRole = post_text('role');

                $targetStmt = $pdo->prepare(
                    'SELECT ls.user_id, u.user_type
                     FROM library_staff ls JOIN user u ON u.user_id = ls.user_id
                     WHERE ls.libstaff_id = ?'
                );
                $targetStmt->execute([$targetId]);
                $target = $targetStmt->fetch();

                if (!$target) {
                    $pageError = 'Staff account not found.';
                } elseif (!in_array($newRole, $roles, true)) {
                    $pageError = 'Choose a valid role.';
                } elseif ((int) $target['user_id'] === $myUserId) {
                    $pageError = 'You cannot change your own role.';
                } else {
                    $librarianCount = (int) $pdo->query("SELECT COUNT(*) FROM user u JOIN library_staff ls ON ls.user_id = u.user_id WHERE u.user_type = 'Librarian'")->fetchColumn();
                    if ($target['user_type'] === 'Librarian' && $newRole !== 'Librarian' && $librarianCount <= 1) {
                        $pageError = 'At least one Librarian is required.';
                    } else {
                        $pdo->prepare('UPDATE user SET user_type = ? WHERE user_id = ?')
                            ->execute([$newRole, $target['user_id']]);
                        header('Location: staff.php?done=role');
                        exit;
                    }
                }
            } else {
                $pageError = 'Unknown action.';
            }
        } catch (PDOException $e) {
            $pageError = 'Could not save the change. Please try again.';
        }
    }
}

$staffRows = $pdo->query(
    "SELECT ls.libstaff_id, ls.user_id, CONCAT(u.user_fname, ' ', u.user_lname) AS name, u.email, u.user_type
     FROM library_staff ls JOIN user u ON u.user_id = ls.user_id
     ORDER BY ls.libstaff_id"
)->fetchAll();

$resetName = '';
foreach ($staffRows as $row) {
    if ($row['libstaff_id'] === $resetId) {
        $resetName = $row['name'];
    }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <?php require __DIR__ . '/lib/head.php'; ?>
</head>
<body>

<?php require __DIR__ . '/lib/header.php'; ?>

<main class="page-container">
    <section class="card">
        <div class="panel-head">
            <div>
                <h2 class="page-title">Staff</h2>
                <p class="page-note">Add staff, reset passwords and change roles. Only Librarians can see this page.</p>
            </div>
            <button class="btn-primary" type="button" id="open-add-staff"><i class="bi bi-person-plus"></i> Add Staff</button>
        </div>

        <?php if ($success !== ''): ?>
            <p class="alert-success" role="status"><?php echo htmlspecialchars($success); ?></p>
        <?php endif; ?>
        <?php if ($pageError !== '' && $openDialog === ''): ?>
            <p class="alert-danger" role="alert"><?php echo htmlspecialchars($pageError); ?></p>
        <?php endif; ?>

        <div class="staff-scroll">
            <table class="mini-table">
                <thead>
                    <tr>
                        <th>Staff ID</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Role</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <?php foreach ($staffRows as $row): ?>
                        <?php
                        $isMe = (int) $row['user_id'] === $myUserId;
                        $isLibrarian = $row['user_type'] === 'Librarian';
                        ?>
                        <tr>
                            <td><?php echo htmlspecialchars($row['libstaff_id']); ?></td>
                            <td><?php echo htmlspecialchars($row['name']); ?><?php echo $isMe ? ' (you)' : ''; ?></td>
                            <td><?php echo htmlspecialchars((string) $row['email']); ?></td>
                            <td><span class="role-tag <?php echo $isLibrarian ? 'role-librarian' : 'role-clerk'; ?>"><?php echo htmlspecialchars((string) $row['user_type']); ?></span></td>
                            <td>
                                <div class="staff-actions">
                                    <button class="btn-secondary btn-small js-reset" type="button"
                                            data-staff-id="<?php echo htmlspecialchars($row['libstaff_id']); ?>"
                                            data-name="<?php echo htmlspecialchars($row['name']); ?>">
                                        <i class="bi bi-key"></i> Reset Password
                                    </button>
                                    <form method="POST" action="staff.php">
                                        <input type="hidden" name="csrf_token" value="<?php echo htmlspecialchars($_SESSION['csrf_token']); ?>">
                                        <input type="hidden" name="action" value="change_role">
                                        <input type="hidden" name="libstaff_id" value="<?php echo htmlspecialchars($row['libstaff_id']); ?>">
                                        <input type="hidden" name="role" value="<?php echo $isLibrarian ? 'Library Clerk' : 'Librarian'; ?>">
                                        <button class="btn-secondary btn-small" type="submit"<?php echo $isMe ? ' disabled title="You cannot change your own role"' : ''; ?>>
                                            <i class="bi bi-arrow-left-right"></i> <?php echo $isLibrarian ? 'Make Clerk' : 'Make Librarian'; ?>
                                        </button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    <?php endforeach; ?>
                </tbody>
            </table>
        </div>
    </section>
</main>

<dialog class="bp-dialog staff-dialog" id="add-staff-dialog" data-open="<?php echo $openDialog === 'add' ? '1' : '0'; ?>">
    <form method="POST" action="staff.php" class="bp-form">
        <h3>Add Staff</h3>
        <?php if ($openDialog === 'add' && $pageError !== ''): ?>
            <p class="alert-danger" role="alert"><?php echo htmlspecialchars($pageError); ?></p>
        <?php endif; ?>
        <input type="hidden" name="csrf_token" value="<?php echo htmlspecialchars($_SESSION['csrf_token']); ?>">
        <input type="hidden" name="action" value="add_staff">

        <div class="bp-grid">
            <div class="field-group">
                <label for="add-fname">First Name</label>
                <input id="add-fname" name="user_fname" type="text" maxlength="50" required value="<?php echo htmlspecialchars($add['user_fname']); ?>">
            </div>
            <div class="field-group">
                <label for="add-lname">Last Name</label>
                <input id="add-lname" name="user_lname" type="text" maxlength="50" required value="<?php echo htmlspecialchars($add['user_lname']); ?>">
            </div>
            <div class="field-group">
                <label for="add-mid">Middle Initial</label>
                <input id="add-mid" name="user_midInit" type="text" maxlength="1" value="<?php echo htmlspecialchars($add['user_midInit']); ?>">
            </div>
            <div class="field-group">
                <label for="add-birth">Birth Date</label>
                <input id="add-birth" name="birth_date" type="date" required max="<?php echo date('Y-m-d'); ?>" value="<?php echo htmlspecialchars($add['birth_date']); ?>">
            </div>
            <div class="field-group">
                <label for="add-gender">Gender</label>
                <select id="add-gender" name="gender" required>
                    <option value="">Select</option>
                    <?php foreach (['Male', 'Female'] as $g): ?>
                        <option <?php echo $add['gender'] === $g ? 'selected' : ''; ?>><?php echo $g; ?></option>
                    <?php endforeach; ?>
                </select>
            </div>
            <div class="field-group">
                <label for="add-role">Role</label>
                <select id="add-role" name="role" required>
                    <?php foreach ($roles as $r): ?>
                        <option <?php echo $add['role'] === $r ? 'selected' : ''; ?>><?php echo $r; ?></option>
                    <?php endforeach; ?>
                </select>
            </div>
            <div class="field-group span-2">
                <label for="add-email">Email Address</label>
                <input id="add-email" name="email" type="email" maxlength="100" required value="<?php echo htmlspecialchars($add['email']); ?>">
            </div>
            <div class="field-group">
                <label for="add-password">Password</label>
                <input id="add-password" name="password" type="password" minlength="8" maxlength="255" required placeholder="At least 8 characters" autocomplete="new-password">
            </div>
            <div class="field-group">
                <label for="add-confirm">Confirm Password</label>
                <input id="add-confirm" name="confirm_password" type="password" minlength="8" maxlength="255" required autocomplete="new-password">
            </div>
        </div>

        <div class="actions-row">
            <button class="btn-secondary" type="button" id="cancel-add-staff">Cancel</button>
            <button class="btn-primary" type="submit">Create Account</button>
        </div>
    </form>
</dialog>

<dialog class="bp-dialog staff-dialog staff-dialog-small" id="reset-dialog" data-open="<?php echo $openDialog === 'reset' ? '1' : '0'; ?>">
    <form method="POST" action="staff.php" class="bp-form">
        <h3>Reset Password</h3>
        <p class="page-note">New password for <strong id="reset-staff-name"><?php echo htmlspecialchars($resetName); ?></strong></p>
        <?php if ($openDialog === 'reset' && $pageError !== ''): ?>
            <p class="alert-danger" role="alert"><?php echo htmlspecialchars($pageError); ?></p>
        <?php endif; ?>
        <input type="hidden" name="csrf_token" value="<?php echo htmlspecialchars($_SESSION['csrf_token']); ?>">
        <input type="hidden" name="action" value="reset_password">
        <input type="hidden" name="libstaff_id" id="reset-staff-id" value="<?php echo htmlspecialchars($resetId); ?>">

        <div class="field-group">
            <label for="reset-password">New Password</label>
            <input id="reset-password" name="new_password" type="password" minlength="8" maxlength="255" required placeholder="At least 8 characters" autocomplete="new-password">
        </div>
        <div class="field-group">
            <label for="reset-confirm">Confirm Password</label>
            <input id="reset-confirm" name="confirm_password" type="password" minlength="8" maxlength="255" required autocomplete="new-password">
        </div>

        <div class="actions-row">
            <button class="btn-secondary" type="button" id="cancel-reset">Cancel</button>
            <button class="btn-primary" type="submit">Reset Password</button>
        </div>
    </form>
</dialog>

<script src="../js/staff.js"></script>

</body>
</html>
