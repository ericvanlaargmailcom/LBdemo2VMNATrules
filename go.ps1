[CmdletBinding()]
param(
    [string]$SubscriptionId = "ef17a603-a390-49bd-946c-cc18aa67f388",
    [string]$ResourceGroupName = "rg-loadbal-demo-belgiumcentral-001",
    [string]$Location = "belgiumcentral",
    [switch]$ValidateOnly
)

$ErrorActionPreference = "Stop"
Set-AzContext -SubscriptionId $SubscriptionId | Out-Null
New-AzResourceGroup -Name $ResourceGroupName -Location $Location | Out-Null

$deployment = @{
    ResourceGroupName = $ResourceGroupName
    TemplateFile = Join-Path $PSScriptRoot "deploy.json"
    TemplateParameterFile = Join-Path $PSScriptRoot "deployparam.json"
    adminPassword = Read-Host "VM administrator password" -AsSecureString
}

if ($ValidateOnly) {
    Test-AzResourceGroupDeployment @deployment
} else {
    New-AzResourceGroupDeployment @deployment -Verbose
}
