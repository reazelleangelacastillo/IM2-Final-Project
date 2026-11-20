<?php
require_once __DIR__ . '/includes/auth.php';
require __DIR__ . '/../db.php';

$errors = [];

$policy = $pdo->query('SELECT policy_id, max_books_allowed, loan_duration_days, fine_rate_per_hour FROM borrowing_policy ORDER BY policy_id LIMIT 1')->fetch();

$input = [
    'max_books' => (string) $policy['max_books_allowed'],
    'loan_days' => (string) $policy['loan_duration_days'],
    'fine_rate' => number_format((float) $policy['fine_rate_per_hour'], 2, '.', ''),
];

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    foreach ($input as $key => $unused) {
        $input[$key] = is_string($_POST[$key] ?? null) ? trim($_POST[$key]) : '';
    }

    if (filter_var($input['max_books'], FILTER_VALIDATE_INT, ['options' => ['min_range' => 1, 'max_range' => 9999]]) === false) {
        $errors[] = 'Maximum books must be a whole number from 1 to 9999.';
    }
    if (filter_var($input['loan_days'], FILTER_VALIDATE_INT, ['options' => ['min_range' => 1, 'max_range' => 9999]]) === false) {
        $errors[] = 'Loan days must be a whole number from 1 to 9999.';
    }
    if (!preg_match('/^\d{1,8}(\.\d{1,2})?$/', $input['fine_rate'])) {
        $errors[] = 'Fine rate must be a number of 0 or more with up to two decimals.';
    }

    if (!$errors) {
        $stmt = $pdo->prepare('UPDATE borrowing_policy SET max_books_allowed = ?, loan_duration_days = ?, fine_rate_per_hour = ? WHERE policy_id = ?');
        $stmt->execute([(int) $input['max_books'], (int) $input['loan_days'], $input['fine_rate'], $policy['policy_id']]);
        header('Location: policy.php?saved=1');
        exit;
    }
}

$saved = isset($_GET['saved']);
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Borrowing Policy | BookTrace</title>
    <link rel="stylesheet" href="../css/header.css">
    <link rel="stylesheet" href="../css/transactions.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>

<?php require __DIR__ . '/includes/header.php'; ?>

<main class="page-container">
    <section class="card narrow">
        <h2 class="page-title"><i class="bi bi-sliders"></i> Borrowing Policy</h2>
        <p class="page-note">Changes apply to new borrows only. Existing borrows keep their due times, and existing fines keep their stored rate.</p>

        <?php if ($saved): ?>
            <div class="alert-success"><i class="bi bi-check-circle-fill"></i><span>Policy saved.</span></div>
        <?php endif; ?>
        <?php foreach ($errors as $error): ?>
            <div class="alert-danger"><i class="bi bi-exclamation-triangle-fill"></i><span><?php echo htmlspecialchars($error); ?></span></div>
        <?php endforeach; ?>

        <form method="POST" action="policy.php" class="stack-form">
            <div class="field-group">
                <label for="max_books">Maximum books per borrower</label>
                <input type="text" inputmode="numeric" id="max_books" name="max_books" value="<?php echo htmlspecialchars($input['max_books']); ?>" required>
            </div>
            <div class="field-group">
                <label for="loan_days">Loan period (days)</label>
                <input type="text" inputmode="numeric" id="loan_days" name="loan_days" value="<?php echo htmlspecialchars($input['loan_days']); ?>" required>
            </div>
            <div class="field-group">
                <label for="fine_rate">Late fine per full hour (PHP)</label>
                <input type="text" inputmode="decimal" id="fine_rate" name="fine_rate" value="<?php echo htmlspecialchars($input['fine_rate']); ?>" required>
            </div>
            <button type="submit" class="btn-primary"><i class="bi bi-check2"></i> Save policy</button>
        </form>
    </section>
</main>

</body>
</html>
