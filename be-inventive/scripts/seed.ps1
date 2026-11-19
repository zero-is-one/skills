param(
    [ValidateSet('visual', 'text', 'idea')]
    [string]$Kind = 'visual',
    [string]$Only,
    [string[]]$Keep = @(),
    [switch]$NoLog
)

$ErrorActionPreference = 'Stop'
$skillRoot = Split-Path -Parent $PSScriptRoot
$dataPath = Join-Path $skillRoot 'data/seeds.tsv'
$historyPath = Join-Path $skillRoot 'history.tsv'
$rows = foreach ($line in Get-Content -LiteralPath $dataPath) {
    $parts = $line -split "`t", 3
    if ($parts.Count -eq 3 -and $parts[0] -eq $Kind) {
        [pscustomobject]@{ Axis = $parts[1]; Value = $parts[2] }
    }
}
$axes = @($rows.Axis | Select-Object -Unique)

$kept = @{}
foreach ($item in $Keep) {
    $pair = $item -split '=', 2
    if ($pair.Count -ne 2) { throw "-Keep needs axis=value, got '$item'" }
    $kept[$pair[0].Trim()] = $pair[1].Trim()
}
$axesToValidate = @($kept.Keys)
if ($Only) { $axesToValidate += $Only }
foreach ($axis in $axesToValidate) {
    if ($axis -notin $axes) { throw "No axis '$axis' for $Kind. Available axes: $($axes -join ', ')" }
}
if ($Only) { $kept.Remove($Only) }

$history = @()
if (Test-Path -LiteralPath $historyPath) {
    $history = @(Get-Content -LiteralPath $historyPath | ForEach-Object {
        $parts = $_ -split "`t", 5
        if ($parts.Count -eq 5 -and $parts[0] -eq 'seed' -and $parts[2] -eq $Kind) {
            [pscustomobject]@{ Axis = $parts[3]; Value = $parts[4] }
        }
    })
}

$seed = [ordered]@{}
$axesToRoll = if ($Only) { @($Only) } else { $axes }
foreach ($axis in $axesToRoll) {
    if ($kept.ContainsKey($axis)) {
        $seed[$axis] = $kept[$axis]
        continue
    }
    $options = @($rows | Where-Object Axis -eq $axis | ForEach-Object Value)
    $recent = @($history | Where-Object Axis -eq $axis | Select-Object -Last 12 | ForEach-Object Value)
    $fresh = @($options | Where-Object { $_ -notin $recent })
    if ($fresh.Count -gt 0) { $options = $fresh }
    $value = Get-Random -InputObject $options
    $seed[$axis] = $value
}

if ($Kind -eq 'visual' -and $seed.Contains('color')) {
    $method = if ($kept.ContainsKey('method')) { $kept['method'] } else { $seed['method'] }
    $fixedColorMethods = @('x-ray image', 'thermal camera image', 'night vision footage', 'infrared photo', 'sonar scan', 'weather radar map', 'e-ink display', 'thermal receipt printer', 'photocopy zine', 'LED dot matrix', 'airport departure board', 'security camera still')
    if ($method -in $fixedColorMethods -and -not $kept.ContainsKey('color')) { $seed['color'] = "the method's own colors" }
}

foreach ($axis in $seed.Keys) { "${axis}: $($seed[$axis])" }
if (-not $NoLog) {
    $date = Get-Date -Format 'yyyy-MM-dd'
    foreach ($axis in $seed.Keys) {
        $utf8NoBom = [System.Text.UTF8Encoding]::new($false)
        [System.IO.File]::AppendAllText($historyPath, "seed`t$date`t$Kind`t$axis`t$($seed[$axis])`n", $utf8NoBom)
    }
}
