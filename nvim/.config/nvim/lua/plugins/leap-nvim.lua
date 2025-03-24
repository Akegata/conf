return {
	-- add symbols-outline
	-- lazy.nvim
	{
		"ggandor/leap.nvim",
		keys = {
			{ "s", mode = { "n", "x", "o" }, "<Plug>(leap-forward)", desc = "Leap  orward" },
			{ "S", mode = { "n", "x", "o" }, "<Plug>(leap-backward)", desc = "Leap backward" },
		},
		config = function()
			require("leap").opts.safe_labels = {}
			-- You might also want to add the basic setup if it's not already done elsewhere
			require("leap").add_default_mappings()
		end,
	},
}
