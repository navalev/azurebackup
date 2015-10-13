Add-AzureAccount
Select-AzureSubscription 

$storageAccount = Read-Host -Prompt 'Enter target storage account'
$storageKey = Read-Host -Prompt 'Enter target storage account key'
$containerName = Read-Host -Prompt 'Enter target container name'

### Create the destination context for authenticating 
$destContext = New-AzureStorageContext  –StorageAccountName $storageAccount -StorageAccountKey $storageKey  
  
### Create the target container in storage
New-AzureStorageContainer -Name $containerName -Context $destContext 