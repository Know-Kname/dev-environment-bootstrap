# Dev Environment Bootstrap

One-command setup for your entire development toolchain: Cursor IDE, MCP servers, AI workflows, dotfiles, and dev tools.

## Quick Start (Windows)

```powershell
# Run from an elevated PowerShell terminal
irm https://raw.githubusercontent.com/Know-Kname/dev-environment-bootstrap/main/setup.ps1 | iex
```

Or clone and run locally:
```powershell
git clone https://github.com/Know-Kname/dev-environment-bootstrap.git
cd dev-environment-bootstrap
.\setup.ps1
```

## What Gets Installed

### Dev Tools (via winget)
- **Node.js 22** -- JavaScript runtime
- **Python 3.12** -- Python runtime
- **Git** -- Version control
- **GitHub CLI** (`gh`) -- GitHub from terminal
- **Docker Desktop** -- Container runtime
- **Cursor IDE** -- AI-powered code editor
- **Visual Studio Code** -- Backup editor
- **Windows Terminal** -- Modern terminal

### MCP Infrastructure
- **5 Docker images** pulled: mcp/fetch, mcp/git, mcp/notion, mcp/n8n, ghcr.io/github/github-mcp-server
- **4 npx packages** pre-cached: memory, sequential-thinking, perplexity, context7
- **mcp.json** template copied to `~/.cursor/`

### Configuration
- **Git config** with LFS, user info template
- **Global gitignore** for OS files, editor configs, env files
- **EditorConfig** for consistent formatting
- **Cursor rules** (14 behavioral rule templates)

## File Structure

```
dev-environment-bootstrap/
  setup.ps1                    # Main entry point (Windows)
  setup.sh                     # Main entry point (Linux/Mac)
  scripts/
    install-tools.ps1          # Winget tool installation
    configure-mcp.ps1          # MCP server setup for Cursor
    verify-setup.ps1           # Health check everything
  config/
    cursor/
      mcp.json.template        # MCP config (replace secrets)
    git/
      .gitconfig.template      # Git config template
      .gitignore_global        # Global gitignore
    editor/
      .editorconfig            # Universal editor settings
  docs/
    WHAT_GETS_INSTALLED.md     # Full tool list
  LICENSE
```

## Post-Setup

After running the bootstrap:

1. **Set API keys** as environment variables:
   - `PERPLEXITY_API_KEY` -- perplexity.ai/settings/api
   - `GITHUB_PERSONAL_ACCESS_TOKEN` -- github.com/settings/tokens
   - `NOTION_API_KEY` -- notion.so/my-integrations

2. **Start Docker Desktop** and wait 60 seconds

3. **Restart Cursor** to load MCP servers

4. **Run verification**:
   ```powershell
   .\scripts\verify-setup.ps1
   ```

## Customization

- Edit `config/cursor/mcp.json.template` to add/remove MCP servers
- Edit `scripts/install-tools.ps1` to change which tools are installed
- All templates use `<placeholder>` syntax for values you need to fill in

## License

MIT
