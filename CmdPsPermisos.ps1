## Script impide el acceso a CMD y a PowerShell a usuarios no administradores
## ..:: Fvargasgrc ::..

$User01 = Get-LocalUser -Name "Usuario01" -ErrorAction SilentlyContinue
$User02 = Get-LocalUser -Name "Usuario02" -ErrorAction SilentlyContinue
takeown /f C:\Windows\System32\cmd.exe /A
takeown /f C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe /A


if ($User01 -or $User02){
    if ($User01) {
        icacls "C:\Windows\System32\cmd.exe" /deny "$($User01.Name):(RX)"
        icacls "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" /deny "$($User01.Name):(RX)"
    }
    if ($User02) {
        icacls "C:\Windows\System32\cmd.exe" /deny "$($User02.Name):(RX)"
        icacls "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" /deny "$($User02.Name):(RX)"
    }
}


# Revisamos que se haya aplicado bien los nuevos permisos
function VerificarPermisos {
    param (
        [string]$FilePath,
        [string]$UserName
    )

    $acl = icacls $FilePath
    $aclString = $acl -join "`r`n" # Convierte el array de strings a una sola cadena
    if ($aclString -match "${UserName}:\(DENY\)\(RX\)") {
        Write-Host "Permisos denegados para $UserName en $FilePath" -ForegroundColor Green
    } else {
        Write-Host "Permisos NO denegados para $UserName en $FilePath" -ForegroundColor Red
    }
}

# Verifica los permisos para Usuario01 y Usuario02
if ($User01) {
    VerificarPermisos -FilePath "C:\Windows\System32\cmd.exe" -UserName $User01.Name
    VerificarPermisos -FilePath "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -UserName $User01.Name
}

if ($User02) {
    VerificarPermisos -FilePath "C:\Windows\System32\cmd.exe" -UserName $User02.Name
    VerificarPermisos -FilePath "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -UserName $User02.Name
}

Write-Host "El acceso a cmd.exe y powershell.exe no esta permitido para usuarios no administradores, sorry "

Start-Sleep -Seconds 5