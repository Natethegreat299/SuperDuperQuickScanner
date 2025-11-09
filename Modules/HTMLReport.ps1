# ===========================================
# SuperDuperQuickScanner HTML Report Tools
# ===========================================

function New-HTMLHeader {
    param (
        [string]$Title = "SuperDuperQuickScanner Report",
        [string]$CSSPath = "../Assets/superduperquickscanner.css",
        [string]$HeaderText = "SuperDuperQuickScanner Report"
    )

    return @"
<!DOCTYPE html>
<html>
<head>
    <meta charset='UTF-8'>
    <title>$Title</title>
    <link rel='stylesheet' type='text/css' href='$CSSPath'>
</head>
<body>
<nav style='margin-bottom:20px;'>
    <a href="SystemInfo.html" style="color:#4CAF50; margin-right:20px;">System</a>
    <a href="NetworkInfo.html" style="color:#4CAF50; margin-right:20px;">Network</a>
    <a href="StorageInfo.html" style="color:#4CAF50; margin-right:20px;">Storage</a>
    <a href="SecurityInfo.html" style="color:#4CAF50; margin-right:20px;">Security</a>
    <a href="InstalledApps.html" style="color:#4CAF50;">Applications</a>
</nav>
<h1>$HeaderText</h1>
<p class='summary'>Generated: $(Get-Date)</p>
"@
}

function Close-HTML {
    return @"
</body>
</html>
"@
}
