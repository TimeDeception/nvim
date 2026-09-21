-- lua/core/workspace/terminal.lua
-- VS Code-style bottom terminal: splits only the editor window, so the file
-- tree keeps its full height and the panel is only as wide as the editor.
local M = {}

local state = { buf = nil, win = nil }
local HEIGHT = 15

local function valid_win(w)
	return w and vim.api.nvim_win_is_valid(w)
end

local function valid_buf(b)
	return b and vim.api.nvim_buf_is_valid(b)
end

-- Split under the current window, unless it's the tree or the terminal
local function editor_win()
	local function ok(w)
		local b = vim.api.nvim_win_get_buf(w)
		return vim.api.nvim_win_get_config(w).relative == ""
			and vim.bo[b].filetype ~= "neo-tree"
			and vim.bo[b].buftype ~= "terminal"
	end

	local cur = vim.api.nvim_get_current_win()
	if ok(cur) then
		return cur
	end
	for _, w in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
		if ok(w) then
			return w
		end
	end
end

function M.toggle()
	-- Already open: hide it (the shell keeps running)
	if valid_win(state.win) then
		vim.api.nvim_win_hide(state.win)
		state.win = nil
		return
	end

	local target = editor_win()
	if not target then
		return
	end
	vim.api.nvim_set_current_win(target)
	vim.cmd("belowright " .. HEIGHT .. "split")
	state.win = vim.api.nvim_get_current_win()

	if valid_buf(state.buf) then
		vim.api.nvim_win_set_buf(state.win, state.buf)
	else
		vim.cmd.terminal()
		state.buf = vim.api.nvim_get_current_buf()
		vim.bo[state.buf].buflisted = false

		-- When the shell exits, clean up so the next toggle starts fresh
		vim.api.nvim_create_autocmd("TermClose", {
			buffer = state.buf,
			once = true,
			callback = function()
				vim.schedule(function()
					if valid_win(state.win) then
						vim.api.nvim_win_close(state.win, true)
					end
					if valid_buf(state.buf) then
						vim.api.nvim_buf_delete(state.buf, { force = true })
					end
					state.win, state.buf = nil, nil
				end)
			end,
		})
	end

	-- Must be set AFTER the buffer is in the window: window options set before
	-- a buffer switch get reset, which let the terminal expand.
	vim.wo[state.win].winfixheight = true
	vim.cmd.startinsert()
end

return M
