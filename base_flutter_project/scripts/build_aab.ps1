$FLAVOR = "prod"
$ENTRYPOINT = "lib/main.dart"

Write-Host "🛠️  Building AAB with FLAVOR=$FLAVOR ENTRYPOINT=$ENTRYPOINT"

$projectName = (Split-Path -Leaf (Get-Location)).Split("-")[0]
$currentDate = Get-Date -Format "dd-MM-yyyy"
$versionName = Select-String -Path "android/app/build.gradle" -Pattern 'versionName' | Select-Object -First 1 | ForEach-Object { ($_ -split '"')[1] }

# Kiểm tra fvm có sẵn hay không
$fvmExists = Get-Command "fvm" -ErrorAction SilentlyContinue
if ($fvmExists)
{
    $flutterCmd = "fvm flutter"
}
else
{
    $flutterCmd = "flutter"
}

$buildCmd = "$flutterCmd build appbundle --flavor $FLAVOR -t $ENTRYPOINT"
Write-Host "🚀 Running: $buildCmd"
Invoke-Expression $buildCmd

$outputDir = "build/app/outputs/bundle/${FLAVOR}Release"
$src = "$outputDir/app-${FLAVOR}-release.aab"
$dest = "$outputDir/${projectName}-$FLAVOR-v$versionName-$currentDate.aab"

if (Test-Path $src)
{
    if (Test-Path $dest)
    {
        Remove-Item $dest
    }
    Rename-Item -Path $src -NewName (Split-Path $dest -Leaf)
    Write-Host "✅ AAB renamed to: $dest"
    Start-Process -FilePath "explorer.exe" -ArgumentList "/select,`"$dest`""
}
else
{
    Write-Host "❌ AAB not found at: $src"
}
