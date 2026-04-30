# Yoofloe CLI Releases

This public repository hosts Yoofloe CLI installer scripts and native binary releases.

The Yoofloe CLI source repository remains private. Public release assets are published here so end users can install the CLI and the bundled `yoofloe mcp` server without GitHub collaborator access.

## Install

### macOS / Linux

```bash
curl -fsSL https://raw.githubusercontent.com/yoofloe/yoofloe-cli-releases/main/install.sh | bash
```

### Windows PowerShell

```powershell
irm https://raw.githubusercontent.com/yoofloe/yoofloe-cli-releases/main/install.ps1 | iex
```

### Windows CMD

```cmd
curl -fsSL https://raw.githubusercontent.com/yoofloe/yoofloe-cli-releases/main/install.cmd -o install.cmd && install.cmd && del install.cmd
```

## Notes

- Native binaries are attached to GitHub Releases in this repository.
- `YOOFLOE_REPO` can override the binary release repository for installer testing.
- `YOOFLOE_INSTALL_DIR` can override the install directory.
- macOS binaries are currently unsigned and may require a manual approval in System Settings.
