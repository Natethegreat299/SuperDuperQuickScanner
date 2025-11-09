Write-Host "=== SuperDuperQuickScanner Starting ===" -ForegroundColor Green


# --- Import All Modules ---
$modulePath = "$PSScriptRoot\Modules\*.ps1"
Get-ChildItem $modulePath | ForEach-Object { . $_.FullName }

# --- Gather Data ---
$sysInfo = Get-SystemInfo
$netOnlineinfo = Get-NetworkInfo
$netOfflineinfo = Get-NetworkInfoOffline
$Securityinfo = Get-SecurityInfo

# --- Ensure Reports Directory Exists ---
$reportDir = "$PSScriptRoot\Reports"
if (-not (Test-Path $reportDir)) { 
    New-Item -ItemType Directory -Path $reportDir | Out-Null 
}

# =========================
# SYSTEM INFORMATION REPORT
# =========================
Write-Host "=== System Information ===" -ForegroundColor Green
$sysInfo | Format-List

$sysReport = "$reportDir\SystemInfo.html"

New-HTMLHeader -Title "SuperDuperQuickScanner - System Info" -HeaderText "SuperDuperQuickScanner System Report" |
    Out-File $sysReport -Encoding utf8

$sysInfo | ConvertTo-Html -As List -Fragment `
    -PreContent "<h2 class='section'>System Overview</h2>" | Add-Content $sysReport

Close-HTML | Add-Content $sysReport

Write-Host "System info report saved to $sysReport" -ForegroundColor Cyan


# =========================
# NETWORK INFORMATION REPORT
# =========================
Write-Host "=== Network Information ===" -ForegroundColor Green
$netOnlineinfo | Format-List

$netReport = "$reportDir\NetworkInfo.html"

New-HTMLHeader -Title "SuperDuperQuickScanner - Network Info" -HeaderText "SuperDuperQuickScanner Network Report" |
    Out-File $netReport -Encoding utf8

$netOnlineinfo.Adapters | ConvertTo-Html -As Table -Fragment `
    -PreContent "<h2 class='section'>Network Adapters</h2>" | Add-Content $netReport

$netOnlineinfo.OpenPorts | ConvertTo-Html -As Table -Fragment `
    -PreContent "<h2 class='section'>Open Ports ($($netOnlineinfo.PortCount))</h2>" | Add-Content $netReport

$netOfflineinfo | ConvertTo-Html -As Table -Fragment `
    -PreContent "<h2 class='section'>Offline Adapters</h2>" | Add-Content $netReport

Close-HTML | Add-Content $netReport

Write-Host "Network report saved to $netReport" -ForegroundColor Cyan

# =========================
# SECURITY INFORMATION REPORT
# =========================
Write-Host "=== Security Information ===" -ForegroundColor Green
$Securityinfo | Format-List

$secReport = "$reportDir\SecurityInfo.html"

# --- Create new HTML file with header ---
New-HTMLHeader -Title "SuperDuperQuickScanner - Security Info" -HeaderText "SuperDuperQuickScanner Security Report" |
    Out-File $secReport -Encoding utf8

# --- Defender Section ---
$Securityinfo | Where-Object { $_.AntivirusEnabled -ne $null } |
    ConvertTo-Html -As Table -Fragment `
    -PreContent "<h2 class='section'>Windows Defender</h2>" |
    Add-Content $secReport

# --- Firewall Section ---
$Securityinfo | Where-Object { $_.ProfileName -ne $null } |
    ConvertTo-Html -As Table -Fragment `
    -PreContent "<h2 class='section'>Firewall Profiles</h2>" |
    Add-Content $secReport

# --- Secure Boot Section ---
$Securityinfo | Where-Object { $_.SecureBoot -ne $null } |
    ConvertTo-Html -As Table -Fragment `
    -PreContent "<h2 class='section'>Secure Boot</h2>" |
    Add-Content $secReport

Close-HTML | Add-Content $secReport

Write-Host "Security report saved to $secReport" -ForegroundColor Cyan


# =========================
# STORAGE INFORMATION REPORT
# =========================
Write-Host "=== Storage Information ===" -ForegroundColor Green
$storageInfo = Get-StorageInfo

$storageReport = "$reportDir\StorageInfo.html"

New-HTMLHeader -Title "SuperDuperQuickScanner - Storage Info" -HeaderText "SuperDuperQuickScanner Storage Report" |
    Out-File $storageReport -Encoding utf8

# --- Physical Disks ---
$storageInfo.Physical | ConvertTo-Html -As Table -Fragment `
    -PreContent "<h2 class='section'>Physical Disks</h2>" | Add-Content $storageReport

# --- Volumes ---
$storageInfo.Volumes | ConvertTo-Html -As Table -Fragment `
    -PreContent "<h2 class='section'>Volumes</h2>" | Add-Content $storageReport

# --- Partitions ---
if ($storageInfo.Partitions) {
    $storageInfo.Partitions | ConvertTo-Html -As Table -Fragment `
        -PreContent "<h2 class='section'>Partitions</h2>" | Add-Content $storageReport
}

Close-HTML | Add-Content $storageReport

Write-Host "Storage report saved to $storageReport" -ForegroundColor Cyan

# =========================
# INSTALLED APPLICATIONS REPORT
# =========================
Write-Host "=== Installed Applications ===" -ForegroundColor Green
$appList = Get-InstalledApps

$appReport = "$reportDir\InstalledApps.html"

New-HTMLHeader -Title "SuperDuperQuickScanner - Installed Apps" -HeaderText "Installed Applications" |
    Out-File $appReport -Encoding utf8

$appList | ConvertTo-Html -As Table -Fragment `
    -PreContent "<h2 class='section'>Installed Applications</h2>" |
    Add-Content $appReport


Write-Host "Installed apps report saved to $appReport" -ForegroundColor Cyan


Compare-AppVersions

# =========================
# LAUNCH DASHBOARD
# =========================
Start-Process "$reportDir\SystemInfo.html"
