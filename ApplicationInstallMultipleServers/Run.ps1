$servers = Get-Content "D:\ApplicationInstallMultipleServers\Servers.txt"  --CHANGE D:\ WITH WHEREVER YOU DOWNLOAD IT.
$dest = "D$"   --CHANGE IT TO THE DESTINATION FOLDER PATH
$Path = "D:\ApplicationInstallMultipleServers\Source\{YOUR_APPLICATION_NAME.exe}"   --CHANGE D:\ WITH WHEREVER YOU DOWNLOAD IT


foreach($server in $servers)
{
	if(test-Connection -Cn $server -quiet)
	{
		copy-Item -Path $Path -Destination "\\$server\$dest" -Recurse -Force
		Invoke-Command -ComputerName $server -ScriptBlock {Start-Process $Path -ArgumentList '/q' -wait}
		Write-Host -ForegroundColor Green "Installation successful on $server"
	}
	else
	{
		Write-Host -ForegroundColor Red "$server is not online, installation failed"
	}
}	
