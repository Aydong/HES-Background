if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
        [Security.Principal.WindowsBuiltInRole] "Administrator")) {

    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = "powershell.exe"
    $psi.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    $psi.Verb = "runas"

    try {
        [Diagnostics.Process]::Start($psi) | Out-Null
    } catch {
        Write-Error "Élévation refusée."
    }
    exit
}

$scriptDir = Split-Path -Parent $PSCommandPath

$srcDesktop = Join-Path $scriptDir "FondHESSOVS.jpg"
$srcLock    = Join-Path $scriptDir "LockHESSOVS.png"

$dstDesktopDir = "C:\Windows\Web\Wallpaper\HESSOVS"
$dstDesktop    = Join-Path $dstDesktopDir "FondHESSOVS.jpg"
$dstLock       = "C:\Windows\Web\Screen\LockHESSOVS.png"

New-Item -ItemType Directory -Path $dstDesktopDir -Force | Out-Null

if (Test-Path $dstDesktop -PathType Leaf -and -not (Test-Path "$dstDesktop.bak")) {
    Copy-Item $dstDesktop "$dstDesktop.bak"
}
if (Test-Path $dstLock -PathType Leaf -and -not (Test-Path "$dstLock.bak")) {
    Copy-Item $dstLock "$dstLock.bak"
}

Copy-Item $srcDesktop $dstDesktop -Force
Copy-Item $srcLock    $dstLock    -Force

Write-Host "Images copiées :" -ForegroundColor Cyan
