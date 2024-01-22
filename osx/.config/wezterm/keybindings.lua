local wezterm = require("wezterm")
local module = {}

function module.apply_to_config(config)
	local act = wezterm.action

	config.keys = {
		{
			key = "F6",
			mods = "SHIFT",
			action = act.SendString("therewasgreat"),
		},
		{
			key = "f",
			mods = "CMD",
			action = wezterm.action.ToggleFullScreen,
		},
	}
end

return module
