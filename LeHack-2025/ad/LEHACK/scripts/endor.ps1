# Define the directory path where the file should be created
$directoryPath = "C:\rebels_plan"

# Ensure the directory exists
If (-Not (Test-Path -Path $directoryPath)) {
    New-Item -ItemType Directory -Path $directoryPath
}

Set-Content -Path "C:\rebels_plan\info.txt" -Value "It's seems we heard of a planet called ""endor"", worth checking this intel ..." -Force

# Define the directory path where the file should be created
$directoryPath2 = "C:\Users\localadmin\AppData\Roaming\Notepad++\backup\"
$filename = "new 1@2025-06-24_100732"
# Ensure the directory exists
If (-Not (Test-Path -Path $directoryPath2)) {
    New-Item -ItemType Directory -Path $directoryPath2
}

Set-Content -Path "C:\Users\localadmin\AppData\Roaming\Notepad++\backup\$filename" -Value "credentials: - wz(}ab4=/&_f - s>cwp>9c*x=s" -Force

# Define the directory path where the file should be created
$directoryPath3 = "C:\Destroyer_Access"

# Ensure the directory exists
If (-Not (Test-Path -Path $directoryPath3)) {
    New-Item -ItemType Directory -Path $directoryPath3
}

Set-Content -Path "C:\Destroyer_Access\info.txt" -Value "Access key for the ship ! Also, stop taking note, it can be unsafe, you never know ...#" -Force
