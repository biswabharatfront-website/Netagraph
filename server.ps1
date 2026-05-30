# Self-contained native PowerShell TCP Web Server for Netagraph Mobile Designs Preview
# Hosts static pages on localhost and Wi-Fi interface (192.168.31.185:8000), streams binary media, and performs template routing.

$port = 8000
$localIp = [System.Net.IPAddress]::Any
$listener = New-Object System.Net.Sockets.TcpListener($localIp, $port)

try {
    $listener.Start()
    Write-Host "==========================================================" -ForegroundColor Green
    Write-Host "  NETAGRAPH MOBILE DESIGNS HOST IS ONLINE" -ForegroundColor Green
    Write-Host "  Local preview URL: http://localhost:$port/" -ForegroundColor Cyan
    Write-Host "  Network IP preview URL: http://192.168.31.185:$port/" -ForegroundColor Cyan
    Write-Host "  Open these links in your browser or scan the QR Code!" -ForegroundColor Yellow
    Write-Host "  Press Ctrl+C in this terminal window to stop the server." -ForegroundColor Red
    Write-Host "==========================================================" -ForegroundColor Green
} catch {
    Write-Error "Failed to start TCP Listener. Port $port may already be in use. Detail: $_"
    exit
}

$mappings = @{
    "SCREEN_2"  = "/login_sign_up/code.html"
    "SCREEN_4"  = "/onboarding_with_transitions/code.html"
    "SCREEN_9"  = "/unified_reports_tracking_hub/code.html"      # Labeled: "Report"
    "SCREEN_13" = "/enable_permissions/code.html"
    "SCREEN_16" = "/unified_reports_tracking_hub/code.html"
    "SCREEN_24" = "/unified_interactive_loading_screen/code.html"
    "SCREEN_26" = "/civic_intelligence_hub/code.html"           # Labeled: "Explore"
    "SCREEN_30" = "/select_your_ward_updated_logo/code.html"
    "SCREEN_34" = "/political_leaders/code.html"                 # Labeled: "Leaders"
    "SCREEN_35" = "/netagraph_unified_navigation_hub/code.html"  # Labeled: "Feed"
    "SCREEN_36" = "/user_profile/code.html"                     # Labeled: "Profile Avatar"
    "SCREEN_41" = "/community_chat/code.html"                    # Labeled: "Chat"
    "SCREEN_43" = "/user_profile/code.html"                     # Labeled: "Profile Tab"
    "SCREEN_45" = "/new_announcement/code.html"                  # Labeled: "New Announcement"
    "SCREEN_5"  = "/politician_profile_rajesh_varma/code.html"
}

