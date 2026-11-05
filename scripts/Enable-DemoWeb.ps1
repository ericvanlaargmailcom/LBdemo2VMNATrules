$ErrorActionPreference = 'Stop'
$result = Install-WindowsFeature -Name Web-Server -IncludeManagementTools
if (-not $result.Success) {
    throw 'IIS installation failed.'
}
Set-Content -Path C:\inetpub\wwwroot\index.html -Value "<html><body><h1>$env:COMPUTERNAME</h1></body></html>" -Encoding UTF8
Start-Service W3SVC
$response = Invoke-WebRequest -Uri http://localhost/index.html -UseBasicParsing
if ($response.StatusCode -ne 200 -or $response.Content -notmatch $env:COMPUTERNAME) {
    throw 'The local HTTP check failed.'
}
Write-Output "IIS ready on $env:COMPUTERNAME; local HTTP status $($response.StatusCode)"
