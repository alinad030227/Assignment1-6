$targetDir = "../outputs"
$files = @("sharpened_K4.png", "sharpened_K8.png", "hidden_watermark.png")
Write-Host "`n======================================================================" -ForegroundColor Yellow
Write-Host "  COMP4421 Step 1.5: Image Export & Binary Metadata Verification      " -ForegroundColor Yellow
Write-Host "======================================================================`n" -ForegroundColor Yellow
$allPass =$true
foreach ($file in$files) {
    $fullPath = Join-Path $targetDir$file
    Write-Host "--------------------------------------------------" -ForegroundColor Gray
    Write-Host "Examining: $file" -ForegroundColor White
    if (-not (Test-Path $fullPath)) {
        Write-Host "  [FAIL] Missing file: $fullPath" -ForegroundColor Red
        $allPass =$false
        continue
    }
    $bytes = [System.IO.File]::ReadAllBytes($fullPath)
    $fileSize =$bytes.Length
    $pngMagic = @(0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A)
    $magicMatch =$true
    for ($i = 0; $i -lt 8; $i++) {
        if ($bytes[$i] -ne $pngMagic[$i]) { $magicMatch =$false; break }
    }
    if (-not $magicMatch) {
        Write-Host "  [FAIL] Invalid PNG Signature." -ForegroundColor Red
        $allPass =$false
        continue
    }
    $ihdrName = [System.Text.Encoding]::ASCII.GetString($bytes[12..15])
    if ($ihdrName -ne "IHDR") {
        Write-Host "  [FAIL] Corrupted PNG Chunk: IHDR not found." -ForegroundColor Red
        $allPass =$false
        continue
    }
    $width = [System.BitConverter]::ToInt32(@($bytes[19], $bytes[18],$bytes[17], $bytes[16]), 0)
$height = [System.BitConverter]::ToInt32(@($bytes[23],$bytes[22], $bytes[21],$bytes[20]), 0)
    $bitDepth =$bytes[24]
    $colorType =$bytes[25]
    $colorTypeStr = switch ($colorType) {
        0 { "Grayscale (Single Channel)" }
        2 { "Truecolor (RGB)" }
        3 { "Indexed" }
        default { "Unknown ($colorType)" }
    }
    $dimPass = ($width -eq 512 -and $height -eq 512)
$depthPass = ($bitDepth -eq 8)
$colorPass = ($colorType -eq 0 -or$colorType -eq 2)
    Write-Host "  * Resolution:   $width x$height" -NoNewline
    if ($dimPass) { Write-Host " [PASS: 512x512]" -ForegroundColor Green } else { Write-Host " [FAIL]" -ForegroundColor Red; $allPass =$false }
    Write-Host "  * Bit Depth:    $bitDepth-bit" -NoNewline
    if ($depthPass) { Write-Host " [PASS: 8-bit]" -ForegroundColor Green } else { Write-Host " [FAIL]" -ForegroundColor Red; $allPass =$false }
    Write-Host "  * Color Space:  $colorTypeStr" -NoNewline
    if ($colorPass) { Write-Host " [PASS]" -ForegroundColor Green } else { Write-Host " [FAIL]" -ForegroundColor Red; $allPass =$false }
    Write-Host "  * File Size:    $fileSize bytes" -ForegroundColor Gray
}
Write-Host "`n======================================================================" -ForegroundColor Yellow
if ($allPass) {
    Write-Host "  STATUS: ALL 3 PNG FILES FULLY VERIFIED (100% READY FOR RELEASE)    " -ForegroundColor Green
} else {
    Write-Host "  STATUS: VERIFICATION FAILED. CHECK ERRORS ABOVE.                   " -ForegroundColor Red
}
Write-Host "======================================================================`n" -ForegroundColor Yellow
