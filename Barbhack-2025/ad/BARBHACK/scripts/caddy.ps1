# caddy.ps1 - Setup Caddy web server with printer interface
# Run this on JOLLYROGER (srv01)
# Website files are pre-deployed from Imprimante folder via Ansible

# Run as Administrator

# --- Adjust these if your paths differ ---
$CaddyFolder = "C:\Caddy"
$CaddyExe = Join-Path $CaddyFolder "caddy.exe"
$WebsiteFolder = "C:\Websites\mywebsite"
$ScanFolder = Join-Path $WebsiteFolder "scan"
$Caddyfile = Join-Path $CaddyFolder "Caddyfile"

# --- Password and user ---
$Username = "admin"
$PlainPassword = "hplaserbarbhack"

# --- Ensure paths exist ---
if (-not (Test-Path $CaddyFolder)) {
    New-Item -ItemType Directory -Path $CaddyFolder -Force | Out-Null
}
if (-not (Test-Path $CaddyExe)) {
    Write-Host "Downloading Caddy..."
    $caddyUrl = "https://github.com/caddyserver/caddy/releases/download/v2.7.6/caddy_2.7.6_windows_amd64.zip"
    $zipPath = Join-Path $CaddyFolder "caddy.zip"
    Invoke-WebRequest -Uri $caddyUrl -OutFile $zipPath
    Expand-Archive -Path $zipPath -DestinationPath $CaddyFolder -Force
    Remove-Item $zipPath
}

# Website folder should already exist with files copied by Ansible
if (-not (Test-Path $WebsiteFolder)) {
    Write-Host "Warning: Website folder not found, creating empty structure..."
    New-Item -ItemType Directory -Path $WebsiteFolder -Force | Out-Null
    New-Item -ItemType Directory -Path $ScanFolder -Force | Out-Null
}

# --- Generate bcrypt hash using caddy ---
Write-Host "Generating password hash with Caddy..."
$hashOutput = & $CaddyExe hash-password --plaintext $PlainPassword 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to generate password hash. Output:`n$hashOutput"
    exit 1
}
# The command prints the hash (possibly with newline); capture the last non-empty line
$hash = ($hashOutput | Where-Object { $_ -and $_.Trim() -ne "" } | Select-Object -Last 1).Trim()
if (-not $hash) {
    Write-Error "Could not extract hash from caddy output: $hashOutput"
    exit 1
}
Write-Host "Hash generated."

# --- Compose Caddyfile ---
# This config:
#  - Serves the website from $WebsiteFolder
#  - Protects the /scan path with Basic Auth (user: admin, password: hashed value)
#  - Serves files under the scan subfolder when /scan is requested
$CaddyfileContent = @"
:8080 {
    # Serve the website root
    root * $WebsiteFolder
    file_server

    # Protect /scan with Basic Auth (user: $Username)
    # Only requests under /scan/* will require authentication.
    @scanPath path /scan/* /scan
    route @scanPath {
        # Basic auth using hashed password (bcrypt)
        basicauth @scanPath $Username $hash

        # Serve files from the scan folder
        root * $ScanFolder
        file_server
    }
}
"@

# --- Write the Caddyfile ---
Set-Content -Path $Caddyfile -Value $CaddyfileContent -Force -Encoding UTF8
Write-Host "Wrote Caddyfile to $Caddyfile"

# Website files should already be present (copied by Ansible from Imprimante folder)
Write-Host "Website files should be in $WebsiteFolder (deployed by Ansible)"

# --- Install Caddy as a Windows service ---
Write-Host "Installing Caddy as a Windows service..."

# Stop any existing Caddy process
Get-Process -Name caddy -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue

# Install Caddy as a Windows service using sc.exe
$serviceName = "Caddy"
$serviceExists = Get-Service -Name $serviceName -ErrorAction SilentlyContinue

if (-not $serviceExists) {
    Write-Host "Creating Caddy Windows service..."
    & sc.exe create $serviceName binPath= "$CaddyExe run --config $Caddyfile" start= auto
}

# Start the service
Start-Service -Name $serviceName -ErrorAction SilentlyContinue
Write-Host "Caddy service started"

Write-Host "Caddy web server started on port 8080"
Write-Host "The /scan path is protected with Basic Auth (user: $Username, pass: $PlainPassword)"
Write-Host "Website root: $WebsiteFolder"
