## PowerShell
- `Set-Location $env:userprofile\Downloads`
- `Set-ExecutionPolicy unrestricted`
- `Install-Module -Name PowerShellGet -Force`
- `Install-Module -Name posh-git -AllowPrerelease -Force`

- `Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))`
- `choco feature enable -n allowGlobalConfirmation`
- `choco upgrade googlechrome vscode firacode nodejs-lts yarn git docker-desktop insomnia-rest-api-client lightshot licecap notepadplusplus spotify discord`

- `yarn global add @adonisjs/cli matheuskprot`

- `mkp create ls "dir"`
- `mkdir $env:userprofile\Documents\NodeJS`
- `mkdir $env:userprofile\Documents\Sanep`
- `mkp create:cd js "$env:userprofile\Documents\NodeJS"`
- `mkp create:cd sanep "$env:userprofile\Documents\Sanep"`

- `SETX /M prompt "$('$E[1;32;40m')$([char]0x2192)$(' $E[1;36;40m$p$_$E[1;35;40m> $E[1;37;40m')"`
- Adicionar `Documents\Unix` nas variávies de ambiente PATH

- ### Color Tool
  - `Invoke-WebRequest https://raw.githubusercontent.com/dracula/powershell/master/dist/ColorTool.zip -o ColorTool.zip`
  - `tar -xf ColorTool.zip`
  - `Remove-Item ColorTool.zip -Force`
  - `Set-Location ColorTool`
  - `Start-Process ./install.cmd -Wait -NoNewWindow`
  - `Set-Location ..`
  - `Remove-Item ColorTool -Recurse -Force -Confirm:$false`

- ### Docker
  - `docker pull kartoza/postgis`
  - `docker pull dpage/pgadmin4`
  - `docker network create --driver bridge postgres-network`
  - `docker run --name postgres --network=postgres-network -p 5432:5432 -d kartoza/postgis`
  - `docker run --name pgadmin --network=postgres-network -p 15432:80 -e "PGADMIN_DEFAULT_EMAIL=Email" -e "PGADMIN_DEFAULT_PASSWORD=Pass" -d dpage/pgadmin4`

- ### Corsair
  - `Invoke-WebRequest http://downloads.corsair.com/Files/Gaming-Headsets/CorsairHeadsetSetup_Release_2.0.36.msi -o Headset.msi`
  - `Start-Process ./Headset.msi -Wait`
  - `Remove-Item Headset.msip -Force`
  - `Invoke-WebRequest http://downloads.corsair.com/Files/CUE/iCUESetup_3.30.97_release.msi -o iCUE.msi`
  - `Start-Process ./iCUE.msi -Wait`
  - `Remove-Item iCUE.msi -Force`
  - `Invoke-WebRequest https://elgato-edge.s3.amazonaws.com/corsairts-legacydownloads/K40%20setup%201.0.0.4%20120313.exe.zip -o K40.zip`
  - `tar -xf K40.zip`
  - `Remove-Item K40.zip -Force`
  - `Set-Location K40`
  - `Rename-Item -Path "K40 setup 1.0.0.4 120313.exe" -NewName "K40.exe"`
  - `Start-Process ./K40.exe -Wait`
  - `Set-Location ..`
  - `Remove-Item K40 -Recurse -Force -Confirm:$false`

- `Invoke-WebRequest https://raw.githubusercontent.com/MatheusKProt/windows/master/Microsoft.PowerShell_profile.ps1 -o Microsoft.PowerShell_profile.ps1`
- `Copy-Item Microsoft.PowerShell_profile.ps1 -Destination $profile`
- `powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61`
