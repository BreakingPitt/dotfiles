-----------------------------------------------------------
-- Neovim settings
-----------------------------------------------------------

-----------------------------------------------------------
-- General Neovim settings
-----------------------------------------------------------

vim.opt.clipboard = 'unnamedplus'                  -- use system clipboard 
vim.opt.completeopt = {'menu', 'menuone', 'noselect'}
vim.opt.mouse = 'a'                                -- allow the mouse to be used in Nvim

-----------------------------------------------------------
-- Tab
-----------------------------------------------------------

vim.opt.tabstop = 4                                -- Number of visual spaces per TAB
vim.opt.softtabstop = 4                            -- Number of spacesin tab when editing
vim.opt.shiftwidth = 4                             -- Insert 4 spaces on a tab
vim.opt.expandtab = true                           -- Tabs are spaces, mainly because of python

-----------------------------------------------------------
-- UI config
-----------------------------------------------------------

vim.opt.number = true                              -- Show absolute number
vim.opt.relativenumber = false                     -- Add numbers to each line on the left side
vim.opt.cursorline = false                         -- Highlight cursor line underneath the cursor horizontally
vim.opt.splitbelow = true                          -- Open new vertical split bottom
vim.opt.splitright = true                          -- Open new horizontal splits right
vim.opt.termguicolors = true                       -- Enable 24-bit RGB color in the TUI
vim.opt.showmode = false                           -- We are experienced, wo don't need the "-- INSERT --" mode hint

vim.cmd([[colorscheme dracula]])                   -- Set colorscheme
vim.cmd([[autocmd VimEnter * NvimTreeToggle ]])    -- Automatically open NvimTree when Neovim starts
vim.cmd([[
    autocmd VimLeavePre * NvimTreeClose
    autocmd VimLeavePre * edit #<last-edit>]])

-----------------------------------------------------------
-- Searching
-----------------------------------------------------------

vim.opt.incsearch = true                           -- Search as characters are entered.
vim.opt.hlsearch = false                           -- Do not highlight matches.
vim.opt.ignorecase = true                          -- Ignore case in searches by default.
vim.opt.smartcase = true                           -- Make it case sensitive if an uppercase is entered.

-----------------------------------------------------------
-- Memory, CPU
-----------------------------------------------------------

vim.opt.hidden = true                              -- Enable background buffers.
vim.opt.history = 100                              -- Remember n lines in history.
vim.opt.lazyredraw = true                          -- Faster scrolling.
vim.opt.synmaxcol = 240                            -- Max column for syntax highlight.

