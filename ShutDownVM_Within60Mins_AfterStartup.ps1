#put this PowerShell script in task scheduler.
#repeat task every 5 mins.
#program : powershell.exe
#Add arguments: -noprofile -executionpolicy bypass -file "c:\xxx\xxxx.ps1"
#
function Get-Uptime-InMinutes {
   $os = Get-WmiObject win32_operatingsystem
   $uptime = (Get-Date) - ($os.ConvertToDateTime($os.lastbootuptime))
   $Display = "Uptime: " + $Uptime.TotalMinutes + " minutes" 
   #Write-Output $Display
   return $Uptime.TotalMinutes
}

$uptime_minutes = Get-Uptime-InMinutes

If ($uptime_minutes -gt 60.0)  {

  Stop-Computer -AsJob -Force

  }  
else {
  #write-host "continue running"
  exit
  }
