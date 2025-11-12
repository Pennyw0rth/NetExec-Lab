# Define the directory path where the file should be created
$directoryPath = "C:\Wayne"

# Ensure the directory exists
If (-Not (Test-Path -Path $directoryPath)) {
    New-Item -ItemType Directory -Path $directoryPath
}

Move-Item -Path C:\wayne.exe -Destination C:\Wayne\ -Force


cmd.exe /c 'sc sdset "WayneService" D:(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;AU)(A;;CCLCSWRPWPDTLOCRRC;;;PU)(A;;DCRPWP;;;BU)'

