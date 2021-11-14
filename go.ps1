$msdnsub = "9c108632-3066-4862-b0db-b34e82ba633d"
$rg = "rg-loadbal-demo-westeurope-001"
$location = "westeurope"

Set-AzContext -Subscription $msdnsub

New-AzResourceGroup -Name $rg -Location $location -verbose

New-AzResourceGroupDeployment `
-ResourceGroupName $rg `
-TemplateURI ./deploy.json `
-TemplateParameterFile ./deployparam.json `
-Verbose

read-host "Press enter to cleanup the demo"
Remove-AzResourceGroup -Name NetworkWatcherRG -Force -verbose
Remove-AzResourceGroup -Name $rg -Force -verbose