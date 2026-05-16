if(Get-Command "kanata.exe" -ErrorAction SilentlyContinue) {
    Write-Host "kanata is installed"
    } 
else{
    mkdir "C:\tools\kanata"
    Invoke-WebRequest -Uri "kanata_windows_binaryvariant.exe" -OutFile "C:\tools\kanata"
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/pranavmali-create/kanata-config/refs/heads/main/kanata.kbd" -OutFile "C:\tools\kanata"

}
