<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><?php echo htmlspecialchars($pageTitle); ?> | BookTrace</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link rel="preconnect" href="https://cdn.jsdelivr.net" crossorigin>
<link rel="stylesheet" href="../css/header.css">
<link rel="stylesheet" href="../css/transactions.css">
<?php foreach ($pageStyles ?? [] as $style): ?>
<link rel="stylesheet" href="../css/<?php echo htmlspecialchars($style); ?>">
<?php endforeach; ?>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=block" rel="stylesheet">
<script src="../js/helpers.js?v=20261127-currency-grouping"></script>
