# Get VM name from User
$vmname = read-host "Please enter VM that is labeled invalid"


# Find the .vmx filePath from the list the datastores
$vmpath = Get-VM -Name $vmname | Add-Member -MemberType ScriptProperty -Name 'VMXPath' -Value {$this.extensiondata.config.files.vmpathname} -Passthru -Force | Select-Object VMXPath 


# Remove VM from inventory . Confirmation is required .
remove-vm -vm $vmname -confirm $true

# Add VM back into inventory 
New-VM -VMFilePath $vmpath -WhatIf

# Remove non local drives 


# Start back up VM


