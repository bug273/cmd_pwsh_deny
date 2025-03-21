$User01 = Get-LocalUser -Name "Usuario01" -ErrorAction SilentlyContinue

takeown /f C:\Windows\System32\cmd.exe /A
takeown /f C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe /A
takeown /f C:\Windows\System32\WindowsPowerShell\v1.0\powershell_ise.exe /A
takeown /f C:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell.exe /A
takeown /f C:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell_ise.exe /A


if ($User01 -or $User02){
    if ($User01) {
        #icacls "C:\Windows\System32\cmd.exe" /deny "$($User01.Name):(RX)"
        icacls "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" /deny "$($User01.Name):(RX)"
        icacls "C:\Windows\System32\WindowsPowerShell\v1.0\powershell_ise.exe" /deny "$($User01.Name):(RX)"
        icacls "C:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell.exe" /deny "$($User01.Name):(RX)"
        icacls "C:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell_ise.exe" /deny "$($User01.Name):(RX)"

        # C:\Windows\SysWOW64\WindowsPowerShell\v1.0
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
        Write-Host "Se han denegado permisos para $UserName en $FilePath" -ForegroundColor Green
    } else {
        Write-Host "No se han denegado los permisos para $UserName en $FilePath" -ForegroundColor Red
    }
}

# Verifica los permisos para Usuario01 y Usuario02
if ($User01) {
    VerificarPermisos -FilePath "C:\Windows\System32\cmd.exe" -UserName $User01.Name
    VerificarPermisos -FilePath "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -UserName $User01.Name
    VerificarPermisos -FilePath "C:\Windows\System32\WindowsPowerShell\v1.0\powershell_ise.exe" -UserName $User01.Name
    VerificarPermisos -FilePath "C:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell.exe" -UserName $User01.Name
    VerificarPermisos -FilePath "C:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell_ise.exe" -UserName $User01.Name
}
