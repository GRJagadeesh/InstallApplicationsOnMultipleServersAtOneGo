$servers = Get-Content "D:\ApplicationInstallMultipleServers\Servers.txt"

foreach($server in $servers)
{
	if(test-Connection -Cn $server -quiet)
	{
		Invoke-Command -ComputerName $server -ScriptBlock {
        $computerOS = Get-WmiObject -Class Win32_OperatingSystem | Select-Object CSName
        $ComputerN = $computerOS.CSName
		$info = Get-ChildItem ‘HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP’ -Recurse -ErrorAction SilentlyContinue |
        Get-ItemProperty -name Version, Release -EA 0 |
        Where-Object { $_.PSChildName -eq “Full”} | Select-Object Version
        $netversion = $info.Version
        New-Object -TypeName PSObject -Property @{
        “ComputerName” = $ComputerN
        “DotNetFramework” = $netversion
        } | Select-Object ComputerName, DotNetFramework | FT
		}
	}
	else
	{
		Write-Host -ForegroundColor Red "$server is not online, unable to connect"
	}
}	