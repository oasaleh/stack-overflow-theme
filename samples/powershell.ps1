## Define the service name in a variable
$ServiceName = 'EventLog'

## Read the service from Windows to return a service object
$ServiceInfo = Get-Service -Name $ServiceName

## If the server is not running (ne)
if ($ServiceInfo.Status -ne 'Running')
{
    ## Write to the console that the service is not running
    Write-Host 'Service is not started, starting service'
    ## Start the service
    Start-Service -Name $ServiceName
    ## Update the $ServiceInfo object to reflect the new state
    $ServiceInfo.Refresh()
    ## Write to the console the Status property which indicates the state of the service
    Write-Host $ServiceInfo.Status
}
else
{
    ## If the Status is anything but Running
    ## Write to the console the service is already running
    Write-Host 'The service is already running.'
}

## Defines three registry key paths in an array
$tls10 = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server', 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Client'

## Checks to see if all of the registry keys in the array exists
$tls10check = ($tls10 | Test-Path) -notcontains $false

## If all of the registry keys exist
if ($tls10check -eq $True)
{
    ## Updates four different DWORD registry values to either 0 or 1
    Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server' -Name 'Enabled' -Value '0' -Type 'DWORD'
    Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server' -Name 'DisabledByDefault' -Value '1' -Type 'DWORD'
    Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Client' -Name 'Enabled' -Value '0' -Type 'DWORD'
    Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Client' -Name 'DisabledByDefault' -Value '1' -Type 'DWORD'
}
else
{
    ## If at least one of the registry keys do not exist
    ## Creates the missing registry keys skipping the confirmation (Force)
    New-Item 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server' -Force
    New-Item 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Client' -Force
	
    ## Creates four different DWORD registry values setting the value to either 0 or 1
    New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server' -Name 'Enabled' -Value '0' -Type 'DWORD'
    New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server' -Name 'DisabledByDefault' -Value '1' -Type 'DWORD'
    New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Client' -Name 'Enabled' -Value '0' -Type 'DWORD'
    New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Client' -Name 'DisabledByDefault' -Value '1' -Type 'DWORD'
}