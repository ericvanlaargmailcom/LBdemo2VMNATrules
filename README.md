# LBdemo2VMNATrules

This demo creates a public load balancer and two Windows Server 2022 Datacenter VMs (Desktop Experience) in its backend pool.

## Windows image

The default image is `MicrosoftWindowsServer:WindowsServer:2022-datacenter:latest` (Generation 1). Both VMs use this image through the existing VM copy loop. The version stays within Windows Server 2022.

## RDP through inbound NAT

Connect to the load balancer's public IP address or DNS name:

| Frontend endpoint | Backend target |
| --- | --- |
| `<load-balancer-public-IP>:50001` | `lbVM0:3389` |
| `<load-balancer-public-IP>:50002` | `lbVM1:3389` |

The VM names above use the default `vmNamePrefix`. The HTTP load-balancing rule and health probe remain on TCP port 80. Install and configure a web server on each VM for the HTTP demonstration.

Changing the image default affects new deployments; it does not perform an in-place upgrade of existing Windows VMs. Use a fresh demo resource group for a new OS deployment.

## Deployment

`go.ps1` targets the MSDN subscription and `rg-loadbal-demo-belgiumcentral-001` in Belgium Central by default. Override `-SubscriptionId`, `-ResourceGroupName`, or `-Location` when needed. West Europe rejected this subscription with `RequestDisallowedByAzure` (region not accepting new customers).

```powershell
./go.ps1 -ValidateOnly
./go.ps1
```

The default VM size is `Standard_D2s_v5`, with managed Standard SSD OS disks. Networking uses a Standard Load Balancer, Standard static public IP, a subnet NSG, and an explicit outbound rule. HTTP port 80 is public; RDP is allowed only from `rdpSourceAddressPrefix` in `deployparam.json`. Set that parameter to your current public IP with `/32` before deployment. NSG rules use the backend RDP port 3389, after inbound NAT translation.

The parameter file omits `adminPassword`. `go.ps1` prompts for it as a SecureString for validation and deployment. When using Azure CLI directly, supply this required parameter securely.

Validation does not guarantee VM capacity or a successful deployment. The web server must be installed on both VMs before the port 80 health probe and HTTP load balancing can succeed.

## HTTP smoke test

After deployment, install IIS and a page identifying each VM using the included script:

```sh
az vm run-command invoke --subscription ef17a603-a390-49bd-946c-cc18aa67f388 -g rg-loadbal-demo-belgiumcentral-001 -n lbVM0 --command-id RunPowerShellScript --scripts @scripts/Enable-DemoWeb.ps1
az vm run-command invoke --subscription ef17a603-a390-49bd-946c-cc18aa67f388 -g rg-loadbal-demo-belgiumcentral-001 -n lbVM1 --command-id RunPowerShellScript --scripts @scripts/Enable-DemoWeb.ps1
```

Request `http://<load-balancer-public-IP>/index.html` over separate connections to exercise both backends. A load balancer does not guarantee alternating responses. RDP endpoints are `<load-balancer-public-IP>:50001` and `:50002`.
