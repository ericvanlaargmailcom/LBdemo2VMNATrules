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

## Legacy networking

This template still uses legacy network API versions and does not explicitly select a load balancer or public IP SKU (the legacy Basic defaults). Basic Load Balancer and Basic public IPs have been retired. A new deployment needs a separate networking update to Standard SKU, including a static public IP and suitable NSG rules. The Windows image update alone does not modernize these network resources.
