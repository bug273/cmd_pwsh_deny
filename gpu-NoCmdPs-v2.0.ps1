#Restringir permisos a CMD y Powershell
##  ..:: Fvargasgrc  ::..

#empezamos con usuario01
$usuario = "usuario01"

#Ruta de la clave del registro para cmd
$rutaCmd = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System\cmd.exe"

#Ruta de la clave del registro para PowerShell
$rutaPS = "HKLM:\SOFTWARE\Policies\Microsoft\PowerShell"

#Crear la clave del registro para cmd si no existe
if (-Not (Test-Path -Path $rutaCmd)) {
    New-Item -Path $rutaCmd -Force
}

#Crear la clave del registro para PowerShell si no exite
if (-Not (Test-Path -Path $rutaPS)){
    New-Item -Path $rutaPS -Force
}

#Deshabilitar CMD para usuario1
Set-ItemProperty -Path $rutaCmd -Name "DisableCMD" -Value 1 -Force
Set-ItemProperty -Path $rutaCmd -Name "UserList" -Value $usuario -Force

#Deshabilitar PS para usuario1
Set-ItemProperty -Path $rutaPS -Name "DisablePowerShell" -Value 1 -Force
Set-ItemProperty -Path $rutaPS -Name "UserList" -Value $usuario -Force

#se aplica la politica de grupo
gpupdate /force 

Write-Host "El acceso a CMD y PowerShell esta limitado. Por favor contacta con un Administrador"