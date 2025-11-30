Start-Process "chrome" -ArgumentList "--disable-web-security", "--user-data-dir=C:\TempChrome"

Start-Process "msedge" -ArgumentList "--disable-web-security", "--user-data-dir=C:\TempEdge"


Start-Process "chrome" -ArgumentList @(
    "--disable-web-security",
    "--user-data-dir=C:\Users\$env:USERNAME\TempChrome",
    "--disable-site-isolation-trials",
    "--disable-features=BlockInsecurePrivateNetworkRequests"
)

Start-Process "msedge" -ArgumentList @(
    "--disable-web-security",
    "--user-data-dir=C:\TempEdge",
    "--disable-site-isolation-trials",
    "--disable-features=BlockInsecurePrivateNetworkRequests"
)
