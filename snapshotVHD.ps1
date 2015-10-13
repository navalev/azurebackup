Add-AzureAccount
Select-AzureSubscription

$srcUri = Read-Host  -Prompt 'Enter source url to copy' 
$storageAccount = Read-Host -Prompt 'Enter target storage account'
$storageKey = Read-Host -Prompt 'Enter target storage account key'
$containerName = Read-Host -Prompt 'Enter target container name'
$snapshotname = Read-Host -Prompt 'Enter snapshot name'
 
### Create the destination context for authenticating the copy
$destContext = New-AzureStorageContext  –StorageAccountName $storageAccount -StorageAccountKey $storageKey  
  
### Create the target container in storage
## New-AzureStorageContainer -Name $containerName -Context $destContext 
 
### Start the Asynchronous Copy ###
$blob1 = Start-AzureStorageBlobCopy -srcUri $srcUri -DestContainer $containerName -DestBlob $snapshotname -DestContext $destContext

### Retrieve the current status of the copy operation ###
$status = $blob1 | Get-AzureStorageBlobCopyState 
 
### Print out status ### 
$status 
 
### Loop until complete ###                                    
While($status.Status -eq "Pending"){
  $status = $blob1 | Get-AzureStorageBlobCopyState 
  Start-Sleep 10
  ### Print out status ###
  $status
}