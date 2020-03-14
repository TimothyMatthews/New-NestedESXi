# New-NestedESXi

New-NestedESXi is a Powershell Function that uses PowerCli to create a new Nested ESXi server. Its a much easier way to deploy the OVF file and specifiy parameters like IP, CPU, RAM, and Cache/Capacity disks for nested vSAN deployments. This is for **LAB PURPOSSES ONLY**. Nested ESXi is not supported by VMware.

## Installation

Copy the New-NestedESXi.psm1 file to your modules folder or working folder. In your script, import the module using import-module

```PowerShell
import-module New-NestedESXi.psm1
```

Or in your working folder:

```PowerShell
import-module .\New-NestedESXi.psm1
```

## Usage
Bare Minimum Parameters for usage:

```PowerShell
import-module New-NestedESXi
import-module vmware.powercli

Connect-viserver "Vcenter/esxi to deploy to"

New-NestedESXi -Name "VMNAME" -IPaddress "IP ADDRESS" -netmask "NETMASK" -Gateway "Default Gateway" -DNS "DNS Server IP" -Domain "Domain Name" -OVAFiles "Localtion of OVA files"

```
This will deploy a nested ESXi on the first datastore, portgroup, Host found when querying the environment, along with no VLAN, and the default password of 'vmware123'.

## Arguments

**-Name**
Name of the VM as seen in vSphere

**-IPaddress**
IP address of the first VMK interface

**-netmask**
Subnet mask (ex: 255.255.255.0)

**-Gateway**
Default Gateway

**-DNS**
DNS servers

**-Domain**
Domain information

**-OVAFiles**
Location of the OVA files, Please use the excellent OVA files on Willim Lam's blog, Virtually Ghetto: https://www.virtuallyghetto.com/2018/04/nested-esxi-6-7-virtual-appliance-updates.html


**-Datastore**
Name of the datastore to store the VM. Default is the first Datastore found in the deployment environment.

**-PortGroup**
Port Group where the NIC will connect to. Default is the first Virtual port group found in the deployment environment.

**-VMhost**
Host where the VM will run on. Default is the first host found in the deployment environment.

**-password**
Password to login to ESXi host. Default is "vmware123".

**-VLAN**
VLAN for the first VMK port. Default is 0 (none).

**-RAM**
Sets the RAM on the VM. Default is 6 GB.

**-CPU**
Sets the number of vCpu on the VM. Default is 2.

**-Capacity**
Sets the Hard disk size for the Capacity disk if using nested vSAN. Default is 8 GB.

**-Cache**
Sets the Hard disk size for the Cache disk if using nested vSAN. Default is 4 GB.

**-Start**
If set to true, it will start the VM right after creation. Default is false

