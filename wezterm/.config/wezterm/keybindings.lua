local wezterm = require("wezterm")
local module = {}

function module.apply_to_config(config)
	local act = wezterm.action

	config.keys = {
		{
			key = "F8",
			mods = "SHIFT",
			action = act.SendString("Shiftf10"),
		},
		{
			key = "F9",
			mods = "SHIFT",
			action = act.SendString("Shiftf9"),
		},
	}
end

return module
