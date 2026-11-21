<?php
function report_period_start(string $type, ?string $storedStart, DateTimeImmutable $generatedAt): DateTimeImmutable
{
    if ($storedStart !== null && $storedStart !== '') {
        return (new DateTimeImmutable($storedStart))->setTime(0, 0);
    }

    switch ($type) {
        case 'Weekly':
            return $generatedAt->modify('monday this week')->setTime(0, 0)->modify('-1 week');
        case 'Monthly':
            return $generatedAt->modify('first day of this month')->setTime(0, 0);
        case 'Annual':
            return $generatedAt->setDate((int)$generatedAt->format('Y'), 1, 1)->setTime(0, 0);
    }

    throw new UnexpectedValueException('This report has an unsupported report type.');
}

function report_period_label(string $type, DateTimeImmutable $start): string
{
    if ($type === 'Weekly') {
        return $start->format('M d') . ' - ' . $start->modify('+6 days')->format('M d, Y');
    }
    if ($type === 'Monthly') {
        return $start->format('F Y');
    }
    return $start->format('Y');
}
