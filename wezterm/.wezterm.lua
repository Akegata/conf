local defaults = require("defaults")
local keybindings = require("keybindings")
local config = {}
defaults.apply_to_config(config)
keybindings.apply_to_config(config)
config.color_scheme = "Catppuccin Mocha"
return config
