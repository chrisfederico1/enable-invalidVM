Function fix-invalidVM()
{

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

    

     
}

Process{

    # Present data to the user
    write-host "INFO: Verifying if VM is present and is in an invalid state...." -ForegroundColor Yellow
    
    try{
        # Get view of VM
        $vminfo = get-vm -name $Name -ErrorAction Stop| get-view | Select-Object Name,@{N='ConnectionState';E={$_.runtime.connectionstate}}
        
        # Let user know VM is present
        write-host "INFO: VM is present verifying connection state...."

        if ($vminfo.ConnectionState -match "invalid")
        {
            write-host "INFO: VM is invalid" -ForegroundColor Green
            write-host "INFO: Reloading VM...." -ForegroundColor Green
            $vminfo = get-vm -name $Name | get-view | ForEach-Object {$_.reload()}
        }
        else{
            write-host "INFO: VM is not invalid. Please run script again with VM that is in invalid state." -ForegroundColor Red
            exit
        }        
    }
    catch{

        Write-Output "INFO:A Error occured. Cannot Find VM !" "" $error[0] ""
    }

    # Enter 2 spaces 
    "";""

}


End{

Stop-Transcript

}


}