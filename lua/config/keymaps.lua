-- ~/.config/nvim/lua/config/keymaps.lua
-- Universal keymaps (work on both laptop and phone)

local map = vim.keymap.set
local opts = { noremap = true, silent = true }
local is_termux = vim.g.is_termux

-- Basic navigation (works everywhere)
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })

-- Buffer management
map("n", "<Tab>", "<cmd>bnext<CR>", opts)
map("n", "<S-Tab>", "<cmd>bprevious<CR>", opts)
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Close buffer" })

-- Window splits (always split the editor, never the file tree)
local function split_in_editor(cmd)
	return function()
		if vim.bo.filetype == "neo-tree" then
			vim.cmd("wincmd l")
		end
		vim.cmd(cmd)
	end
end

map("n", "<leader>sv", split_in_editor("vsplit"), { desc = "Vertical split" })
map("n", "<leader>sh", split_in_editor("split"), { desc = "Horizontal split" })

-- Window navigation (tree / editor / terminal)
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })

-- Terminal mode escaping
map("t", "<C-h>", [[<C-\><C-n><C-w>h]], opts)
map("t", "<C-j>", [[<C-\><C-n><C-w>j]], opts)
map("t", "<C-k>", [[<C-\><C-n><C-w>k]], opts)
map("t", "<C-l>", [[<C-\><C-n><C-w>l]], opts)
map("t", "<Esc>", [[<C-\><C-n>]], opts)

-- LSP keymaps (only if LSP is active)
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
map("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
map("n", "<leader>lr", vim.lsp.buf.rename, { desc = "Rename symbol" })
map("n", "<leader>la", vim.lsp.buf.code_action, { desc = "Code action" })
map("n", "<leader>ld", vim.diagnostic.open_float, { desc = "Show diagnostic" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

-- Environment-specific keymaps
if not is_termux then
	-- Laptop-only keymaps (Telescope, etc.)
	-- (<leader>e for Neo-tree now lives only in plugins/ui.lua)
	map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
	map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })
	map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Find buffers" })
	map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Help tags" })
	map("n", "<leader>;", "<cmd>Dashboard<CR>", { desc = "Open dashboard" })
	map("n", "<leader>gg", "<cmd>LazyGit<cr>", { desc = "LazyGit" })

	-- Theme toggle (laptop only - phone uses single theme)
  -- Load persisted colorscheme on startup
local colorscheme_file = vim.fn.stdpath("config") .. "/colorscheme.lua"

local function save_colorscheme(name)
  local f = io.open(colorscheme_file, "w")
  if f then
    f:write('vim.cmd.colorscheme("' .. name .. '")')
    f:close()
  end
end

local function load_colorscheme()
  if vim.fn.filereadable(colorscheme_file) == 1 then
    dofile(colorscheme_file)
  else
    vim.cmd.colorscheme("tokyonight-moon") -- your default fallback
  end
end

-- Apply on startup
load_colorscheme()

-- Call this from your toggle button
vim.api.nvim_create_user_command("SetColorscheme", function(opts)
  vim.cmd.colorscheme(opts.args)
  save_colorscheme(opts.args)
end, { nargs = 1 })

map("n", "<leader>ut", function()
  local themes = { "catppuccin", "tokyonight", "gruvbox", "rose-pine", "nightfox" }
  local index = vim.g.current_theme_index or 1
  index = index % #themes + 1
  vim.g.current_theme_index = index
  local theme = themes[index]
  vim.cmd.colorscheme(theme)
  save_colorscheme(theme)
  vim.notify("Theme: " .. theme, vim.log.levels.INFO)
end, { desc = "Toggle theme" })
else
	-- Phone-only keymaps (simpler alternatives)
	map("n", "<leader>ff", "<cmd>find ", { desc = "Find file" }) -- Simple :find
	map("n", "<leader>fg", "<cmd>vimgrep ", { desc = "Grep" }) -- Simple :vimgrep
	map("n", "<leader>e", "<cmd>Explore<CR>", { desc = "File explorer" }) -- Built-in explorer

	-- Single theme on phone (less overhead)
	map("n", "<leader>ut", function()
		vim.cmd.colorscheme("habamax")
	end, { desc = "Reset theme" })
end

-- Terminal toggle (works everywhere) - VS Code-style panel under the editor
map("n", "<leader>tt", function()
	require("core.workspace.terminal").toggle()
end, { desc = "Toggle terminal" })
map({ "n", "t" }, "<C-\\>", function()
	require("core.workspace.terminal").toggle()
end, { desc = "Toggle terminal" })

--Telescope Key Maps
map("n", "<leader>fp", function()
	require("core.workspace.telescope").pick()
end, { desc = "Projects" })
