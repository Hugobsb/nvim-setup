# Neovim setup by Hugobsb

My personal Neovim configuration built on [NvChad v2.5](https://nvchad.com/). It aims to be a complete development environment with full IDE capabilities for Go, Java, Kotlin, TypeScript/JavaScript, Rust, Lua, and more.

## Features

- **LSP & Diagnostics** — Multiple language servers with semantic highlighting, breadcrumb navigation (navic + dropbar), and Lspsaga-powered UI
- **Debugging** — The debugging is configured for all the languages that I have to deal with on a regular basis
- **Testing** — neotest framework with adapters for multiple languages
- **Git** — Neogit, diffview, gitsigns, git-conflict, fugitive, and Octo for GitHub PRs/issues
- **AI** — GitHub Copilot, CopilotChat with custom prompts, and Sidekick CLI integration
- **Navigation** — Harpoon 2, Telescope (with live-grep-args), dropbar breadcrumbs
- **Custom utilities** — Base64/URL encoding, UUID generation, alphabetical sorting, Ray.so screenshots, NPM tarball hashing, plugin patch system, etc.
- **Session management** — vim-obsession with TMUX-aware auto-save
- **GUI support** — Neovide configuration with cursor effects, font scaling, and transparency
- **Extras** — Discord Rich Presence, WakaTime, file encryption (ccryptor), database explorer (DBee), Markdown preview, etc.

## Requirements

- **Neovim** >= 0.10
- **Git** >= 2.19
- A [Nerd Font](https://www.nerdfonts.com/) (default: FiraCode Nerd Font)
- [ripgrep](https://github.com/BurntSushi/ripgrep) — required by Telescope live grep
- **Node.js** — required by several Mason packages and plugins
- **Go** — required for Go tooling (gopls, delve, gofumpt, goimports)
- **Java / SDKMAN** — optional, required for Java/Kotlin development (JDTLS, kotlin-debug-adapter)

## Installation

1. Back up your existing config if needed:

```bash
mv ~/.config/nvim ~/.config/nvim.bak
```

2. Clone the repository:

```bash
git clone git@github.com:Hugobsb/nvim-setup.git ~/.config/nvim
```

3. Open Neovim — lazy.nvim will bootstrap and install all plugins automatically:

```bash
nvim
```

4. Install all Mason packages:

```vim
:MasonInstallAll
```

## Environment Variables

| Variable                      | Description                                                                               |
|-------------------------------|-------------------------------------------------------------------------------------------|
| `NVIM_FONT`                   | Override default font (default: FiraCode Nerd Font)                                       |
| `ENABLE_NVIM_TRANSPARENCY`    | Set to `1` to enable transparent background                                               |
| `NVIM_SAFE_DIR`               | Directory for encrypted files (default: `~/Projects/safe/`)                               |
| `LAZY_SSH_PREFIX`             | SSH prefix for lazy.nvim plugin repos                                                     |
| `ENABLE_ETHERSYNC`            | Set to `true` to enable ethersync-nvim (default: `false`)                                 |
| `CODE_QUALITY_CHECKSTYLE`     | Give it a value (e.g., "true") to enable checkstyle.xml for Java linting (default: empty) |
| `CODE_QUALITY_PMD`            | Give it a value (e.g., "true") to enable PMD ruleset for Java linting (default: empty)    |
| `COMMITLINT_CONFIG_PATH`      | Path to commitlint config                                                                 |

## License

This is a personal configuration. Feel free to use it as a reference or starting point for your own setup.
