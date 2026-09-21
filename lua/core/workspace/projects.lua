local M = {}

-- Directories to scan
M.base_dirs = {
	vim.fn.expand("~/projects"),
	vim.fn.expand("~/code"),
	vim.fn.expand("~/workspace"),
  vim.fn.expand("~/Desktop"),
  vim.fn.expand("./Documents"),
  vim.fn.expand("~/.config/nvim"),
  vim.fn.expand("~/.config"),
}

-- Files that indicate a project
M.project_markers = {
	".git",
	"package.json",
	"pyproject.toml",
	"requirements.txt",
}

-- Check if directory is a project
local function is_project(path)
	for _, marker in ipairs(M.project_markers) do
		if vim.fn.glob(path .. "/" .. marker) ~= "" then
			return true
		end
	end
	return false
end

-- Scan for projects
function M.get_projects()
	local projects = {}

	for _, base in ipairs(M.base_dirs) do
		local expanded = vim.fn.expand(base)

		local dirs = vim.fn.glob(expanded .. "/*", false, true)

		for _, dir in ipairs(dirs) do
			if vim.fn.isdirectory(dir) == 1 and is_project(dir) then
				table.insert(projects, {
					name = vim.fn.fnamemodify(dir, ":t"),
					path = dir,
				})
			end
		end
	end

	return projects
end

return M
