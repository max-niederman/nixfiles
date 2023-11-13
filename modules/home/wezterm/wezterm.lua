local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.default_prog = { "/run/current-system/sw/bin/nu" }

config.enable_wayland = false

config.hide_tab_bar_if_only_one_tab = true

config.font = wezterm.font 'FiraCode Nerd Font'
config.color_scheme = 'Catppuccin Macchiato'

return config