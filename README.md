# PowerShell
PowerShell script for windows system maintenance.

## StartStop_VMs.ps1 Overview
This script will allow the user to turn all Azure VMs ON or OFF via an automation connection that won't require insteractive input of credentials

### Prerequisites
1. Install the Azure Resource Manager modules from the PowerShell Gallery
Install-Module AzureRM
2. Reference the Azure Automation Connections info
https://docs.microsoft.com/en-us/azure/automation/automation-connections


## StartStop_VMs-Basic.ps1 Overview
This script will allow the user to turn all Azure VMs ON or OFF & prompts for user credentials

### Prerequisites
1. Install the Azure Resource Manager modules from the PowerShell Gallery
Install-Module AzureRM