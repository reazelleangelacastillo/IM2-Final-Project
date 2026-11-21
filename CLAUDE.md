# Rules (Auto-Active)
- **Memory First:** Read this `CLAUDE.md` before doing anything. Do NOT scan or search the repo unless a needed file path is missing here.
- **Ponytail (Minimalist Code):** Check standard libraries and existing files first. Write the shortest possible code diff. No over-engineering.
- **Caveman (Ultra-Short Replies):** Answer first in short fragments or tight bullets. Zero filler, greetings, or fluff. Keep code clean.
- **No Code Comments:** Never write comments (`//`, `/* */`, `#`, `<!-- -->`) in any generated or edited code. Keep existing code clean without adding explanatory or TODO comments.

---
# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

BookTrace — a Library Database Management System. Plain PHP + MySQL served by Apache under XAMPP. No framework, no bundler, no build step, no package manager, no test suite, and no lint configuration. PHP 8.2.12 / MariaDB 10.4.32 (see the dump header in `sql/booktrace.sql`).

## How to run

1. Start Apache and MySQL in XAMPP.
2. Create the `booktrace` database and import `sql/booktrace.sql` (phpMyAdmin or `mysql booktrace < sql/booktrace.sql`).
3. The app lives at `http://localhost/IM2-Final-Project/` — entry point is `index.php`.
4. Database credentials used everywhere: host `localhost:3306`, db `booktrace`, user `root`, password empty.

There are no build, lint, or test commands. Verification is manual through the browser. Do not invent `npm test`, `composer test`, `phpunit`, etc. — none exist in this repo.

## Architecture / big picture

**Two data-access styles coexist.** `db.php` (PDO) is used by `fines_api.php`, `transactions_api.php`, and `borrower_search.php`. `librarian_dashboard.php`, `browse.php`, `register.php`, and `login.php` use raw `mysqli` with their own `mysqli_connect` calls. Both connect to the same `booktrace` database. When touching DB code, match the style of the file you're editing rather than refactoring across styles.

**Entry points:**
- `index.php` — public landing page: Staff Login → `php/login.php`, Borrower → `php/browse.php`.
- `php/login.php`, `php/register.php`, `php/logout.php` — staff authentication. Sessions store `user_id`, `user_name`, `user_type` (`Librarian` | `Library Clerk`). Passwords are stored plaintext in `library_staff.password` — treat as a known weakness, not something to "fix" silently.
- `php/browse.php` — public read-only browse of publications (no auth).
- Staff pages (require auth via `php/includes/auth.php`): `librarian_dashboard.php` (books + periodicals CRUD), `fines.php` (fine list + overdue), `transactions.php` (borrow/return), `policy.php` (borrowing policy), `publications.php`, `tables.php`, `view-table.php`, `notifications.php`.

**Auth gate:** `php/includes/auth.php` starts the session, redirects to `login.php` when not authenticated, and exposes `current_libstaff_id()` (used by borrow/return/pay actions to record which staff member performed them). Every staff page requires `require_once __DIR__ . '/includes/auth.php';`.

**Business logic lives in MySQL, not PHP.** The dump defines:
- Functions: `fn_hours_late(due, end)`, `fn_calc_fine(due, end, rate)`.
- Procedures: `sp_borrow(borrower_id, copy_id, libstaff_id)`, `sp_return(borrow_id, libstaff_id)`, `sp_pay_fine(fine_id)`, `sp_register_borrower(...)`.
- Views: `v_overdue_borrows`, `v_borrower_status`.
- Trigger: `trg_borrows_after_return` (fires after a borrow is returned).
When changing borrow/return/fine behavior, prefer updating the corresponding stored procedure/view over duplicating logic in PHP.

**JSON API endpoints** (each returns `{"ok": bool, ...}`; called via `fetch()` with `URLSearchParams` + `credentials: 'same-origin'`):
- `php/fines_api.php` — `?action=summary|list|overdue&status=...&q=...` (GET); `action=pay` (POST `fine_id`).
- `php/transactions_api.php` — `?action=policy|copies|active&borrower_id=...` (GET); `action=borrow|return` (POST).
- `php/borrower_search.php` — `?action=search&q=...|card&id=...` (GET); `action=register|update|delete` (POST).

**Shared UI includes:** `php/includes/header.php` (staff topbar + nav), `php/includes/borrower_panel.php` (borrower search/register card mounted inside `transactions.php`), `php/includes/confirm_dialog.php` (provides the global `bpConfirm(options)` dialog helper used by fines/transactions/borrower panel).

**Frontend:** vanilla JavaScript inline in each page (no modules, no build). Per-page stylesheets in `css/` (one CSS file per page, e.g. `fines.css`, `transactions.css`, `librarian_dashboard.css`). Bootstrap Icons and Google Fonts loaded from CDN. `js/login.js` exists but is not referenced by any page.

**File layout (top level only):** `index.php`, `db.php`, `style.css`, `sql/booktrace.sql`, plus directories `php/`, `php/includes/`, `css/`, `js/`, `assets/`, `html/`. `digest.txt` is git-ignored.

## Notes

- IDs are not auto-incrementing; registration derives new IDs via `MAX(...) + 1`, so concurrent signups can collide (noted in `register.php` comments).
- Fine calculation is rate × full hours late; policy values come from `borrowing_policy` (single row).
- CSS cache-busting is done manually via `?v=` query strings on stylesheet links (e.g. `librarian_dashboard.css?v=20261120-3`) — bump it when changing shared styles.
- `.gitignore` only ignores `digest.txt`.
