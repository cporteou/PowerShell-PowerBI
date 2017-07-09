workflow StartStopVMGroup01
{
$Conn = Get-AutomationConnection -Name 'AzureRunAsConnection'
Add-AzureRMAccount -ServicePrincipal -Tenant $Conn.TenantID `
-ApplicationId $Conn.ApplicationID -CertificateThumbprint $Conn.CertificateThumbprint

$subject_stopVM = 'VM $VM is stopped.'
$subject_startVM = 'VM $VM is running.'
$Body_stopVM = 'VM $VM is stopped.'
$Body_startVM = 'VM $VM is running.'
$userid = 'cpadmin@mcreasy.com.au'

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
#send email.
Send-MailMessage ` 
    -To 'simon.xie@comprac.com.au' ` 
    -Subject $subject_stopVM  ` 
    -Body $Body_stopVM ` 
    -UseSsl ` 
    -Port 587 ` 
    -SmtpServer 'smtp.office365.com' ` 
    -From $userid ` 
    -BodyAsHtml ` 
    #-Credential $Cred 
   
        Write-Output "Mail is now sending `n" 
        Write-Output "-------------------------------------------------------------------------" 
}
elseif($status -eq "VM deallocated" -and $VM.Tags.values -contains "on-demand")
{
Start-AzureRmVM -ResourceGroupName $RG.ResourceGroupName -Name $VM.Name
#send email.
Send-MailMessage ` 
    -To 'simon.xie@comprac.com.au' ` #,'itmanager@mcreasy.com.au' ` 
    -Subject $subject_startVM  ` 
    -Body $Body_startVM ` 
    -UseSsl ` 
    -Port 587 ` 
    -SmtpServer 'smtp.office365.com' ` 
    -From $userid ` 
    -BodyAsHtml ` 
    #-Credential $Cred 
   
        Write-Output "Mail is now sending `n" 
        Write-Output "-------------------------------------------------------------------------" 
} 
else
{Write-Output "do nothing"}  
  }
  }

}
