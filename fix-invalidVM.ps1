<#
	.SYNOPSIS
    Fix invalid VM . This is specific to company.
    
	.DESCRIPTION
    This Function will remove the invalid VM from inventory then register VM based on VMFilePath. Lately it will remove nonlocal disks 
    and start the VM .
	.Example
    fix-invalidVM -Name test
	    
	.Notes
	NAME: fix-invalidVM.ps1
    AUTHOR: Chris Federico  
	LASTEDIT: 01/15/2020
	VERSION: 1.0
	KEYWORDS: VMware, vSphere, ESXi, VM, Invalid

#>

# Parameters
[CmdletBinding()]
param
(
    [Parameter(Mandatory=$true)]
    [string]$Name
)

Begin{

    # Clear Screen
    Clear-host

    # Add start-transact here for logging
    Start-Transcript -path .\fix-invalid-vmlogging.txt

    # Give the user information on which VM they entered. 
    write-host " INFO: You entered VM:" $Name -BackgroundColor Red

    # Enter 2 spaces 
    "";""

    # Ask user if they would like to continue
    $reply = Read-host "Would you like to Proceed ?[y/n]"
    if ($reply -match "[nN]")
    {
	exit 
    }

    # Present data to the user
    write-host "INFO: Verifying VM is present and in invalid state"
    
    try{
        $vmname = Get-VM -Name $Name -ErrorAction Stop | Add-Member -MemberType ScriptProperty -Name 'VMXPath' -Value {$this.extensiondata.config.files.vmpathname} -Passthru -Force | Select-Object Name,VMHost,ResourcePoolId,FolderId,VMXPath
        #$vmhost = get-VM -Name $vmname | select-object VMHost
        #$vmresourcePool = Get-VM -Name $vmname | Select-Object ResourcePoolId
        #$vmpath = Get-VM -Name $vmname | Add-Member -MemberType ScriptProperty -Name 'VMXPath' -Value {$this.extensiondata.config.files.vmpathname} -Passthru -Force | Select-Object VMXPath
        $vmname

    }
    catch{

        Write-Output "A Error occured. " "" $error[0] ""
    }

    # Enter 2 spaces 
    "";""

     write-host "VM is invalid!. Gathering inforamtion..." -ForegroundColor Green
}

Process{


}


End{

Stop-Transcript

}
