-- lua/core/startup.lua
-- Decides how Neovim starts: inside a project -> file tree, otherwise dashboard.
local M = {}

-- A directory containing (or sitting below) one of these counts as a project
local markers = { ".git", "package.json", "pyproject.toml", "Cargo.toml", "go.mod", "Dockerfile" }

-- Returns the project root for this launch, or nil
function M.project_root()
	local argc = vim.fn.argc()
	if argc > 1 then
		return nil
	end

	if argc == 1 then -- `nvim .` counts, `nvim file.lua` doesn't
		local arg = vim.fn.fnamemodify(vim.fn.argv(0), ":p")
		return vim.fn.isdirectory(arg) == 1 and arg or nil
	end

	local found = vim.fs.find(markers, {
		path = vim.fn.getcwd(),
		upward = true,
		stop = vim.env.HOME, -- don't treat ~ itself as a project
		limit = 1,
	})[1]
	return found and vim.fs.dirname(found) or nil
end

-- Read by the dashboard spec in plugins/ui.lua
function M.show_dashboard()
	return vim.fn.argc() == 0 and M.project_root() == nil
end

-- Call once from init.lua
function M.setup()
	vim.api.nvim_create_autocmd("VimEnter", {
		once = true,
		callback = function()
			local root = M.project_root()
			if not root then
				return
			end
			-- If workspace.open_project(root) does more than cd + tree,
			-- call it here instead of these lines.
			vim.api.nvim_set_current_dir(root)
			if vim.bo.filetype == "netrw" then
				vim.cmd.enew()
			end
			-- Only laptop has neo-tree; phone (Termux) doesn't define :Neotree
			if vim.fn.exists(":Neotree") == 2 then
				vim.cmd("Neotree show")
			end
		end,
	})
end

return M
