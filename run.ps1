if (!(Test-Path -path .state)) {
	1 | Out-File -FilePath .state
}
$State = Get-Content -Path .state

if ($State -eq 1) {
	Install-Module -Name PowerShellGet -Force
	Install-Module -Name posh-git -AllowPrerelease -Force

	Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

	choco feature enable -n allowGlobalConfirmation
	choco install googlechrome vscode firacode nodejs-lts yarn git docker-desktop insomnia-rest-api-client lightshot licecap notepadplusplus spotify discord

	yarn global add @adonisjs/cli matheuskprot

	Start-Process mkp -ArgumentList "create ls `"dir`"" -Wait -NoNewWindow
	mkdir $env:userprofile\Documents\NodeJS
	Start-Process mkp -ArgumentList "create:cd js `"$env:userprofile\Documents\NodeJS`"" -Wait -NoNewWindow

	Start-Process environment.bat -Wait -NoNewWindow
	SETX /M prompt "$('$E[1;32;40m')$([char]0x2192)$(' $E[1;36;40m$p$_$E[1;35;40m> $E[1;37;40m')"

	2 | Out-File -FilePath .state
	Read-Host O computador será reiniciado, após o processo execute novamente o script.
	Restart-Computer
}
elseif ($State -eq 2) {
	installColorTool
	installDocker
	installCorsair

	Copy-Item Microsoft.PowerShell_profile.ps1 -Destination $profile
	
	3 | Out-File -FilePath .state
	Read-Host O computador será reiniciado novamente, após o processo execute novamente o script.
	Restart-Computer
}
elseif ($State -eq 3) {
	Read-Host Tudo pronto, selecione a fonte Consolas no cmd/powershell
	Remove-Item -Force -Path ".state"
	exit
}
else {
	Read-Host Algo deu errado!
	exit
}

function installColorTool {
	Invoke-WebRequest https://raw.githubusercontent.com/dracula/powershell/master/dist/ColorTool.zip -o ColorTool.zip
	tar -xf ColorTool.zip
	Remove-Item /f ColorTool.zip
	Set-Location ColorTool
	Start-Process install.cmd -Wait -NoNewWindow
	Set-Location ..
	Remove-Item /s /q ColorTool
}

function installDocker {
	docker pull kartoza/postgis
	docker pull dpage/pgadmin4
	docker network create --driver bridge postgres-network
	docker run --name postgres --network=postgres-network -p 5432:5432 -d kartoza/postgis
	$pgEmail = Read-Host -Prompt 'Email para acesso ao pgadmin:'
	$pgPass = Read-Host -Prompt 'Senha para acesso ao pgadmin:'
	docker run --name pgadmin --network=postgres-network -p 15432:80 -e "PGADMIN_DEFAULT_EMAIL=$pgEmail" -e "PGADMIN_DEFAULT_PASSWORD=$pgPass" -d dpage/pgadmin4
}

function installCorsair {
	Invoke-WebRequest http://downloads.corsair.com/Files/Gaming-Headsets/CorsairHeadsetSetup_Release_2.0.36.msi -o Headset.msi
	Start-Process Headset.msi -Wait
	
	Invoke-WebRequest http://downloads.corsair.com/Files/CUE/iCUESetup_3.30.97_release.msi -o iCUE.msi
	Start-Process iCUE.msi -Wait

	Invoke-WebRequest https://elgato-edge.s3.amazonaws.com/corsairts-legacydownloads/K40%20setup%201.0.0.4%20120313.exe.zip -o K40.zip
	tar -xf K40.zip
	Remove-Item /f K40.zip
	Set-Location K40
	Rename-Item -Path "K40 setup 1.0.0.4 120313.exe" -NewName "K40.exe"
	Start-Process K40.exe -Wait
	Set-Location ..
	Remove-Item /s /q K40
}
