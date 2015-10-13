Add-AzureAccount
Select-AzureSubscription 

$group = Read-Host  -Prompt 'Enter resource group name' 
$vm = Read-Host -Prompt 'Enter name of virtual machine to delete'

Remove-AzureVM -ResourceGroupName $group -Name $vm