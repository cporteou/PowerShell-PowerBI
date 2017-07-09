<##
Get-AutomationPSCredential is not a cmdlet in the Azure module, it is a native activity to Azure Automation.

Install and configure Azure PowerShell on user-end PC.

azure.microsoft.com/en-us/downloads

command-line tools--> powershell---> windows install

install microsoft azure powershell
install microsoft azure powershell cross-platform command line

install other azure packs on web platform installer(WebPI);

run: windows powershell ise, 

import-module azure

get-command *azure*

login-azurermaccount
get-azurepublishsettingsfile
save azurepublishsettingsfile

Get-Module -ListAvailable  # view current PS modules

Import-AzurePublishSettingsFile
Get-AzureRMResourceGroup
Get-AzureRmAutomationVariable -ResourceGroupName 'cg-private' –AutomationAccountName "mgc-automation"
(Get-AzureRmAutomationVariable -ResourceGroupName 'cg-private' –AutomationAccountName "mgc-automation" -name 'StopByResourceGroupV2-TargetResourceGroups-MS-Mgmt-VM').value

Get-AzureRmSubscription –SubscriptionName 'MARCR01 - Azure Subscription' | Select-AzureRmSubscription

Get-AzureRmVM -ResourceGroupName 'cg-private'

(Get-AzureRmVM -Name 'MGC-SRV-SQL2' -ResourceGroupName 'cg-private' -Status).Statuses

Start-AzureRmVM -ResourceGroupName 'cg-private' -Name 'MGC-SRV-BKP1'

(Get-AzureRmVM -Name 'MGC-SRV-SQL2' -ResourceGroupName 'cg-private' ).Statuses

##>

##start vm groups by tags
workflow StartVMGroup01
{
$Conn = Get-AutomationConnection -Name 'AzureRunAsConnection'
Add-AzureRMAccount -ServicePrincipal -Tenant $Conn.TenantID `
-ApplicationId $Conn.ApplicationID -CertificateThumbprint $Conn.CertificateThumbprint

$RGs = Get-AzureRMResourceGroup

foreach($RG in $RGs)
{
$VMs = Get-AzureRmVM -ResourceGroupName $RG.ResourceGroupName

#$VMs = Get-AzureRmVM -ResourceGroupName 'cg-private'
foreach($VM in $VMs)
    {

$VMstatus=(Get-AzureRmVM -Name $VM.Name -ResourceGroupName $RG.ResourceGroupName -Status).Statuses | where Code -like "PowerState*"
       
$status=$VMstatus.displaystatus

if($status -eq "VM deallocated" -and $VM.Tags.values -contains "on-demand")
  {
     ## Starting VM
Start-AzureRmVM -ResourceGroupName $RG.ResourceGroupName -Name $VM.Name
}
   
  }
  }
 
}

##stop vm groups by tags
workflow StopVMGroup01
{
$Conn = Get-AutomationConnection -Name 'AzureRunAsConnection'
Add-AzureRMAccount -ServicePrincipal -Tenant $Conn.TenantID `
-ApplicationId $Conn.ApplicationID -CertificateThumbprint $Conn.CertificateThumbprint

$RGs = Get-AzureRMResourceGroup

foreach($RG in $RGs)
{
$VMs = Get-AzureRmVM -ResourceGroupName $RG.ResourceGroupName

foreach($VM in $VMs)
    {

$VMstatus=(Get-AzureRmVM -Name $VM.Name -ResourceGroupName $RG.ResourceGroupName -Status).Statuses | where Code -like "PowerState*"
       
$status=$VMstatus.displaystatus

if($status -eq "VM running" -and $VM.Tags.values -contains "on-demand")
  {
Stop-AzureRmVM -ResourceGroupName $RG.ResourceGroupName -Name $VM.Name -Force
}
   
  }
  }
 

}





