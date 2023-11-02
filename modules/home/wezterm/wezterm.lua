local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.enable_wayland = false

config.font = wezterm.font 'FiraCode Nerd Font'
config.color_scheme = 'Catppuccin Macchiato'

return config