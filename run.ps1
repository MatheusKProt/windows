function installColorTool {
	Invoke-WebRequest https://raw.githubusercontent.com/dracula/powershell/master/dist/ColorTool.zip -o ColorTool.zip
	tar -xf ColorTool.zip
	Remove-Item ColorTool.zip -Force
	Set-Location ColorTool
	Start-Process ./install.cmd -Wait -NoNewWindow
	Set-Location ..
	Remove-Item ColorTool -Recurse -Force -Confirm:$false
}

function installDocker {
	docker pull kartoza/postgis
	docker pull dpage/pgadmin4
	docker pull redis
	docker pull mysql
	docker network create --driver bridge network
	docker run --name postgres --network=network -p 5432:5432 -d kartoza/postgis
	$pgEmail = Read-Host -Prompt 'Email para acesso ao pgadmin'
	$pgPass = Read-Host -Prompt 'Senha para acesso ao pgadmin'
	docker run --name pgadmin --network=network -p 15432:80 -e "PGADMIN_DEFAULT_EMAIL=$pgEmail" -e "PGADMIN_DEFAULT_PASSWORD=$pgPass" -d dpage/pgadmin4
	docker run --name redis --network=network -p 6379:6379 -d redis
	docker run --name mysql --network=network -e MYSQL_ROOT_PASSWORD=M@th579264589eus -d mysql
}

function installCorsair {
	Invoke-WebRequest http://downloads.corsair.com/Files/CUE/iCUESetup_3.30.97_release.msi -o iCUE.msi
	Start-Process ./iCUE.msi -Wait
	Remove-Item iCUE.msi -Force

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
	
	choco upgrade googlechrome 
	choco upgrade vscode 
	choco upgrade firacode 
	choco upgrade nodejs-lts 
	choco upgrade yarn 
	choco upgrade git 
	choco upgrade docker-desktop 
	choco upgrade insomnia-rest-api-client 
	choco upgrade lightshot 
	choco upgrade licecap 
	choco upgrade notepadplusplus 
	choco upgrade spotify 
	choco upgrade discord
	choco upgrade slack
	choco upgrade zoom
	choco upgrade arduino
	choco upgrade mysql.workbench
}

if (!(Test-Path -path .state)) {
	1 | Out-File -FilePath .state
}
$State = Get-Content -Path .state

if ($State -eq 1) {
	Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Bypass -Force
	Install-Module -Name PowerShellGet -Force
	2 | Out-File -FilePath .state
	Read-Host Feche o terminal e execute novamente o script
	exit
}
elseif ($State -eq 2) {
	Install-Module -Name posh-git -AllowPrerelease -Force

	installchoco
	
	yarn global add @adonisjs/cli matheuskprot

	mkdir $env:userprofile\Documents\NodeJS
	mkdir $env:userprofile\Documents\EXEHDA
	Start-Process mkp -ArgumentList "create:cd js `"$env:userprofile\Documents\NodeJS`"" -Wait -NoNewWindow
	Start-Process mkp -ArgumentList "create:cd exehda `"$env:userprofile\Documents\EXEHDA`"" -Wait -NoNewWindow
	Start-Process mkp -ArgumentList "create ls `"dir`"" -Wait -NoNewWindow

	Start-Process ./environment.bat -Wait -NoNewWindow
	SETX /M prompt "$('$E[1;32;40m')$([char]0x2192)$(' $E[1;36;40m$p$_$E[1;35;40m> $E[1;37;40m')"
	
	installWSL

	3 | Out-File -FilePath .state
	Read-Host O computador sera reiniciado, apos o processo execute novamente o script.
	Restart-Computer
}
elseif ($State -eq 3) {
	installWSLTwo
	installColorTool
	installDocker
	installCorsair

	Copy-Item Microsoft.PowerShell_profile.ps1 -Destination $profile
	powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
	powercfg /hibernate off
	
	Remove-Item -Force -Path ".state"
	Read-Host Tudo pronto
	exit
}
else {
	Read-Host Algo deu errado!
	exit
}
