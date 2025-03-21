## Bloquear el acceso a PS ##
##  …:::  Fvargasgar   :::...


# Importar módulo de LGPO
Import-Module GroupPolicy

# A quién va a afectar
$User01 = Get-LocalUser -Name "Usuario01" -ErrorAction SilentlyContinue
# $User02 = Get-LocalUser -Name "Usuario02" -ErrorAction SilentlyContinue

# takeown /f C:\Windows\System32\cmd.exe /A
takeown /f C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe /A
takeown /f C:\Windows\System32\WindowsPowerShell\v1.0\powershell_ise.exe /A
takeown /f C:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell.exe /A
takeown /f C:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell_ise.exe /A

# Crear la Directiva de Grupo (GPO)
$gpoName = "RestringirPS$User01"
New-GPO -Name $gpoName -Comment "Deshabilita PS para $User01"

# Aplicar la GPO al usuario específico
Set-GPPermission -Name $gpoName -TargetName $User01 -PermissionLevel GpoEdit

# Configurar la directiva para restringir el acceso a PowerShell
Set-GPRegistryValue -Name $gpoName -Key "HKLM\SOFTWARE\Policies\Microsoft\Windows\PowerShell" -ValueName "DisablePowerShell" -Value 1 -Type DWord

# Actualizar las políticas de grupo
gpupdate /force


Write-Host "El acceso a powershell.exe no esta permitido para usuarios no administradores, sorry "

Start-Sleep -Seconds 40