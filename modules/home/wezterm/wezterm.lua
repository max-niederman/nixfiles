local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.font = wezterm.font 'FiraCode Nerd Font'
config.color_scheme = 'GruvboxDarkHard'

return config