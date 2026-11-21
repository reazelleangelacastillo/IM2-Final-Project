<div class="borrower-panel" id="borrower-panel">
    <div class="panel-head">
        <div>
            <h2 class="page-title"><i class="bi bi-person-badge"></i> Find Borrower</h2>
            <p class="page-note">Search by borrower ID or name, or register a new borrower.</p>
        </div>
        <button type="button" class="btn-primary" id="register-new-btn"><i class="bi bi-person-plus"></i> Register New Borrower</button>
    </div>
    <div class="search-row">
        <i class="bi bi-search"></i>
        <input type="text" id="borrower-search" placeholder="Borrower ID (BOR012 or 12) or name" autocomplete="off">
    </div>
    <div id="borrower-results" class="results-list" hidden></div>
    <div id="borrower-message" class="panel-message" hidden></div>
    <div id="borrower-card" class="info-card" hidden></div>
</div>

<dialog id="borrower-dialog" class="bp-dialog">
    <form id="borrower-form" class="bp-form" autocomplete="off">
        <h3 id="borrower-form-title">Register Borrower</h3>
        <div id="borrower-form-alert" class="alert-danger" hidden></div>
        <div id="borrower-form-warning" class="alert-warning" hidden></div>
        <input type="hidden" name="borrower_id" id="bf-borrower-id">
        <div class="bp-grid">
            <div class="field-group">
                <label for="bf-first-name">First Name</label>
                <input type="text" id="bf-first-name" name="first_name" maxlength="50" required>
            </div>
            <div class="field-group">
                <label for="bf-middle-initial">Middle Initial</label>
                <input type="text" id="bf-middle-initial" name="middle_initial" maxlength="1">
            </div>
            <div class="field-group">
                <label for="bf-last-name">Last Name</label>
                <input type="text" id="bf-last-name" name="last_name" maxlength="50" required>
            </div>
            <div class="field-group">
                <label for="bf-birth-date">Birth Date</label>
                <input type="date" id="bf-birth-date" name="birth_date" max="<?php echo date('Y-m-d'); ?>" required>
            </div>
            <div class="field-group">
                <label for="bf-gender">Gender</label>
                <select id="bf-gender" name="gender" required>
                    <option value="">Select</option>
                    <option>Male</option>
                    <option>Female</option>
                </select>
            </div>
            <div class="field-group">
                <label for="bf-category">Category</label>
                <select id="bf-category" name="category" required>
                    <option value="">Select</option>
                    <option>Student</option>
                    <option>Teacher</option>
                    <option>Researcher</option>
                    <option>Community Resident</option>
                    <option>Other</option>
                </select>
            </div>
            <div class="field-group">
                <label for="bf-id-type">ID Type</label>
                <input type="text" id="bf-id-type" name="id_type" maxlength="100" list="bf-id-types" required>
                <datalist id="bf-id-types">
                    <option value="National ID">
                    <option value="Driver's License">
                    <option value="Passport">
                    <option value="School ID">
                    <option value="Voter's ID">
                    <option value="Barangay ID">
                </datalist>
            </div>
            <div class="field-group">
                <label for="bf-id-number">ID Number</label>
                <input type="text" id="bf-id-number" name="id_number" maxlength="30" required>
            </div>
            <div class="field-group">
                <label for="bf-barangay">Barangay (Optional)</label>
                <input type="text" id="bf-barangay" name="barangay" maxlength="100">
            </div>
            <div class="field-group">
                <label for="bf-municipality">Municipality (Optional)</label>
                <input type="text" id="bf-municipality" name="municipality" maxlength="100">
            </div>
            <div class="field-group">
                <label for="bf-province">Province (Optional)</label>
                <input type="text" id="bf-province" name="province" maxlength="100">
            </div>
            <div class="field-group">
                <label for="bf-email">Email (Optional)</label>
                <input type="email" id="bf-email" name="email" maxlength="100">
            </div>
        </div>
        <div class="actions-row">
            <button type="button" class="btn-secondary" id="bf-existing" hidden>View Existing Record</button>
            <button type="button" class="btn-secondary" id="bf-override" hidden>Register Anyway</button>
            <button type="button" class="btn-secondary" id="bf-cancel">Cancel</button>
            <button type="submit" class="btn-primary" id="bf-save">Save</button>
        </div>
    </form>
</dialog>

<script src="../js/borrower_panel.js"></script>
