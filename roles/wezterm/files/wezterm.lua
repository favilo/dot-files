local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.keys = {
  {
    key = "r",
    mods = "CTRL|SHIFT",
    action = wezterm.action.ReloadConfiguration,
  },
}
config.enable_kitty_keyboard = true
config.enable_tab_bar = false
config.adjust_window_size_when_changing_font_size = false
config.scrollback_lines = 50000

return config
