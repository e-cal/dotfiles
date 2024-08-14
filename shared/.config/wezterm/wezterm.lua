local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.enable_wayland = false

config.default_prog = { "zsh", "-c", "tm startup; zsh" }
config.window_close_confirmation = 'NeverPrompt'

local act = wezterm.action
config.keys = {
	{
		key = "Escape",
		mods = "NONE",
		action = wezterm.action_callback(function(window, pane)
			local has_selection = window:get_selection_text_for_pane(pane) ~= ""
			if has_selection then
				window:perform_action(act.CopyTo("ClipboardAndPrimarySelection"), pane)

				window:perform_action(act.ClearSelection, pane)
			else
				window:perform_action(act.SendKey({ key = "Escape", mods = "NONE" }), pane)
			end
		end),
	},
}

config.default_cursor_style = 'SteadyBlock'
config.cursor_blink_rate = 0

config.color_scheme = "Catppuccin Mocha"
config.font = wezterm.font_with_fallback({
	{
		family = "JetBrainsMono NF",
		-- weight = "DemiBold",
		weight = "Medium",
		harfbuzz_features = { "zero" },
	},
	"Noto Color Emoji",
})
config.freetype_load_flags = 'NO_HINTING'
config.font_size = 11.0
config.line_height = 1.0
config.cell_width = 1.0

config.enable_tab_bar = false
config.window_padding = {
	left = 3,
	right = 3,
	top = 0,
	bottom = 0,
}

return config
