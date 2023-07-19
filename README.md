# neovim-custom-configuration
Custom folder from NvChad directory to keep track of my personal configuration

## Custom configuration
Details what requires manual setup to work as expected.

### LazyGit
LazyGit was configured to use [delta](https://github.com/dandavison/delta) as the Git Pager. However, as pointed in the
[LazyGit documentation](https://github.com/jesseduffield/lazygit/blob/master/docs/Custom_Pagers.md#delta), the following yml
must be added in order to enable delta as a pager.

1. First, navigate to the `status` section;
2. Then, press the `o` key;
3. With the yml opened, paste the following configuration:
```yml
git:
  paging:
    colorArg: always
    pager: delta --dark --paging=never
```
