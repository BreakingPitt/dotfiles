-----------------------------------------------------------
-- Plugin: nvim-tree
-- https://github.com/kyazdani42/nvim-tree.lua
-----------------------------------------------------------

vim.g.nvim_tree_width = 27
vim.g.nvim_tree_ignore = {'.git', 'node_modules', '.cache'}
vim.g.nvim_tree_gitignore = 0
vim.g.nvim_tree_auto_open = 1
vim.g.nvim_tree_indent_markers = 1
vim.g.nvim_tree_hide_dotfiles = 0
vim.g.nvim_tree_git_hl = 1
vim.g.nvim_tree_width_allow_resize  = 1
vim.g.nvim_tree_special_files = {'README.md', 'Makefile', 'MAKEFILE'}
vim.g.nvim_tree_show_icons = {
  git = 1,
  folders = 1,
  files = 1
}

vim.g.nvim_tree_icons = {
	default = "‣ "
}

