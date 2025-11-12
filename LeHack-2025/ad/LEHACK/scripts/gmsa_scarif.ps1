Import-Module ActiveDirectory

# --- Domain Info ---
$domain = "rebels.local"
$gmsaName = "gMSA-scarif"
$principals = @("endor$")   # Computers allowed to use this gMSA

# --- 1. Ensure KDS Root Key exists ---
if (-not (Get-KdsRootKey -ErrorAction SilentlyContinue)) {
    Write-Host "No KDS Root Key found. Creating one..." -ForegroundColor Yellow
    Add-KdsRootKey -EffectiveTime ((Get-Date).AddHours(-10))
    Write-Host "KDS Root Key created successfully." -ForegroundColor Green
} else {
    Write-Host "KDS Root Key already exists." -ForegroundColor Cyan
}

# --- 2. Create the gMSA ---
if (-not (Get-ADServiceAccount -Filter "Name -eq '$gmsaName'" -ErrorAction SilentlyContinue)) {
    New-ADServiceAccount -Name $gmsaName `
        -DNSHostName $domain `
        -PrincipalsAllowedToRetrieveManagedPassword $principals
    Write-Host "gMSA '$gmsaName' created successfully." -ForegroundColor Green
} else {
    Write-Host "gMSA '$gmsaName' already exists." -ForegroundColor Cyan
}

# --- 3. Test on the host (endor) ---
Write-Host "`nTesting gMSA on host 'endor'..." -ForegroundColor Yellow
Invoke-Command -ComputerName "endor" -ScriptBlock {
    Import-Module ActiveDirectory
    $gmsa = "gMSA-scarif"
    Install-ADServiceAccount $gmsa -ErrorAction Stop
    if (Test-ADServiceAccount $gmsa) {
        Write-Host "✅ gMSA '$gmsa' installed and verified on this host." -ForegroundColor Green
    } else {
        Write-Host "❌ gMSA '$gmsa' test failed on this host." -ForegroundColor Red
    }
}
