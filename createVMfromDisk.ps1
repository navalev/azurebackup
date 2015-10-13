Add-AzureAccount
Select-AzureSubscription 

Switch-AzureMode AzureResourceManager

## Global
$rgName = Read-Host -Prompt 'Enter Resource Group Name'
$location = Read-Host -Prompt 'Enter data center location' #"northeurope"

## Storage
$storageName = Read-Host -Prompt 'Enter storage account name'
$storageType = Read-Host -Prompt 'Enter storage type' #"Standard_GRS"

## Network
$nicname = Read-Host -Prompt 'Enter nic name'
$subnet1Name = "subnet1"
$vnetName = Read-Host -Prompt 'Enter vnet name'
$vnetAddressPrefix = "10.0.0.0/16"
$vnetSubnetAddressPrefix = "10.0.0.0/24"

## Compute
$vmName = Read-Host -Prompt 'Enter Virtual Machine name'
$computerName = Read-Host -Prompt 'Enter computer name'
$vmSize = Read-Host -Prompt 'Enter VM size' #"Standard_A2"
$osDiskName = $vmName + "osDisk"

## OS Disk
$osDiskUri = Read-Host -Prompt 'Enter URL for VHD drive to attach'

New-AzureResourceGroup -Name $rgName -Location $location

$storageacc = New-AzureStorageAccount -ResourceGroupName $rgName -Name $storageName -Type $storageType -Location $location

$pip = New-AzurePublicIpAddress -Name $nicname -ResourceGroupName $rgName -Location $location -AllocationMethod Dynamic
$subnetconfig = New-AzureVirtualNetworkSubnetConfig -Name $subnet1Name -AddressPrefix $vnetSubnetAddressPrefix
$vnet = New-AzureVirtualNetwork -Name $vnetName -ResourceGroupName $rgName -Location $location -AddressPrefix $vnetAddressPrefix -Subnet $subnetconfig
$nic = New-AzureNetworkInterface -Name $nicname -ResourceGroupName $rgName -Location $location -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $pip.Id

## Setup local VM object
$cred = Get-Credential
$vm = New-AzureVMConfig -VMName $vmName -VMSize $vmSize

$vm = Add-AzureVMNetworkInterface -VM $vm -Id $nic.Id

$vm = Set-AzureVMOSDisk -VM $vm -Name $osDiskName -VhdUri $osDiskUri -CreateOption attach -Windows

## Create the VM in Azure
New-AzureVM -ResourceGroupName $rgName -Location $location -VM $vm -Verbose -Debug