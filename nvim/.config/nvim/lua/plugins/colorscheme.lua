return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha", -- fixed dark theme for VPS
				transparent_background = true,

				float = {
					transparent = true, -- make floating windows transparent too
					solid = false, -- keep the line border (not a solid block frame)
				},

				custom_highlights = function(C)
					return {
						LineNr = { fg = C.overlay0 },
						CursorLineNr = { fg = C.lavender, bold = true },
						NeoTreeDimText = { fg = C.overlay0 },
						NeoTreeMessage = { fg = C.overlay0 },
						IblIndent = { fg = C.surface1 },
						IblScope = { fg = C.overlay0 },
					}
				end,

				integrations = {
					noice = true,
					notify = true,
					gitsigns = true,
					telescope = { enabled = true },
					which_key = true,
					todo_comments = true,
					neotree = true,
				},
			})

			vim.opt.background = "dark"
			vim.cmd.colorscheme("catppuccin")
		end,
	},
}
