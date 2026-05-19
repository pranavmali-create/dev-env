$kanata_URL = "https://github.com/jtroo/kanata/releases/download/v1.11.0/windows-binaries-x64.zip" 
$my_config = "https://raw.githubusercontent.com/pranavmali-create/kanata-config/refs/heads/main/kanata.kbd"

$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$adminRole = [Security.Principal.WindowsBuiltInRole]::Administrator
if (-not $currentPrincipal.IsInRole($adminRole)) {
    # If not Admin, relaunch as Admin
    Write-Host "Elevating privileges..." -ForegroundColor Cyan
    Start-Process powershell.exe -Verb RunAs -ArgumentList "-File `"$PSCommandPath`""
    exit
}
if(Get-Command "kanata.exe" -ErrorAction SilentlyContinue) {
    Write-Host "kanata is installed"
    } 
else{
    mkdir "C:\tools\kanata"
    Invoke-WebRequest -Uri "$kanata_URL" -OutFile "C:\tools\kanata\kanata.zip"
    Expand-Archive -Path "C:\tools\kanata\kanata.zip" -DestinationPath "C:\tools\kanata" 
}

    Invoke-WebRequest -Uri "$my_config" -OutFile "C:\tools\kanata\kanata.kbd"

    & "C:\tools\kanata\kanata_windows_tty_winIOv2_x64.exe" --cfg "C:\tools\kanata\kanata.kbd"
