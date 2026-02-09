<#
.SYNOPSIS
    Configure MCP servers for Cursor IDE.
.DESCRIPTION
    Copies mcp.json template, pulls Docker images, pre-caches npx packages.
#>

# Copy MCP config template
$mcpSrc = "$PSScriptRoot\..\config\cursor\mcp.json.template"
$mcpDst = "$env:USERPROFILE\.cursor\mcp.json"

if (-not (Test-Path "$env:USERPROFILE\.cursor")) {
    New-Item -ItemType Directory -Path "$env:USERPROFILE\.cursor" -Force | Out-Null
}

if (Test-Path $mcpDst) {
    Write-Warn "mcp.json already exists -- skipping (backup at mcp.json.bak)"
    Copy-Item $mcpDst "$mcpDst.bak" -Force
} else {
    Copy-Item $mcpSrc $mcpDst -Force
    Write-Success "mcp.json template installed to ~/.cursor/"
}

# Pull Docker images for MCP servers
$dockerImages = @(
    "mcp/fetch",
    "mcp/git",
    "ghcr.io/github/github-mcp-server",
    "mcp/notion",
    "mcp/n8n"
)

$dockerRunning = docker info 2>$null
if ($LASTEXITCODE -eq 0) {
    foreach ($image in $dockerImages) {
        Write-Host "   Pulling $image..." -ForegroundColor Gray
        docker pull $image 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-Success "Pulled $image"
        } else {
            Write-Warn "Could not pull $image"
        }
    }
} else {
    Write-Warn "Docker not running -- start Docker Desktop and re-run"
}

# Pre-cache npx packages
$npxPackages = @(
    "@modelcontextprotocol/server-memory",
    "@modelcontextprotocol/server-sequential-thinking",
    "@upstash/context7-mcp@latest"
)

foreach ($pkg in $npxPackages) {
    Write-Host "   Pre-caching $pkg..." -ForegroundColor Gray
    npx -y $pkg --help 2>$null | Out-Null
    Write-Success "Cached $pkg"
}
