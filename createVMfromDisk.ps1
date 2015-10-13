## Global
$rgName = "testrg13"
$location = "northeurope"

## Storage
$storageName = "teststore13"
$storageType = "Standard_GRS"

## Network
$nicname = "testnic13"
$subnet1Name = "subnet1"
$vnetName = "testnet"
$vnetAddressPrefix = "10.0.0.0/16"
$vnetSubnetAddressPrefix = "10.0.0.0/24"

## Compute
$vmName = "testvm13"
$computerName = "testcomputer13"
$vmSize = "Standard_A2"
$osDiskName = $vmName + "osDisk"

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

$osDiskUri = "https://snapshotsaccount.blob.core.windows.net/vhds/sampleVMbasic.vhd"
$vm = Set-AzureVMOSDisk -VM $vm -Name $osDiskName -VhdUri $osDiskUri -CreateOption attach -Windows

## Create the VM in Azure
New-AzureVM -ResourceGroupName $rgName -Location $location -VM $vm -Verbose -Debug