# Serve client loop
try {
    while ($true) {
        $client = $null
        try {
            $client = $listener.AcceptTcpClient()
            $stream = $client.GetStream()
            $reader = New-Object System.IO.StreamReader($stream)
            
            $requestLine = $reader.ReadLine()
            if ($null -eq $requestLine) {
                $client.Close()
                continue
            }
            
            # Read subsequent headers to drain input buffer and find User-Agent
            $userAgent = ""
            while ($true) {
                $line = $reader.ReadLine()
                if ($null -eq $line -or $line.Trim() -eq "") {
                    break
                }
                if ($line.StartsWith("User-Agent:", [System.StringComparison]::OrdinalIgnoreCase)) {
                    $userAgent = $line.Substring("User-Agent:".Length).Trim()
                }
            }
            
            # Parse HTTP request: GET /path HTTP/1.1
            $tokens = $requestLine -split ' '
            if ($tokens.Length -lt 2) {
                $client.Close()
                continue
            }
            
            $urlPath = $tokens[1]
            
            # Strip query parameters
            $urlPath = ($urlPath -split '\?')[0]
            
            if ($urlPath -eq "/") {
                $isMobile = $false
                if ($userAgent -match "Mobi|Android|iPhone|iPad|Windows Phone") {
                    $isMobile = $true
                }
                if ($isMobile) {
                    $urlPath = "/unified_interactive_loading_screen/code.html"
                } else {
                    $urlPath = "/index.html"
                }
            }
            
            Write-Host "--> Request: $urlPath" -ForegroundColor Green
            
            # Resolve local absolute path safely
            $decodedPath = [System.Uri]::UnescapeDataString($urlPath)
            
            # Trim leading slashes to prevent absolute path joins
            $trimmedPath = $decodedPath.TrimStart("/")
            $localPath = Join-Path (Get-Location) $trimmedPath.Replace("/", "\")
            
            if (Test-Path $localPath -PathType Leaf) {
                $extension = [System.IO.Path]::GetExtension($localPath).ToLower()
                
                # Content Type mappings
                switch ($extension) {
                    ".html" { $responseType = "text/html; charset=utf-8" }
                    ".png"  { $responseType = "image/png" }
                    ".jpg"  { $responseType = "image/jpeg" }
                    ".jpeg" { $responseType = "image/jpeg" }
                    ".js"   { $responseType = "application/javascript; charset=utf-8" }
                    ".css"  { $responseType = "text/css; charset=utf-8" }
                    default { $responseType = "text/plain; charset=utf-8" }
                }
                
                $bodyBytes = @()
                if ($extension -eq ".html") {
                    # Read, parse, and patch Stitch template tags in HTML responses
                    $content = Get-Content -Raw -Path $localPath -Encoding utf8
                    
                    foreach ($key in $mappings.Keys) {
                        $target = "{{DATA:SCREEN:" + $key + "}}"
                        $replacement = $mappings[$key]
                        $content = $content.Replace($target, $replacement)
                    }
                    
                    # Inject quick navigation back to Emulator
                    if ($urlPath -ne "/index.html") {
                        $navScript = @"
<div id="emulator-nav-btn" style="position: fixed; bottom: 16px; left: 16px; z-index: 10000; font-family: sans-serif;">
  <a href="/" style="display: flex; align-items: center; background: #f97316; color: white; padding: 10px 16px; border-radius: 30px; font-size: 12px; font-weight: bold; text-decoration: none; box-shadow: 0 4px 14px rgba(249,115,22,0.4); transition: transform 0.2s;" onmouseover="this.style.transform='scale(1.05)'" onmouseout="this.style.transform='scale(1)'">
    <span style="margin-right: 6px; font-size: 16px;">📱</span> Open in Emulator Frame
  </a>
</div>
<script>
  if (window.self !== window.top) {
    document.getElementById('emulator-nav-btn').style.display = 'none';
  }
</script>
</body>
"@
                        $content = $content.Replace("</body>", $navScript)
                    }
                    
                    $bodyBytes = [System.Text.Encoding]::UTF8.GetBytes($content)
                } else {
                    # Stream raw binary bytes (for screenshots or static assets)
                    $bodyBytes = [System.IO.File]::ReadAllBytes($localPath)
                }
                
                # Send HTTP response
                $header = "HTTP/1.1 200 OK`r`n"
                $header += "Content-Type: $responseType`r`n"
                $header += "Content-Length: $($bodyBytes.Length)`r`n"
                $header += "Access-Control-Allow-Origin: *`r`n"
                $header += "Cache-Control: no-cache, no-store, must-revalidate`r`n"
                $header += "Pragma: no-cache`r`n"
                $header += "Expires: 0`r`n"
                $header += "Connection: close`r`n`r`n"
                $headerBytes = [System.Text.Encoding]::UTF8.GetBytes($header)
                
                $stream.Write($headerBytes, 0, $headerBytes.Length)
                $stream.Write($bodyBytes, 0, $bodyBytes.Length)
            } else {
                # File not found
                $errContent = "<h1>404 Not Found</h1><p>The requested route <b>$urlPath</b> could not be resolved in the workspace.</p>"
                $bodyBytes = [System.Text.Encoding]::UTF8.GetBytes($errContent)
                $header = "HTTP/1.1 404 Not Found`r`nContent-Type: text/html`r`nContent-Length: $($bodyBytes.Length)`r`nConnection: close`r`n`r`n"
                $headerBytes = [System.Text.Encoding]::UTF8.GetBytes($header)
                
                $stream.Write($headerBytes, 0, $headerBytes.Length)
                $stream.Write($bodyBytes, 0, $bodyBytes.Length)
            }
            
            $client.Close()
        } catch {
            Write-Host "--> Connection error handled safely: $_" -ForegroundColor Yellow
            if ($null -ne $client) {
                $client.Close()
            }
        }
    }
} finally {
    $listener.Stop()
}
