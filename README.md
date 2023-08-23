<h1 align="center">✨ Neovim Custom Configuration ✨</h1>
Custom folder from NvChad directory to keep track of my personal configuration

# Get Started
Follow the instructions to properly setup the editor on the first time it is opened.

## Syntax highlighting
No need to worry at all. TreeSitter will install everything described [here](https://github.com/Hugobsb/neovim-custom-configuration/blob/78971fec0f6db9356106391a3b16b2044d622113/configs/treesitter-c.lua#L2-L24).

## Language server & Formatting
Be sure to **install all Mason packages** in the first time the editor is opened to install everything described [here](https://github.com/Hugobsb/neovim-custom-configuration/blob/78971fec0f6db9356106391a3b16b2044d622113/configs/mason-c.lua#L2-L23).
This can be done using the command:

```
:MasonInstallAll
```

# Manual intervention
Details what requires user manual setup to work as expected.

## Telescope live grep
To install it, `ripgrep` is a dependency. It can be installed following [ripgrep instructions](https://github.com/BurntSushi/ripgrep#installation).

Mainly, using the distribution I'm currently using, Arch Linux, the following can be done:

```bash
$ sudo pacman -S ripgrep
```

Or, commonly, Ubuntu:

```bash
$ sudo apt install ripgrep -y
```

## LazyGit
LazyGit was configured to use [delta](https://github.com/dandavison/delta) as the Git Pager. However, as pointed in the
[LazyGit documentation](https://github.com/jesseduffield/lazygit/blob/master/docs/Custom_Pagers.md#delta), the following yml
must be added in order to enable delta as a pager:

1. First, navigate to the `status` section;
2. Then, press the `o` key;
3. With the yml opened, paste the following configuration:
```yml
git:
  paging:
    colorArg: always
    pager: delta --dark --paging=never
```
