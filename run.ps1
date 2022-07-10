function installColorTool {
	Invoke-WebRequest https://raw.githubusercontent.com/dracula/powershell/master/dist/ColorTool.zip -o ColorTool.zip
	tar -xf ColorTool.zip
	Remove-Item ColorTool.zip -Force
	Set-Location ColorTool
	Start-Process ./install.cmd -Wait -NoNewWindow
	Set-Location ..
	Remove-Item ColorTool -Recurse -Force -Confirm:$false
}

function installCorsair {
	Invoke-WebRequest https://elgato-edge.s3.amazonaws.com/corsairts-legacydownloads/K40%20setup%201.0.0.4%20120313.exe.zip -o K40.zip
	tar -xf K40.zip
	Remove-Item K40.zip -Force
	Rename-Item -Path "K40 setup 1.0.0.4 120313.exe" -NewName "K40.exe"
	Start-Process ./K40.exe -Wait
	Remove-Item K40.exe -Force
}

function installWSL {
	dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
	dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
}

function installWSLTwo {
	Invoke-WebRequest https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi -o wsl.msi
	Start-Process ./wsl.msi -Wait
	Remove-Item wsl.msi -Force
	wsl --set-default-version 2
}

function installchoco {
	Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
	choco feature enable -n allowGlobalConfirmation
	
	choco upgrade googlechrome             --install-arguments="'/DIR=Z:\chrome'"
	choco upgrade vscode                   --install-arguments="'/DIR=Z:\vscode'"
	choco upgrade firacode                 --install-arguments="'/DIR=Z:\firacode'"
	choco upgrade nodejs-lts               --install-arguments="'/DIR=Z:\nodejs'"
	choco upgrade yarn                     --install-arguments="'/DIR=Z:\yarn'"
	choco upgrade git                      --install-arguments="'/DIR=Z:\git'"
	choco upgrade insomnia-rest-api-client --install-arguments="'/DIR=Z:\insomnia'"
	choco upgrade lightshot                --install-arguments="'/DIR=Z:\lightshot'"
	choco upgrade licecap                  --install-arguments="'/DIR=Z:\licecap'"
	choco upgrade notepadplusplus          --install-arguments="'/DIR=Z:\notepad'"
	choco upgrade spotify                  --install-arguments="'/DIR=Z:\spotify'"
	choco upgrade discord                  --install-arguments="'/DIR=Z:\discord'"
	choco upgrade slack                    --install-arguments="'/DIR=Z:\slack'"
	choco upgrade zoom                     --install-arguments="'/DIR=Z:\zoom'"
	choco upgrade mysql.workbench          --install-arguments="'/DIR=Z:\workbench'"
}

if (!(Test-Path -path .state)) {
	1 | Out-File -FilePath .state
}
$State = Get-Content -Path .state

if ($State -eq 1) {
	Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Bypass -Force
	Install-Module -Name PowerShellGet -Force
	2 | Out-File -FilePath .state
	Read-Host Feche o terminal e execute o script novamente.
	exit
}
elseif ($State -eq 2) {
	Install-Module -Name posh-git -AllowPrerelease -Force

	installchoco
	
	yarn global add @adonisjs/cli

	Start-Process ./environment.bat -Wait -NoNewWindow
	SETX /M prompt "$('$E[1;32;40m')$([char]0x2192)$(' $E[1;36;40m$p$_$E[1;35;40m> $E[1;37;40m')"
	
	installWSL

	3 | Out-File -FilePath .state
	Read-Host O computador sera reiniciado, após execute o script novamente.
	Restart-Computer
}
elseif ($State -eq 3) {
	installWSLTwo
	installColorTool
	installCorsair

	Copy-Item Microsoft.PowerShell_profile.ps1 -Destination $profile
	powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
	powercfg /hibernate off
	
	Remove-Item -Force -Path ".state"
	Read-Host Tudo pronto!
	exit
}
else {
	Remove-Item -Force -Path ".state"
	Read-Host Algo deu errado, tente novamente!
	exit
}
