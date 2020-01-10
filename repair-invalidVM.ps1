# Get VM name from User
$vmname = read-host "Please enter VM that is labeled invalid"

# Get datastores connected to the VM 
$vmdatastores = get-vm $vmname | get-datastore

# Find the .vmx file from the list the datastores

Get-VM -Name $vmname | Add-Member -MemberType ScriptProperty -Name 'VMXPath' -Value {$this.extensiondata.config.files.vmpathname} -Passthru -Force | Select-Object Name,VMXPath 

