###
###  Deploying Nested ESXi to Lab Environment
###
###  Created by: Timothy Matthews - Feb 10 2020
###
### Last Modified March 2nd 2020 - 8h38
###
###  Version 0.2
###

function New-NestedESXi {

    <#
    .SYNOPSIS
      PowerShell CMDLET to provision a new Nested ESXi server.
    .DESCRIPTION
      The New-NestedESXi Function takes the need to login to vCenter / ESXi Webgui to configure OVF Parameters, and makes them switches.
      Options include setting name, network (IPv4), root password, CPU, RAM, and Capacity/Cache disk sizes.
      Mandatory fields include: Name, IPaddress, netmask, Gateway, DNS, Domain, OVAFiles. All other values will have default values (e.g. password = vmware123), or the first object returned from ESXi hosts (e.g. datastore = first datastore reported).
      Need to import vmware.powercli before running this script.
      After Creation, the VM will automatically start by default.
    .EXAMPLE
     to be filled
  #>


    param(
        [Parameter(Mandatory=$true)][string]$Name,
        [Parameter(Mandatory=$true)][string]$IPaddress,
        [Parameter(Mandatory=$true)][string]$netmask,
        [Parameter(Mandatory=$true)][string]$Gateway,
        [Parameter(Mandatory=$true)][string]$DNS,
        [Parameter(Mandatory=$true)][string]$Domain,
        [Parameter(Mandatory=$true)][string]$OVAFiles,
        [Parameter(Mandatory=$false)][string]$Datastore,
        [Parameter(Mandatory=$false)][string]$PortGroup,
        [Parameter(Mandatory=$false)][string]$VMhost,
        [Parameter(Mandatory=$false)][string]$password,
        [Parameter(Mandatory=$false)][string]$VLAN,
        [Parameter(Mandatory=$false)][int]$RAM,
        [Parameter(Mandatory=$false)][int]$CPU,
        [Parameter(Mandatory=$false)][int]$Capacity,
        [Parameter(Mandatory=$false)][int]$Cache,
        [Parameter(Mandatory=$false)][boolean]$Start


    )

    if(!($Datastore)){
        $Datastore = (get-datastore)[0]
    }

    if(!($vmhost)){
        $vmhost = (get-vmhost)[0]
    }

    if(!($password)){
        $password = "vmware123"
    }

    if(!($PortGroup)){
        $PortGroup = Get-VDPortgroup[0]
        if (!$PortGroup) {
            $PortGroup = get-VirtualPortgroup[0]
        }
    }

    if(!($VLAN)){
        $VLAN = $null
    }

    if(!($RAM)){
        $RAM = 6
    }

    if(!($cpu)){
        $cpu = 2
    }

    if(!($Capacity)){
        $capacity = 8
    }

    if(!($Cache)){
        $cache = 4
    }

    if(!($start)){
        $start = $true
    }


    ## Set Local Credentials

    # Crete credential Object
    <#
    [SecureString]$securerootPassword = $password | ConvertTo-SecureString -AsPlainText -Force 
    [PSCredential]$credentialObeject = New-Object System.Management.Automation.PSCredential -ArgumentList "root", $securerootPassword

    $Localcreds = $credentialObeject

    #>

    ## Set OVF configuration:

    $ovfConfig = Get-OvfConfiguration $OVAFiles
    $ovfConfig.NetworkMapping.VM_Network_DVPG.Value = $PortGroup
    $ovfconfig.Common.guestinfo.hostname.value = $Name
    $ovfconfig.Common.guestinfo.ipaddress.value = $IPaddress
    $ovfconfig.Common.guestinfo.netmask.value = $netmask
    $ovfConfig.Common.guestinfo.gateway.value = $Gateway
    $ovfConfig.Common.guestinfo.vlan.Value = $VLAN
    $ovfConfig.Common.guestinfo.password.value = $Password
    $Ovfconfig.Common.guestinfo.ssh.value = $true
    $ovfconfig.Common.guestinfo.dns.value = $DNS
    $ovfconfig.Common.guestinfo.createvmfs.value = $false
    $ovfconfig.Common.guestinfo.domain.Value = $Domain
    $ovfconfig.Common.guestinfo.ntp.value = "10.100.50.189"
    $ovfconfig.Common.guestinfo.syslog.value = "10.100.50.189"


    $ESXI = Import-VApp -Source $OVAFiles -Name $Name -VMHost $vmhost -Datastore $datastore -DiskStorageFormat thin -OvfConfiguration $ovfConfig

    #set RAM + cpu

    $esxi | set-vm -numcpu $CPU -MemoryGB $RAM -confirm:$false

    #Set Capacity

    $esxi | Get-HardDisk | where-object { $_.capacityGB -eq 8 } | set-harddisk -CapacityGB $Capacity -confirm:$false

    $esxi | Get-HardDisk | where-object { $_.capacityGB -eq 4 } | set-harddisk -CapacityGB $Cache -confirm:$false

    if ($start -eq $true){
        Start-vm $esxi 
    }



}
