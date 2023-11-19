require "user.options"
require "user.keymaps"
require "user.plugins"
require "user.colorscheme"
require "user.cmp"
require "user.lsp"
require "user.telescope"
require "user.gitsigns"
require "user.treesitter"
require "user.autopairs"
require "user.comment"
require "user.nvim-tree"
require "user.bufferline"
require "user.lualine"
require "user.toggleterm"
require "user.project"
require "user.impatient"
require "user.indentline"
require "user.alpha"
require "user.whichkey"
require "user.autocommands"
require "user.swapbuffers"
--------
--[Light/Dark Toggle for Neovim, Fish, and Kitty](https://evantravers.com/articles/2022/02/08/light-dark-toggle-for-neovim-fish-and-kitty/)
--if os.getenv('theme') == 'light' then
--  vim.o.background = 'light'
--end
--------
require('dark_notify').run()
