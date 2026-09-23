------------------------------------------------------------
-- Leader keys (MUST be first)
------------------------------------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

------------------------------------------------------------
-- Environment detection
------------------------------------------------------------
local is_termux = vim.fn.isdirectory("/data/data/com.termux") == 1
local is_ssh = os.getenv("SSH_CONNECTION") ~= nil

vim.g.is_termux = is_termux
vim.g.is_ssh = is_ssh

------------------------------------------------------------
-- Core options (shared)
------------------------------------------------------------
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.wildmode = { "longest", "list" }
vim.opt.showtabline = 2
vim.opt.updatetime = 1000
vim.opt.title = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.hlsearch = true

vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.scriptencoding = "utf-8"

------------------------------------------------------------
-- Environment-specific tweaks
------------------------------------------------------------
if is_termux then
	vim.opt.termguicolors = false
	vim.opt.lazyredraw = true
	vim.opt.updatetime = 2000
	vim.opt.showtabline = 0
	vim.opt.cmdheight = 1
else
	vim.opt.termguicolors = true
end

------------------------------------------------------------
vim.lsp.buf.format({
	async = false,
	filter = function(client)
		return client.supports_method("textDocument/formatting")
	end,
})

------------------------------------------------------------
-- Bootstrap (IMPORTANT)
-- session + runtime autocmds live here
------------------------------------------------------------
require("core.startup").setup()

require("core.bootstrap")

------------------------------------------------------------
-- Plugin system (lazy.nvim)
------------------------------------------------------------
require("config.lazy")

------------------------------------------------------------
-- Keymaps (keep separate)
------------------------------------------------------------
require("config.keymaps")

-----------------------------------------------------------
require("config.options")
