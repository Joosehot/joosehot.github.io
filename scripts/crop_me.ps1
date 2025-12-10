# Crop and save profile image to images/me.jpg
# Usage (PowerShell 5.1):
# 1. Put your original photo at images/me-original.jpg (or change $src)
# 2. Run: .\scripts\crop_me.ps1
# Requires .NET Framework (System.Drawing) available in Windows PowerShell 5.1

param(
    [string]$src = "images/me-original.jpg",
    [string]$dst = "images/me.jpg",
    [int]$size = 800
)

if (-not (Test-Path $src)) {
    Write-Error "Source file '$src' not found. Place your original image there or run script with -src path."
    exit 1
}

Add-Type -AssemblyName System.Drawing
$img = [System.Drawing.Image]::FromFile($src)

# Determine square crop centered
$w = $img.Width
$h = $img.Height
if ($w -gt $h) {
    $side = $h
    $x = [int](($w - $h) / 2)
    $y = 0
} else {
    $side = $w
    $x = 0
    $y = [int](($h - $w) / 2)
}

$rect = New-Object System.Drawing.Rectangle $x, $y, $side, $side
$bmp = New-Object System.Drawing.Bitmap $size, $size
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.DrawImage($img, 0, 0, $size, $size)

# If we want to crop first then resize to better aspect control:
$crop = New-Object System.Drawing.Bitmap $side, $side
$g2 = [System.Drawing.Graphics]::FromImage($crop)
$g2.DrawImage($img, 0, 0, -$x + 0, -$y + 0, $w, $h)
$g2.Dispose()

# Resize crop into final
$final = New-Object System.Drawing.Bitmap $size, $size
$g3 = [System.Drawing.Graphics]::FromImage($final)
$g3.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g3.DrawImage($crop, 0, 0, $size, $size)
$g3.Dispose()

# Save as JPEG with quality
$enc = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq 'image/jpeg' }
$eps = New-Object System.Drawing.Imaging.EncoderParameters(1)
$eps.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, 90L)
$final.Save($dst, $enc, $eps)

# Cleanup
$g.Dispose()
$img.Dispose()
$bmp.Dispose()
$crop.Dispose()
$final.Dispose()

Write-Output "Saved cropped profile image to $dst"
