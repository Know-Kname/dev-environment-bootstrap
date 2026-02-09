<#
.SYNOPSIS
    Install dev tools via winget.
#>

$tools = @(
    @{ Id = "OpenJS.NodeJS.LTS";           Name = "Node.js 22 LTS" },
    @{ Id = "Python.Python.3.12";          Name = "Python 3.12" },
    @{ Id = "Git.Git";                     Name = "Git" },
    @{ Id = "GitHub.cli";                  Name = "GitHub CLI" },
    @{ Id = "Docker.DockerDesktop";        Name = "Docker Desktop" },
    @{ Id = "Cursor.Cursor";              Name = "Cursor IDE" },
    @{ Id = "Microsoft.VisualStudioCode"; Name = "VS Code" },
    @{ Id = "Microsoft.WindowsTerminal";  Name = "Windows Terminal" }
)

foreach ($tool in $tools) {
    $installed = winget list --id $tool.Id 2>$null
    if ($LASTEXITCODE -eq 0 -and $installed -match $tool.Id) {
        Write-Success "$($tool.Name) already installed"
    } else {
        Write-Host "   Installing $($tool.Name)..." -ForegroundColor Gray
        winget install --id $tool.Id --accept-source-agreements --accept-package-agreements --silent 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-Success "$($tool.Name) installed"
        } else {
            Write-Warn "Could not install $($tool.Name) -- install manually"
        }
    }
}

# Refresh PATH
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
