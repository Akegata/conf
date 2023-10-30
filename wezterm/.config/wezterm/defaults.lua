-- Pull in the wezterm API
local wezterm = require("wezterm")
local hostname = wezterm.hostname()

-- This table will hold the configuration.
local module = {}
local font_size

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
-- config.color_scheme = "AdventureTime"
-- function that accepts the config object, like this:
function module.apply_to_config(config)
	--	config.font_size = 20
	config.use_fancy_tab_bar = true
	config.hide_tab_bar_if_only_one_tab = true
	config.window_decorations = "RESIZE"
	if hostname == "ws-vm" then
		-- Use a bigger font on the smaller screen of my PixelBook Go
		config.font_size = 14.0
	else
		config.font_size = 14.0
	end

	return {
		font_size = font_size,
	}
end

-- and finally, return the configuration to wezterm
return module
