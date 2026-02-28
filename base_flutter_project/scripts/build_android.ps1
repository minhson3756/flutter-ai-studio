param(
    [string]$FLAVOR = "dev",
    [string]$ENTRYPOINT = "lib/main.dart",
    [string]$FULL_ADS = ""
)

Write-Host "🛠️  Building APK with:"
Write-Host "FLAVOR: $FLAVOR"
Write-Host "ENTRYPOINT: $ENTRYPOINT"
Write-Host "FULL_ADS: $FULL_ADS"

# Tên thư mục hiện tại là tên project
$projectName = Split-Path -Leaf (Get-Location)

# Xử lý dart-define và hậu tố tên file/
if (-not $FULL_ADS -or $FULL_ADS -eq "false")
{
    $dartDefine = ""
    $fileSuffix = "normal"
}
else
{
    $dartDefine = "--dart-define=FULL_ADS=$FULL_ADS"
    $fileSuffix = "full-ads"
}

# Lấy versionName từ build.gradle
$buildGradlePath = "android/app/build.gradle"
$versionName = Select-String -Path $buildGradlePath -Pattern 'versionName' | Select-Object -First 1 | ForEach-Object {
    ($_ -split '"')[1]
}

# Kiểm tra fvm có sẵn hay không
$fvmExists = Get-Command "fvm" -ErrorAction SilentlyContinue
if ($fvmExists)
{
    $FLUTTER_CMD = "fvm flutter"
}
else
{
    $FLUTTER_CMD = "flutter"
}

# Build APK
$buildCmd = "$FLUTTER_CMD build apk --flavor $FLAVOR -t $ENTRYPOINT $dartDefine"
Write-Host "🚀 Running: $buildCmd"
Invoke-Expression $buildCmd

# Đổi tên file APK
$src = "build/app/outputs/flutter-apk/app-$FLAVOR-release.apk"
$destFileName = "$projectName-$FLAVOR-v$versionName-$fileSuffix.apk"
$dest = Join-Path -Path "build/app/outputs/flutter-apk" -ChildPath $destFileName

if (Test-Path $src)
{
    if (Test-Path $dest)
    {
        Remove-Item $dest
    }
    Rename-Item -Path $src -NewName $destFileName
    Write-Host "✅ APK renamed to: $dest"

    # Mở thư mục chứa file APK
    $folderPath = Split-Path $dest
    Write-Host "Opening folder: $folderPath"
    Start-Process -FilePath "explorer.exe" -ArgumentList "/select,`"$dest`""
}
else
{
    Write-Host "❌ APK not found at: $src"
}
