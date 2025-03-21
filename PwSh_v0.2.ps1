## Script impide el acceso a PowerShell a usuarios no administradores
## ..:: Fvargasgrc ::..

$User01 = Get-LocalUser -Name "Usuario01" -ErrorAction SilentlyContinue
#$User02 = Get-LocalUser -Name "Usuario02" -ErrorAction SilentlyContinue
#takeown /f C:\Windows\System32\cmd.exe /A
takeown /f C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe /A
takeown /f C:\Windows\System32\WindowsPowerShell\v1.0\powershell_ise.exe /A
takeown /f C:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell.exe /A
takeown /f C:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell_ise.exe /A


if ($User01 -or $User02){
    if ($User01) {
        #icacls "C:\Windows\System32\cmd.exe" /deny "$($User01.Name):(RX)"
        icacls "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" /deny "$($User01.Name):(RX)" /T
        icacls "C:\Windows\System32\WindowsPowerShell\v1.0\powershell_ise.exe" /deny "$($User01.Name):(RX)" /T
        icacls "C:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell.exe" /deny "$($User01.Name):(RX)" /T
        icacls "C:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell_ise.exe" /deny "$($User01.Name):(RX)" /T

        #C:\Windows\SysWOW64\WindowsPowerShell\v1.0
    }
    # if ($User02) {
    #     icacls "C:\Windows\System32\cmd.exe" /deny "$($User02.Name):(RX)"
    #     icacls "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" /deny "$($User02.Name):(RX)"
    # }
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
    #VerificarPermisos -FilePath "C:\Windows\System32\cmd.exe" -UserName $User01.Name
    VerificarPermisos -FilePath "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -UserName $User01.Name
    VerificarPermisos -FilePath "C:\Windows\System32\WindowsPowerShell\v1.0\powershell_ise.exe" -UserName $User01.Name
    VerificarPermisos -FilePath "C:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell.exe" -UserName $User01.Name
    VerificarPermisos -FilePath "C:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell_ise.exe" -UserName $User01.Name
}

<# if ($User02) {
    VerificarPermisos -FilePath "C:\Windows\System32\cmd.exe" -UserName $User02.Name
    VerificarPermisos -FilePath "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -UserName $User02.Name
} #>

 # Denegar acceso a cada ejecutable
 foreach ($Path in $PowerShellPaths) {
    # Tomar posesión del archivo (manejo de errores)
    try {
        takeown /f $Path /A /F | Out-Null
        if ($LASTEXITCODE -ne 0) {
            Write-Error "Error al tomar posesión de '$Path'."
            continue  # Saltar al siguiente archivo si falla takeown
        }
    } catch {
        Write-Error "Excepción al tomar posesión de '$Path': $($_.Exception.Message)"
        continue
    }

    # Denegar permisos (manejo de errores)
    try {
        icacls $Path /deny "$($UserName):(RX)"
        if ($LASTEXITCODE -ne 0) {
            Write-Error "Error al denegar permisos en '$Path'."
            continue  # Saltar al siguiente archivo si falla icacls
        }
    } catch {
        Write-Error "Excepción al denegar permisos en '$Path': $($_.Exception.Message)"
        continue
    }

    # Verificar permisos
    VerificarPermisos $Path $UserName
}

Write-Host "El acceso a powershell.exe no esta permitido para usuarios no administradores, sorry "

Start-Sleep -Seconds 50