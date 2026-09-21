local startup = require("core.startup")

return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		cmd = "Neotree",
		keys = {
			{ "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle file tree" },
		},
		opts = {
			close_if_last_window = true,
			window = { position = "left", width = 32 },
			filesystem = {
				follow_current_file = { enabled = true }, -- highlights the file you're editing
				filtered_items = {
					visible = true,
					hide_dotfiles = false,
				},
			},
		},
	},

	{
		"akinsho/bufferline.nvim",
		event = "VeryLazy",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			require("bufferline").setup({
				options = {
					mode = "buffers",
					diagnostics = "nvim_lsp",
					offsets = {
						{
							filetype = "neo-tree",
							text = "File Explorer",
							text_align = "center",
							separator = true,
						},
					},
					separator_style = "slant",
				},
			})
		end,
	},

	{
		"nvimdev/dashboard-nvim",
		-- Only auto-open on startup when we're NOT inside a project.
		-- `cmd` keeps <leader>; (:Dashboard) working in project sessions.
		event = startup.show_dashboard() and "VimEnter" or nil,
		cmd = "Dashboard",
		config = function()
			local db = require("dashboard")
			local workspace = require("core.workspace.switch")

			db.setup({
				theme = "hyper",

				config = {
					shortcut = {
						{
							desc = "Projects",
							group = "Label",
							action = function()
								require("core.workspace.telescope").pick()
							end,
							key = "p",
						},
					},

					project = {
						enable = true,
						action = function(path)
							workspace.open_project(path)
						end,
					},
				},
			})
		end,
	},

	{
		"rcarriga/nvim-notify",
		lazy = false,
		config = function()
			local notify = require("notify")
			notify.setup({
				stages = "fade_in_slide_out",
				timeout = 2000,
			})
			vim.notify = notify
		end,
	},

	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = { "MunifTanjim/nui.nvim" },
		config = function()
			require("noice").setup({
				lsp = {
					progress = { enabled = true },
					signature = { enabled = true },
					hover = { enabled = true },
				},
				presets = {
					bottom_search = true,
					command_palette = true,
				},
			})
		end,
	},

	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			indent = { char = "│" },
			scope = { enabled = false },
		},
	},

	{
		"HiPhish/rainbow-delimiters.nvim",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			local rainbow = require("rainbow-delimiters")
			vim.g.rainbow_delimiters = {
				strategy = {
					[""] = rainbow.strategy["global"],
				},
				query = {
					[""] = "rainbow-delimiters",
				},
			}
		end,
	},
}
