return {
	{
		"mbbill/undotree",
		lazy = true,
		keys = {
			{
				"<leader>u",
				function()
					vim.cmd.UndotreeToggle()
				end,
				desc = "Show nvim undotree",
			},
			config = true,
		},
	},
}
