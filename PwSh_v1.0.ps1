# Obtener el usuario
$User01 = Get-LocalUser -Name "Usuario01" -ErrorAction SilentlyContinue
$User02 = Get-LocalUser -Name "Usuario02" -ErrorAction SilentlyContinue


# Cambiar la propiedad de los archivos
takeown /f C:\Windows\System32\cmd.exe /A
takeown /f C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe /A
takeown /f C:\Windows\System32\WindowsPowerShell\v1.0\powershell_ise.exe /A
takeown /f C:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell.exe /A
takeown /f C:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell_ise.exe /A

# Función para encontrar wt.exe en WindowsApps
function Find-WTExe {
    $windowsAppsPath = "C:\Program Files\WindowsApps"
    $wtExePath = Get-ChildItem -Path $windowsAppsPath -Recurse -Filter "wt.exe" | Select-Object -First 1
    return $wtExePath.FullName
}

# Ruta de wt.exe
$wtExePath = Find-WTExe

if ($wtExePath) {
    takeown /f $wtExePath /A
    if ($User01) {
        icacls $wtExePath /deny "$($User01.Name):(RX)"
    }
}

if ($User01 -or $User02){
    if ($User01) {
    # Denegar permisos para el usuario01
        icacls "C:\Windows\System32\cmd.exe" /deny "$($User01.Name):(RX)"
        icacls "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" /deny "$($User01.Name):(RX)"
        icacls "C:\Windows\System32\WindowsPowerShell\v1.0\powershell_ise.exe" /deny "$($User01.Name):(RX)"
        icacls "C:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell.exe" /deny "$($User01.Name):(RX)"
        icacls "C:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell_ise.exe" /deny "$($User01.Name):(RX)"


    }
     if ($User02) {
        icacls "C:\Windows\System32\cmd.exe" /deny "$($User02.Name):(RX)"
        icacls "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" /deny "$($User02.Name):(RX)"
        icacls "C:\Windows\System32\WindowsPowerShell\v1.0\powershell_ise.exe" /deny "$($User02.Name):(RX)"
        icacls "C:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell.exe" /deny "$($User02.Name):(RX)"
        icacls "C:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell_ise.exe" /deny "$($User02.Name):(RX)"
     }
}

# Función para verificar permisos
function VerificarPermisos {
    param (
        [string]$FilePath,
        [string]$UserName
    )

    $acl = icacls $FilePath
    $aclString = $acl -join "`r`n" # Convierte el array de strings a una sola cadena
    if ($aclString -match "${UserName}:$DENY$$RX$") {
        Write-Host "Se han denegado permisos para $UserName en $FilePath" -ForegroundColor Green
    } else {
        Write-Host "No se han denegado los permisos para $UserName en $FilePath" -ForegroundColor Red
    }
}

# Verificar los permisos para Usuario0
if ($User01 -or $User02){
    if ($User01) {
        VerificarPermisos -FilePath "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -UserName $User01.Name
        VerificarPermisos -FilePath "C:\Windows\System32\WindowsPowerShell\v1.0\powershell_ise.exe" -UserName $User01.Name
        VerificarPermisos -FilePath "C:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell.exe" -UserName $User01.Name
        VerificarPermisos -FilePath "C:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell_ise.exe" -UserName $User01.Name
        if ($wtExePath) {
            VerificarPermisos -FilePath $wtExePath -UserName $User01.Name
        }
    }
    if ($User02){
        VerificarPermisos -FilePath "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -UserName $User01.Name
        VerificarPermisos -FilePath "C:\Windows\System32\WindowsPowerShell\v1.0\powershell_ise.exe" -UserName $User01.Name
        VerificarPermisos -FilePath "C:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell.exe" -UserName $User01.Name
        VerificarPermisos -FilePath "C:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell_ise.exe" -UserName $User01.Name
        if ($wtExePath) {
            VerificarPermisos -FilePath $wtExePath -UserName $User01.Name
        }
    }
}

Write-Host "El acceso a powershell.exe no esta permitido para usuarios no administradores, sorry "

Start-Sleep -Seconds 50