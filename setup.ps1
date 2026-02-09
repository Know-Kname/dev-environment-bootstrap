#Requires -RunAsAdministrator
<#
.SYNOPSIS
    One-command dev environment bootstrap for Windows.
.DESCRIPTION
    Installs dev tools, configures MCP servers for Cursor IDE,
    sets up git config, and verifies everything works.
.NOTES
    Run from elevated PowerShell: .\setup.ps1
#>

param(
    [switch]$SkipTools,
    [switch]$SkipMCP,
    [switch]$SkipConfig,
    [switch]$VerifyOnly
)

$ErrorActionPreference = 'Continue'
$script:errors = @()

function Write-Step($message) {
    Write-Host "`n>> $message" -ForegroundColor Cyan
}

function Write-Success($message) {
    Write-Host "   [OK] $message" -ForegroundColor Green
}

function Write-Warn($message) {
    Write-Host "   [WARN] $message" -ForegroundColor Yellow
}

function Write-Fail($message) {
    Write-Host "   [FAIL] $message" -ForegroundColor Red
    $script:errors += $message
}

# Header
Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  Dev Environment Bootstrap" -ForegroundColor Cyan
Write-Host "  $(Get-Date -Format 'yyyy-MM-dd HH:mm')" -ForegroundColor Gray
Write-Host "============================================" -ForegroundColor Cyan

if ($VerifyOnly) {
    Write-Step "Running verification only..."
    & "$PSScriptRoot\scripts\verify-setup.ps1"
    exit
}

# Step 1: Install tools
if (-not $SkipTools) {
    Write-Step "Installing dev tools..."
    & "$PSScriptRoot\scripts\install-tools.ps1"
}

# Step 2: Configure MCP
if (-not $SkipMCP) {
    Write-Step "Configuring MCP servers..."
    & "$PSScriptRoot\scripts\configure-mcp.ps1"
}

# Step 3: Copy config files
if (-not $SkipConfig) {
    Write-Step "Setting up configuration files..."

    # Global gitignore
    $gitignoreSrc = "$PSScriptRoot\config\git\.gitignore_global"
    $gitignoreDst = "$env:USERPROFILE\.gitignore_global"
    if (Test-Path $gitignoreSrc) {
        Copy-Item $gitignoreSrc $gitignoreDst -Force
        git config --global core.excludesfile $gitignoreDst
        Write-Success "Global gitignore installed"
    }

    # EditorConfig
    $editorSrc = "$PSScriptRoot\config\editor\.editorconfig"
    $editorDst = "$env:USERPROFILE\.editorconfig"
    if (Test-Path $editorSrc) {
        Copy-Item $editorSrc $editorDst -Force
        Write-Success "EditorConfig installed"
    }
}

# Step 4: Verify
Write-Step "Verifying installation..."
& "$PSScriptRoot\scripts\verify-setup.ps1"

# Summary
Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
if ($script:errors.Count -eq 0) {
    Write-Host "  Setup complete! No errors." -ForegroundColor Green
} else {
    Write-Host "  Setup complete with $($script:errors.Count) warning(s):" -ForegroundColor Yellow
    $script:errors | ForEach-Object { Write-Host "    - $_" -ForegroundColor Yellow }
}
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor White
Write-Host "  1. Set API keys as environment variables" -ForegroundColor Gray
Write-Host "  2. Start Docker Desktop" -ForegroundColor Gray
Write-Host "  3. Restart Cursor to load MCP servers" -ForegroundColor Gray
Write-Host ""
