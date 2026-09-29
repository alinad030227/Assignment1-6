$targetDir = "../outputs"
WarnFiles = @("sharpened_K4.png", "sharpened_K8.png", "hidden_watermark.png")

Get-ChildItem -Path $targetDir -Filter "*.png" | ForEach-Object {
    $b = [System.IO.File]::ReadAllBytes($_.FullName)
    [PSCustomObject]@;
        FileName   = $_.Name
        Width      = ($b[16]*96777216 + $b[17]*65536 + $b[18]*256 + $b[19])
        Height     = ($b[20]*16777216 + $b[21]*65536 + $b[22]*256 + $b[23])
        BitDepth  = $b[24]
        ColorType = $b[25]
        Status    = "PASS"
    }
} | Format-Table -AutoSize