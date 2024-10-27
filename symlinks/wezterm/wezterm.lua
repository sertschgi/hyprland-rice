-- [[ Settings ]] --
local PADDING = 9
local FONT = "JetBrainsMono Nerd Font"
local FONT_SIZE = 16
local WINDOW_OPACITY = 0.92
local SHELL = "bash"
--------------------

local wezterm = require("wezterm")
local colors = require("colors")

local config = {}

config.default_prog = { SHELL }

colors.apply(config)

config.disable_default_key_bindings = false -- DISABLE DEFAULT KEYBINDINGS THAT COME WITH WEZTERM
config.use_dead_keys = false

config.window_padding = {
    left = PADDING,
    right = PADDING,
    top = PADDING,
    bottom = PADDING,
}

config.key_tables = {
    resize_pane = {
        { key = 'Escape', action = 'PopKeyTable' },

        { key = 'LeftArrow', action = wezterm.action.AdjustPaneSize { 'Left', 1 } },
        { key = 'h', action = wezterm.action.AdjustPaneSize { 'Left', 1 } },

        { key = 'RightArrow', action = wezterm.action.AdjustPaneSize { 'Right', 1 } },
        { key = 'l', action = wezterm.action.AdjustPaneSize { 'Right', 1 } },

        { key = 'UpArrow', action = wezterm.action.AdjustPaneSize { 'Up', 1 } },
        { key = 'k', action = wezterm.action.AdjustPaneSize { 'Up', 1 } },

        { key = 'DownArrow', action = wezterm.action.AdjustPaneSize { 'Down', 1 } },
        { key = 'j', action = wezterm.action.AdjustPaneSize { 'Down', 1 } },
    },
    activate_pane = {
        { key = 'Escape', action = 'PopKeyTable' },

        { key = 'LeftArrow', action = wezterm.action.ActivatePaneDirection('Left') },
        { key = 'h', action = wezterm.action.ActivatePaneDirection('Left') },

        { key = 'RightArrow', action = wezterm.action.ActivatePaneDirection('Right') },
        { key = 'l', action = wezterm.action.ActivatePaneDirection('Right') },

        { key = 'UpArrow', action = wezterm.action.ActivatePaneDirection('Up') },
        { key = 'k', action = wezterm.action.ActivatePaneDirection('Up') },

        { key = 'DownArrow', action = wezterm.action.ActivatePaneDirection('Down') },
        { key = 'j', action = wezterm.action.ActivatePaneDirection('Down') },
    },
}

config.keys = {
    {
        key = '\\',
        mods = 'CTRL|ALT',
        action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
    },
    {
        key = '-',
        mods = 'CTRL|ALT',
        action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
    },
    {
        key = 'r',
        mods = 'CTRL|ALT',
        action = wezterm.action.ActivateKeyTable {
            name = 'resize_pane',
            one_shot = false,
        },
    },
    {
        key = 'a',
        mods = 'CTRL|ALT',
        action = wezterm.action.ActivateKeyTable {
            name = 'activate_pane',
            one_shot = false,
        },
    },
}

config.window_background_opacity = WINDOW_OPACITY

config.enable_tab_bar = false

config.font = wezterm.font(FONT)
config.font_size = FONT_SIZE

return config
