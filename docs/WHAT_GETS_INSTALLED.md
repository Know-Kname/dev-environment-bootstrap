# What Gets Installed

## Dev Tools (via winget)

| Tool | winget ID | Purpose |
|---|---|---|
| Node.js 22 LTS | `OpenJS.NodeJS.LTS` | JavaScript runtime, npm |
| Python 3.12 | `Python.Python.3.12` | Python runtime, pip |
| Git | `Git.Git` | Version control |
| GitHub CLI | `GitHub.cli` | GitHub from terminal (`gh`) |
| Docker Desktop | `Docker.DockerDesktop` | Container runtime |
| Cursor IDE | `Cursor.Cursor` | AI-powered code editor |
| VS Code | `Microsoft.VisualStudioCode` | Backup editor |
| Windows Terminal | `Microsoft.WindowsTerminal` | Modern terminal |

## Docker Images (for MCP servers)

| Image | Purpose |
|---|---|
| `mcp/fetch` | Fetch and parse web pages |
| `mcp/git` | Git operations |
| `ghcr.io/github/github-mcp-server` | GitHub API |
| `mcp/notion` | Notion pages and databases |
| `mcp/n8n` | Workflow automation |

## npx Packages (pre-cached for MCP)

| Package | Purpose |
|---|---|
| `@modelcontextprotocol/server-memory` | Persistent knowledge graph |
| `@modelcontextprotocol/server-sequential-thinking` | Multi-step reasoning |
| `@upstash/context7-mcp@latest` | Library documentation |

## Config Files

| File | Destination | Purpose |
|---|---|---|
| `mcp.json.template` | `~/.cursor/mcp.json` | MCP server configuration |
| `.gitconfig.template` | Reference only | Git configuration |
| `.gitignore_global` | `~/.gitignore_global` | Global gitignore |
| `.editorconfig` | `~/.editorconfig` | Editor formatting |
