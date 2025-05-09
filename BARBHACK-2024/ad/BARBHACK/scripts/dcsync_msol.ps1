# Define the necessary variables
$UserName = "MSOL_80541c18ebaa"  # User account to grant permissions to
$DomainController = "BABAORUM.rome.local"  # Domain Controller FQDN
$DomainDistinguishedName = (Get-ADDomain -Server $DomainController).DistinguishedName  # Get the Domain DN

# Retrieve the User SID
$objGroup = Get-ADUser -Identity $UserName -Server $DomainController

# Define the extended rights map for directory replication permissions
$extendedrightsmap = @{
    "Manage Replication Topology" = "1131F6AA-9C07-11D1-F79F-00C04FC2DCD2"
    "Replicating Directory Changes" = "1131F6AD-9C07-11D1-F79F-00C04FC2DCD2"
    "Replicating Directory Changes All" = "1131F6AE-9C07-11D1-F79F-00C04FC2DCD2"
    "Replicating Directory Changes In Filtered Set" = "89E95B76-444D-4C62-991A-0FACEDA6D00E"
    "Replication Synchronization" = "1131F6AB-9C07-11D1-F79F-00C04FC2DCD2"
}

# Functions to grant permissions

Function ManageReplicationTopology {
    Param($objGroup, $objOU, $inheritanceType)

    If ($inheritanceType -eq "Descendents") { $inheritanceType = "All" }
    ElseIf ($inheritanceType -eq "Children") { $inheritanceType = "None" }

    $groupSID = New-Object System.Security.Principal.SecurityIdentifier $objGroup.SID
    $objAcl = Get-Acl $objOU
    $objAcl.AddAccessRule((New-Object System.DirectoryServices.ActiveDirectoryAccessRule $groupSID,"ExtendedRight","Allow",$extendedrightsmap["Manage Replication Topology"],$inheritanceType,"00000000-0000-0000-0000-000000000000"))

    try {
        Set-Acl -AclObject $objAcl -Path $objOU -ErrorAction Stop
    } catch {
        Write-Host -ForegroundColor Red "ERROR: Unable to grant Manage Replication Topology permissions."
    }

    If (!$error) {
        Write-Host -ForegroundColor Green "INFORMATION: Granted Manage Replication Topology permissions."
    }
}

Function ReplicatingDirectoryChanges {
    Param($objGroup, $objOU, $inheritanceType)

    If ($inheritanceType -eq "Descendents") { $inheritanceType = "All" }
    ElseIf ($inheritanceType -eq "Children") { $inheritanceType = "None" }

    $groupSID = New-Object System.Security.Principal.SecurityIdentifier $objGroup.SID
    $objAcl = Get-Acl $objOU
    $objAcl.AddAccessRule((New-Object System.DirectoryServices.ActiveDirectoryAccessRule $groupSID,"ExtendedRight","Allow",$extendedrightsmap["Replicating Directory Changes"],$inheritanceType,"00000000-0000-0000-0000-000000000000"))

    try {
        Set-Acl -AclObject $objAcl -Path $objOU -ErrorAction Stop
    } catch {
        Write-Host -ForegroundColor Red "ERROR: Unable to grant Replicating Directory Changes permissions."
    }

    If (!$error) {
        Write-Host -ForegroundColor Green "INFORMATION: Granted Replicating Directory Changes permissions."
    }
}

Function ReplicatingDirectoryChangesAll {
    Param($objGroup, $objOU, $inheritanceType)

    If ($inheritanceType -eq "Descendents") { $inheritanceType = "All" }
    ElseIf ($inheritanceType -eq "Children") { $inheritanceType = "None" }

    $groupSID = New-Object System.Security.Principal.SecurityIdentifier $objGroup.SID
    $objAcl = Get-Acl $objOU
    $objAcl.AddAccessRule((New-Object System.DirectoryServices.ActiveDirectoryAccessRule $groupSID,"ExtendedRight","Allow",$extendedrightsmap["Replicating Directory Changes All"],$inheritanceType,"00000000-0000-0000-0000-000000000000"))

    try {
        Set-Acl -AclObject $objAcl -Path $objOU -ErrorAction Stop
    } catch {
        Write-Host -ForegroundColor Red "ERROR: Unable to grant Replicating Directory Changes All permissions."
    }

    If (!$error) {
        Write-Host -ForegroundColor Green "INFORMATION: Granted Replicating Directory Changes All permissions."
    }
}

Function ReplicatingDirectoryChangesInFilteredSet {
    Param($objGroup, $objOU, $inheritanceType)

    If ($inheritanceType -eq "Descendents") { $inheritanceType = "All" }
    ElseIf ($inheritanceType -eq "Children") { $inheritanceType = "None" }

    $groupSID = New-Object System.Security.Principal.SecurityIdentifier $objGroup.SID
    $objAcl = Get-Acl $objOU
    $objAcl.AddAccessRule((New-Object System.DirectoryServices.ActiveDirectoryAccessRule $groupSID,"ExtendedRight","Allow",$extendedrightsmap["Replicating Directory Changes In Filtered Set"],$inheritanceType,"00000000-0000-0000-0000-000000000000"))

    try {
        Set-Acl -AclObject $objAcl -Path $objOU -ErrorAction Stop
    } catch {
        Write-Host -ForegroundColor Red "ERROR: Unable to grant Replicating Directory Changes In Filtered Set permissions."
    }

    If (!$error) {
        Write-Host -ForegroundColor Green "INFORMATION: Granted Replicating Directory Changes In Filtered Set permissions."
    }
}

Function ReplicationSynchronization {
    Param($objGroup, $objOU, $inheritanceType)

    If ($inheritanceType -eq "Descendents") { $inheritanceType = "All" }
    ElseIf ($inheritanceType -eq "Children") { $inheritanceType = "None" }

    $groupSID = New-Object System.Security.Principal.SecurityIdentifier $objGroup.SID
    $objAcl = Get-Acl $objOU
    $objAcl.AddAccessRule((New-Object System.DirectoryServices.ActiveDirectoryAccessRule $groupSID,"ExtendedRight","Allow",$extendedrightsmap["Replication Synchronization"],$inheritanceType,"00000000-0000-0000-0000-000000000000"))

    try {
        Set-Acl -AclObject $objAcl -Path $objOU -ErrorAction Stop
    } catch {
        Write-Host -ForegroundColor Red "ERROR: Unable to grant Replication Synchronization permissions."
    }

    If (!$error) {
        Write-Host -ForegroundColor Green "INFORMATION: Granted Replication Synchronization permissions."
    }
}

# Apply the functions for the GMSA
$OU = "AD:$DomainDistinguishedName"

ManageReplicationTopology -objGroup $objGroup -objOU $OU -inheritanceType "Descendents"
ReplicatingDirectoryChanges -objGroup $objGroup -objOU $OU -inheritanceType "Descendents"
ReplicatingDirectoryChangesAll -objGroup $objGroup -objOU $OU -inheritanceType "Descendents"
ReplicatingDirectoryChangesInFilteredSet -objGroup $objGroup -objOU $OU -inheritanceType "Descendents"
ReplicationSynchronization -objGroup $objGroup -objOU $OU -inheritanceType "Descendents"
