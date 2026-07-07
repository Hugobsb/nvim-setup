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

## Running in Docker

A `Dockerfile` and `docker-compose.yml` are included for running this setup fully containerised. The image bundles all language runtimes (Node.js 22, Go, Java 21, Rust) and bootstraps lazy.nvim plugins at build time. Mason packages (LSP servers, formatters, DAP adapters) install on first launch and are then cached in a Docker volume.

> **Build time:** ~15–20 minutes (language runtimes + plugin compilation).
> **First launch:** ~5–10 minutes (39 Mason packages download and install into the volume).
> **Subsequent launches:** instant.

### Build the image

```bash
docker build -t nvim-setup ~/.config/nvim
```

---

### Persistent

Mason packages, plugin state, and Neovim history (marks, shada, sessions) survive between runs via named Docker volumes. Mount the volumes, everything else is discarded on exit.

```bash
docker run --rm -it \
  -v "$(pwd):/workspace" \
  -v nvim-data:/root/.local/share/nvim \
  -v nvim-state:/root/.local/state/nvim \
  -v "$HOME/.gitconfig:/root/.gitconfig:ro" \
  -v "$HOME/.ssh:/root/.ssh:ro" \
  -w /workspace \
  nvim-setup
```

**Convenience alias** (add to `~/.zshrc` or `~/.bashrc`):

```bash
alias dnvim='docker run --rm -it \
  -v "$(pwd):/workspace" \
  -v nvim-data:/root/.local/share/nvim \
  -v nvim-state:/root/.local/state/nvim \
  -v "$HOME/.gitconfig:/root/.gitconfig:ro" \
  -v "$HOME/.ssh:/root/.ssh:ro" \
  -w /workspace \
  nvim-setup'
```

With docker compose (run from `~/.config/nvim/`, set `WORKSPACE` to your project):

```bash
WORKSPACE=/path/to/project docker compose run --rm nvim
```

---

### Ephemeral

Same command without the `nvim-data`/`nvim-state` volumes. Mason packages are **not** installed (no LSP/formatting/debugging) — useful for quick edits only.

```bash
docker run --rm -it \
  -v "$(pwd):/workspace" \
  -v "$HOME/.gitconfig:/root/.gitconfig:ro" \
  -v "$HOME/.ssh:/root/.ssh:ro" \
  -w /workspace \
  nvim-setup
```

Nothing outside `/workspace` survives after exit.

**Convenience alias:**

```bash
alias dnvim-tmp='docker run --rm -it \
  -v "$(pwd):/workspace" \
  -v "$HOME/.gitconfig:/root/.gitconfig:ro" \
  -v "$HOME/.ssh:/root/.ssh:ro" \
  -w /workspace \
  nvim-setup'
```

---

### Pre-warming an ephemeral image

To bake Mason packages into the image so ephemeral runs have full IDE features:

```bash
docker run --name nvim-warm nvim-setup --headless \
  -c "lua vim.defer_fn(function() vim.cmd('MasonInstallAll') end, 3000)" \
  -c "sleep 300" \
  -c "qa!"
docker commit nvim-warm nvim-setup-full
docker rm nvim-warm
```

Then replace `nvim-setup` with `nvim-setup-full` in any of the commands above.

---

### GitHub Copilot

Authenticate inside a persistent container — credentials are stored in the `nvim-state` volume and persist across sessions:

```vim
:Copilot auth
```

---

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
