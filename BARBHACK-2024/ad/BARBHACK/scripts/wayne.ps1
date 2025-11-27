# Define the directory path where the file should be created
$directoryPath = "C:\Wayne"

# Ensure the directory exists
If (-Not (Test-Path -Path $directoryPath)) {
    New-Item -ItemType Directory -Path $directoryPath
}

Move-Item -Path C:\wayne.exe -Destination C:\Wayne\ -Force

# Set ACLs on the C:\Wayne directory to allow users to write files (for alfred.dll)
$dirAcl = Get-Acl $directoryPath
# Disable inheritance and remove inherited rules
$dirAcl.SetAccessRuleProtection($true, $false)
# Clear existing rules (copy collection first to avoid modification during iteration)
$rulesToRemove = @($dirAcl.Access)
foreach ($rule in $rulesToRemove) {
    $dirAcl.RemoveAccessRule($rule) | Out-Null
}
# Add rule for SYSTEM: Full Control
$dirSystemRule = New-Object System.Security.AccessControl.FileSystemAccessRule("NT AUTHORITY\SYSTEM", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
$dirAcl.AddAccessRule($dirSystemRule)
# Add rule for Administrators: Full Control
$dirAdminRule = New-Object System.Security.AccessControl.FileSystemAccessRule("BUILTIN\Administrators", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
$dirAcl.AddAccessRule($dirAdminRule)
# Add rule for Users: Read, Execute, and Write (to allow dropping alfred.dll)
$dirUsersRule = New-Object System.Security.AccessControl.FileSystemAccessRule("BUILTIN\Users", "ReadAndExecute,Write", "ContainerInherit,ObjectInherit", "None", "Allow")
$dirAcl.AddAccessRule($dirUsersRule)
# Apply the ACL to the directory
Set-Acl -Path $directoryPath -AclObject $dirAcl

# Set ACLs on wayne.exe to prevent replacement by non-administrators
# Allow only read and execute for Users, full control only for Administrators and SYSTEM
$exePath = "C:\Wayne\wayne.exe"
$acl = Get-Acl $exePath
# Disable inheritance and remove inherited rules
$acl.SetAccessRuleProtection($true, $false)
# Clear existing rules (copy collection first to avoid modification during iteration)
$fileRulesToRemove = @($acl.Access)
foreach ($rule in $fileRulesToRemove) {
    $acl.RemoveAccessRule($rule) | Out-Null
}
# Add rule for SYSTEM: Full Control
$systemRule = New-Object System.Security.AccessControl.FileSystemAccessRule("NT AUTHORITY\SYSTEM", "FullControl", "Allow")
$acl.AddAccessRule($systemRule)
# Add rule for Administrators: Full Control
$adminRule = New-Object System.Security.AccessControl.FileSystemAccessRule("BUILTIN\Administrators", "FullControl", "Allow")
$acl.AddAccessRule($adminRule)
# Add rule for Users: Read and Execute only (no write or modify)
$usersRule = New-Object System.Security.AccessControl.FileSystemAccessRule("BUILTIN\Users", "ReadAndExecute", "Allow")
$acl.AddAccessRule($usersRule)
# Apply the ACL
Set-Acl -Path $exePath -AclObject $acl

cmd.exe /c 'sc sdset "WayneService" D:(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;AU)(A;;CCLCSWRPWPDTLOCRRC;;;PU)(A;;DCRPWP;;;BU)'

