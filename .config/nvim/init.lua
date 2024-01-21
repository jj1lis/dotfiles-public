--[[

=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================

Kickstart.nvim is *not* a distribution.

Kickstart.nvim is a template for your own configuration.
  The goal is that you can read every line of code, top-to-bottom, understand
  what your configuration is doing, and modify it to suit your needs.

  Once you've done that, you should start exploring, configuring and tinkering to
  explore Neovim!

  If you don't know anything about Lua, I recommend taking some time to read through
  a guide. One possible example:
  - https://learnxinyminutes.com/docs/lua/


  And then you can explore or search through `:help lua-guide`
  - https://neovim.io/doc/user/lua-guide.html


Kickstart Guide:

I have left several `:help X` comments throughout the init.lua
You should run that command and read that help section for more information.

In addition, I have some `NOTE:` items throughout the file.
These are for you, the reader to help understand what is happening. Feel free to delete
them once you know what you're doing, but they should serve as a guide for when you
are first encountering a few different constructs in your nvim config.

I hope you enjoy your Neovim journey,
- TJ

P.S. You can delete this when you're done too. It's your config now :)
--]]

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Setup lazy.nvim
require('lazy-nvim-config')

-- Read setting options
require("options")

-- Read basic keymaps
require("keymaps")

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Setup telescope.nvim families
-- See lua/telescope-nvim-family/<plugin>/ about each plugins for details
require('telescope-nvim-family')

-- Setup nvim-treesitter families
-- See lua/nvim-treesitter-family/<plugin>/ about each plugins for details
require('nvim-treesitter-family')

-- Setup about LSP
-- See lua/lsp/<plugin>/ about each plugins for details
require('lsp-plugins')

-- Setup nvim-cmp families
-- See lua/nvim-cmp about each plugins
require('nvim-cmp-family')

-- Setup lualine.nvim
require('lualine-nvim-config')

-- Setup nvim-autopairs
require('nvim-autopairs-config')

-- Setup notice.nvim
require('notice-nvim-config')

-- Setup hlargs.nvim
require('hlargs-nvim-config')

-- Setup sidebar.nvim
require('sidebar-nvim-config')

-- Setup vim-illuminate
require('vim-illuminate-config')

-- Setup todo-comments.nvim_lsp
require('todo-comments-nvim-config')

-- Setup about Git
-- See lua/git/<plugin>/ about each plugins for details
require('git-plugins')

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
