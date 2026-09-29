param (
    [string]$StudentID = "20xxxxxx"
)

$ErrorActionPreference = "Stop"
$docDir = $PSScriptRoot
Set-Location $docDir

$targetTex = "Assignment1_$StudentID.tex"
if (-not (Test-Path $targetTex)) {
    if (Test-Path "Assignment1_Report.tex") {
        Copy-Item "Assignment1_Report.tex" $targetTex -Force
    } else {
        Write-Error "LaTeX source file not found!"
    }
}

Write-Host "`n======================================================================" -ForegroundColor Yellow
Write-Host "  COMP4421 Step 4.1: Automated Double-Pass LaTeX PDF Compilation       " -ForegroundColor Yellow
Write-Host "======================================================================`n" -ForegroundColor Yellow

# 檢查系統可用之編譯器 (優先 pdflatex，次選 xelatex)
$compiler = $null
if (Get-Command "pdflatex" -ErrorAction SilentlyContinue) {
    $compiler = "pdflatex"
} elseif (Get-Command "xelatex" -ErrorAction SilentlyContinue) {
    $compiler = "xelatex"
}

if ($null -eq $compiler) {
    Write-Host "[NOTICE] No local LaTeX compiler (pdflatex/xelatex) detected in PATH." -ForegroundColor Yellow
    Write-Host "         => Please see the Overleaf / Web Compilation Guide below." -ForegroundColor Cyan
    return
}

Write-Host "[FOUND] Using compiler: $compiler" -ForegroundColor Green
Write-Host "[BUILD 1/2] Pass 1: Generating auxiliary metrics and cross-references..." -ForegroundColor White
& $compiler -interaction=nonstopmode $targetTex | Out-Null

Write-Host "[BUILD 2/2] Pass 2: Resolving labels, citations, and table references..." -ForegroundColor White
& $compiler -interaction=nonstopmode $targetTex | Out-Null

$outputPdf = "Assignment1_$StudentID.pdf"
if (Test-Path $outputPdf) {
    $pdfSize = (Get-Item $outputPdf).Length
    Write-Host "`n======================================================================" -ForegroundColor Green
    Write-Host "  [SUCCESS] PDF compiled successfully!" -ForegroundColor Green
    Write-Host "  * File Path: doc/$outputPdf" -ForegroundColor White
    Write-Host "  * File Size: $pdfSize bytes" -ForegroundColor White
    Write-Host "======================================================================`n" -ForegroundColor Green
} else {
    Write-Host "`n[ERROR] PDF compilation failed. Check LaTeX log in doc/ directory." -ForegroundColor Red
}
