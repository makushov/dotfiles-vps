return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- file icons
			"MunifTanjim/nui.nvim",
		},
		keys = {
			{ "<leader>e", "<cmd>Neotree toggle<cr>", desc = "File Explorer" },
		},
		opts = {
			filesystem = {
				filtered_items = {
					hide_dotfiles = false, -- show hidden files like .claude, .gitignore
					-- visible = true,
				},
			},
			default_component_configs = {
				indent = {
					with_expanders = true,
					expander_collapsed = "→",
					expander_expanded = "↓",
					expander_highlight = "NeoTreeExpander",
				},
			},
			diagnostics = {
				symbols = {
					error = " ",
					warn = " ",
					info = " ",
					hint = "󰌵 ",
				},
			},
		},
		config = function(_, opts)
			require("neo-tree").setup(opts)
		end,
	},
}
