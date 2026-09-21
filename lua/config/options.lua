-- ~/.config/nvim/lua/config/options.lua
-- Unified environment-specific options (laptop + phone)

local is_termux = vim.g.is_termux

------------------------------------------------------------
-- Shared base options
------------------------------------------------------------
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

vim.opt.number = true
vim.opt.cursorline = true
vim.opt.hlsearch = true

vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.scriptencoding = "utf-8"

vim.opt.autoindent = true
vim.opt.smartindent = true

vim.opt.updatetime = is_termux and 2000 or 1000

------------------------------------------------------------
-- Environment-specific options
------------------------------------------------------------
if is_termux then
	--------------------------------------------------------
	-- PHONE (Termux)
	--------------------------------------------------------

	vim.opt.termguicolors = false
	vim.opt.lazyredraw = true

	vim.opt.showtabline = 0
	vim.opt.cmdheight = 1

	vim.opt.swapfile = false
	vim.opt.backup = false
	vim.opt.writebackup = false

	vim.opt.synmaxcol = 200
	vim.opt.history = 100

	vim.opt.grepprg = "grep -n $* /dev/null"

	vim.g.loaded_node_provider = 0
	vim.g.loaded_perl_provider = 0
	vim.g.loaded_ruby_provider = 0

	vim.diagnostic.config({
		virtual_text = false,
		signs = true,
		underline = true,
		update_in_insert = false,
	})

	vim.api.nvim_echo({
		{ "📱 Phone mode active - lightweight config loaded", "Title" },
	}, false, {})

else
	--------------------------------------------------------
	-- LAPTOP
	--------------------------------------------------------
  ---

  vim.opt.equalalways = false
  vim.opt.splitright = true
  vim.opt.splitbelow = true
	vim.opt.termguicolors = true
	vim.opt.showtabline = 2

	vim.opt.grepprg = "rg --vimgrep --smart-case || grep -n $* /dev/null"

	vim.diagnostic.config({
		virtual_text = true,
		signs = true,
		underline = true,
		update_in_insert = false,
	})
end
