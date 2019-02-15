function Get-AccountStatus([string]$username)
{
	if($username)
	{
		$output = (Get-ADUser $username -Properties * | 
		select SamAccountName,LockedOut,BadLogonCount,@{N='badPasswordTime'; E={[DateTime]::FromFileTime($_.badPasswordTime)}}) | Out-string

        Write-Host $output

        $status = (Get-ADUser "jose.carro" -Properties *).LockedOut
        if($status)
        {
            Write-host "Deseja desbloquear a conta" -ForegroundColor Yellow 
            $Readhost = Read-Host " ( s / n ) " 
            Write-Host ""
            Switch ($ReadHost) 
            { 
               S {Write-host "Sim, conta $username desbloqueada "; Unlock-ADAccount $username} 
               N {Write-Host "N�o, conta $username continua bloqueada"} 
               Default {Write-Host "Op��o inv�lida!"} 
            } 
        }

	}
	else
	{
		Write-Host ""
		Write-Host -ForegroundColor Yellow "Informe o login do usu�rio!"
		Write-Host ""
	}
}