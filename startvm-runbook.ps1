#Note: Script uses the new Az modules. 
#Please ensure your runbook has the Az.Accounts, Az.Automation, and Az.Compute modules (Often not found in most automation accounts!)

#Parameters
$subId = "SubscriptionID_Here" #Subscription id for the VM
$vmRG = "VM_RG_here"           #ResourceGroup containing VM
$vmName = "VM_Name_Here"       #VM Name
 

#import modules for Azure Automation to use
Import-Module Az.Accounts
Import-Module Az.Automation
Import-Module Az.Compute


#Attempt to connect to Azure using RunAsAccount
$connectionName = "AzureRunAsConnection"
try
{
    # Get the connection "AzureRunAsConnection "
    $servicePrincipalConnection = Get-AutomationConnection -Name $connectionName       
    "Logging in to Azure..."
    Connect-AzAccount `
        -ServicePrincipal `
        -TenantId $servicePrincipalConnection.TenantId `
        -ApplicationId $servicePrincipalConnection.ApplicationId `
        -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint 
}
catch {
    if (!$servicePrincipalConnection)
    {
        $ErrorMessage = "Connection $connectionName not found."
        throw $ErrorMessage
    } else{
        Write-Error -Message $_.Exception
        throw $_.Exception
    }
}

#Set correct subscription to use for command 
set-azcontext -subscriptionid $subId
#Command start of VM
start-azvm -resourcegroupname $vmRG -Name $vmName