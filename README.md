# New-NestedESXi

New-NestedESXi is a Powershell Function that uses PowerCli to create a new Nested ESXi server. Its a much easier way to deploy the OVF file and specifiy parameters like IP, CPU, RAM, and Cache/Capacity disks for nested vSAN deployments.

## Installation

Copy the New-NestedESXi.psm1 file to your modules folder and in your script, import the module using import-module

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

## Contributing

To be filled

## License
To be filled