## Bloquear el acceso a PS ##
##  ...:::  Fvargasgar   :::...

# Definir el nombre del usuario
$usuario = "Usuario01"

# Ruta del registro para deshabilitar PowerShell
$registryPath = "HKCU:\Software\Policies\Microsoft\Windows\PowerShell"

# Crear la clave del registro si no existe
if (-not (Test-Path -Path $registryPath)) {
    New-Item -Path $registryPath -Force
}

# Establecer el valor para deshabilitar PowerShell
Set-ItemProperty -Path $registryPath -Name "DisablePowerShell" -Value 1 -Type DWord

# Aplicar la configuración al usuario específico
$userProfilePath = [System.IO.Path]::Combine($env:SystemDrive, "Users", $usuario)
$userRegistryPath = "HKU\$($usuario)\Software\Policies\Microsoft\Windows\PowerShell"

# Crear la clave del registro si no existe
if (-not (Test-Path -Path $userRegistryPath)) {
    New-Item -Path $userRegistryPath -Force
}

# Establecer el valor para deshabilitar PowerShell
Set-ItemProperty -Path $userRegistryPath -Name "DisablePowerShell" -Value 1 -Type DWord

# Mensaje de confirmación
Write-Host "El acceso a powershell.exe no esta permitido para usuarios no administradores, sorry "

Start-Sleep -Seconds 40