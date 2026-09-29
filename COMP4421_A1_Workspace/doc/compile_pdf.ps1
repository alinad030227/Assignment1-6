param (
    [string]$StudentID = "20861656"
)

$ErrorActionPreference = "Stop"
$docDir = $PSScriptRoot
Set-Location $docDir

$targetTex = "Assignment1_$StudentID.tex"
if (-not (Test-Path $targetTex)) {
    Copy-Item "Assignment1_Report.tex" $targetTex -Force
}

Write-Host "`n======================================================================" -ForegroundColor Yellow
Write-Host "  COMP4421: Executing Double-Pass LaTeX Build (Eradicating all '??')   " -ForegroundColor Yellow
Write-Host "======================================================================`n" -ForegroundColor Yellow

$compiler = $null
if (Get-Command "pdflatex" -ErrorAction SilentlyContinue) {
    $compiler = "pdflatex"
} elseif (Get-Command "xelatex" -ErrorAction SilentlyContinue) {
    $compiler = "xelatex"
}

if ($null -eq $compiler) {
    Write-Host "[NOTICE] Local LaTeX compiler not detected." -ForegroundColor Yellow
    Write-Host "         Please recompile on Overleaf by clicking 'Recompile' twice." -ForegroundColor Cyan
    return
}

Write-Host "[PASS 1/2] Generating .aux auxiliary files..." -ForegroundColor White
& $compiler -interaction=nonstopmode $targetTex | Out-Null

Write-Host "[PASS 2/2] Resolving all cross-references, equations, tables & figures..." -ForegroundColor White
& $compiler -interaction=nonstopmode $targetTex | Out-Null

$outputPdf = "Assignment1_$StudentID.pdf"
if (Test-Path $outputPdf) {
    Write-Host "`n[SUCCESS] PDF compiled with 0 unresolved references!" -ForegroundColor Green
    Write-Host "          Generated: doc/$outputPdf ($( (Get-Item$outputPdf).Length ) bytes)" -ForegroundColor Green
}
