<#
.SYNOPSIS
    Verify that all dev tools and MCP dependencies are installed.
#>

Write-Host "`n--- Verification Report ---" -ForegroundColor Cyan

# Check tools
$checks = @(
    @{ Cmd = "node --version";    Name = "Node.js" },
    @{ Cmd = "python --version";  Name = "Python" },
    @{ Cmd = "git --version";     Name = "Git" },
    @{ Cmd = "gh --version";      Name = "GitHub CLI" },
    @{ Cmd = "docker --version";  Name = "Docker" },
    @{ Cmd = "npm --version";     Name = "npm" }
)

$passed = 0
$failed = 0

foreach ($check in $checks) {
    try {
        $result = Invoke-Expression $check.Cmd 2>$null
        if ($LASTEXITCODE -eq 0 -or $result) {
            $version = ($result -split "`n")[0].Trim()
            Write-Host "  [OK]   $($check.Name): $version" -ForegroundColor Green
            $passed++
        } else {
            Write-Host "  [FAIL] $($check.Name): not found" -ForegroundColor Red
            $failed++
        }
    } catch {
        Write-Host "  [FAIL] $($check.Name): not found" -ForegroundColor Red
        $failed++
    }
}

# Check Docker images
Write-Host "`n--- Docker Images ---" -ForegroundColor Cyan
$requiredImages = @("mcp/fetch", "mcp/git", "ghcr.io/github/github-mcp-server", "mcp/notion", "mcp/n8n")
$dockerOk = docker info 2>$null
if ($LASTEXITCODE -eq 0) {
    foreach ($img in $requiredImages) {
        $exists = docker images --format "{{.Repository}}" 2>$null | Where-Object { $_ -eq $img }
        if ($exists) {
            Write-Host "  [OK]   $img" -ForegroundColor Green
            $passed++
        } else {
            Write-Host "  [MISS] $img -- run: docker pull $img" -ForegroundColor Yellow
            $failed++
        }
    }
} else {
    Write-Host "  [WARN] Docker not running" -ForegroundColor Yellow
    $failed += $requiredImages.Count
}

# Check Cursor MCP config
Write-Host "`n--- Cursor Config ---" -ForegroundColor Cyan
$mcpPath = "$env:USERPROFILE\.cursor\mcp.json"
if (Test-Path $mcpPath) {
    try {
        $config = Get-Content $mcpPath | ConvertFrom-Json
        $serverCount = ($config.mcpServers | Get-Member -MemberType NoteProperty).Count
        Write-Host "  [OK]   mcp.json found ($serverCount servers configured)" -ForegroundColor Green
        $passed++
    } catch {
        Write-Host "  [FAIL] mcp.json has invalid JSON" -ForegroundColor Red
        $failed++
    }
} else {
    Write-Host "  [MISS] mcp.json not found at $mcpPath" -ForegroundColor Yellow
    $failed++
}

# Summary
Write-Host "`n--- Summary ---" -ForegroundColor Cyan
Write-Host "  Passed: $passed" -ForegroundColor Green
if ($failed -gt 0) {
    Write-Host "  Failed: $failed" -ForegroundColor Red
} else {
    Write-Host "  Failed: 0" -ForegroundColor Green
}
Write-Host ""
