Function enable-invalidVM()
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
	LASTEDIT: 01/16/2020
	VERSION: 1.0
	KEYWORDS: VMware, vSphere, ESXi, VM, Invalid

#>

# Parameters
[CmdletBinding()]
param
(
    [Parameter(Mandatory=$true)]
    [string]$VMName
)

Begin{

    # Clear Screen
    Clear-host

    # Add start-transact here for logging
    Start-Transcript -path .\fix-invalid-vmlogging.txt

    # Give the user information on which VM they entered. 
    write-host " INFO: You entered VM:" $VMName -BackgroundColor Red

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
        $vminfo = get-vm -name $VMName -ErrorAction Stop| get-view | Select-Object Name,@{N='ConnectionState';E={$_.runtime.connectionstate}}
        
        # Let user know VM is present
        write-host "INFO: VM is present verifying connection state...."

        if ($vminfo.ConnectionState -match "invalid")
        {
            write-host "INFO: VM is invalid" -ForegroundColor Green
            # Enter 2 spaces 
            "";""
            write-host "INFO: Reloading VM...." -ForegroundColor Green
            #$vminfo = get-vm -name $Name | foreach-object {get-view $_.reload()}
            $Vmview = get-vm -name $VMName | Get-View
            $Vmview.Reload()
            
        }
        else{
            write-host "INFO: VM is not invalid. Please run script again with VM that is in invalid state." -ForegroundColor Red
            exit
        }        
    }
    catch{

        Write-Output "INFO:A Error occured." "" $error[0] ""
    }

    # Enter 2 spaces 
    "";""

}


End{

Stop-Transcript

}


}