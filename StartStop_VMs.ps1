workflow StartStopVMGroup01
{
$Conn = Get-AutomationConnection -Name 'AzureRunAsConnection'
Add-AzureRMAccount -ServicePrincipal -Tenant $Conn.TenantID `
-ApplicationId $Conn.ApplicationID -CertificateThumbprint $Conn.CertificateThumbprint

$StrCredentialName = "cpadmincredential" 
$StrMessageTo = @("simon.xie@comprac.com.au", "greenspanx@hotmail.com")      
         
# Retrieve automation credentials 
$cre = Get-AutomationPSCredential -Name $StrCredentialName 

$RGs = Get-AzureRMResourceGroup

foreach($RG in $RGs)
{
$VMs = Get-AzureRmVM -ResourceGroupName $RG.ResourceGroupName

foreach($VM in $VMs)
{

$VMstatus=(Get-AzureRmVM -Name $VM.Name -ResourceGroupName $RG.ResourceGroupName -Status).Statuses | where Code -like "PowerState*"
$VM_Name = $VM.Name       
$status=$VMstatus.displaystatus

if($status -eq "VM running" -and $VM.Tags.values -contains "on-demand")
{
Stop-AzureRmVM -ResourceGroupName $RG.ResourceGroupName -Name $VM.Name -Force
#send email.

Send-MailMessage -To $StrMessageTo -Subject "Stopping VM $VM_Name from azure automation" -UseSsl -Port 587 -SmtpServer 'smtp.office365.com' -From $cre.UserName -BodyAsHtml -Credential $cre  
Write-Output "$VM_Name"  
Write-Output "Mail is now sending `n" 
Write-Output "-------------------------------------------------------------------------" 
}
elseif($status -eq "VM deallocated" -and $VM.Tags.values -contains "on-demand")
{
Start-AzureRmVM -ResourceGroupName $RG.ResourceGroupName -Name $VM.Name
# send email.
Send-MailMessage -To $StrMessageTo -Subject "Starting VM $VM_Name from azure automation" -UseSsl -Port 587 -SmtpServer 'smtp.office365.com' -From $cre.UserName -BodyAsHtml -Credential $cre  
Write-Output "$VM_Name"
Write-Output "Mail is now sending `n" 
Write-Output "-------------------------------------------------------------------------" 
} 
else
{Write-Output "do nothing"}  
  }
  }

}
