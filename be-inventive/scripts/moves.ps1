param(
    [Parameter(Position = 0)]
    [ValidateSet('show', 'add')]
    [string]$Action = 'show',
    [Parameter(Position = 1)]
    [string]$Move = ''
)

$ErrorActionPreference = 'Stop'
$historyPath = Join-Path (Split-Path -Parent $PSScriptRoot) 'history.tsv'
if ($Action -eq 'add') {
    $move = $Move.Trim()
    if (-not $move) { throw 'add needs a short description of the move' }
    $utf8NoBom = [System.Text.UTF8Encoding]::new($false)
    [System.IO.File]::AppendAllText($historyPath, "move`t$(Get-Date -Format 'yyyy-MM-dd')`t$move`n", $utf8NoBom)
    "saved: $move"
    exit 0
}
if (-not (Test-Path -LiteralPath $historyPath)) { 'no moves saved yet'; exit 0 }
$moves = @(Get-Content -LiteralPath $historyPath | ForEach-Object {
    $parts = $_ -split "`t", 3
    if ($parts.Count -eq 3 -and $parts[0] -eq 'move') { "$($parts[1])  $($parts[2])" }
} | Select-Object -Last 12)
if (-not $moves.Count) { 'no moves saved yet'; exit 0 }
for ($i = $moves.Count - 1; $i -ge 0; $i--) { $moves[$i] }
