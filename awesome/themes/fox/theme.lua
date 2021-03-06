---------------
-- Fox theme --
---------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gc = require("gears.color")
local gfs = require("gears.filesystem")
local themes_path = gfs.get_configuration_dir() .. "themes/fox/"

local theme = {}

theme.font = "JetBrainsMono Nerd Font 12"

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

theme.none = "#00000000"

theme.bg_normal = "#0d1009"
theme.bg_focus = "#1d1d15"
theme.bg_dark = "#132205"
theme.bg_urgent = "#0e1c0a"
theme.bg_minimize = "#0e1c0a"
theme.bg_systray = theme.bg_normal

theme.fg_normal = "#ddc5ab"
theme.fg_focus = "#ddc5ab"
theme.fg_urgent = "#b85970"
theme.fg_minimize = "#ddc5ab"
theme.fg_dark = "#bb7432"

theme.useless_gap = dpi(8)
theme.border_width = dpi(6)
theme.border_normal = theme.bg_normal
theme.border_focus = theme.fg_urgent
theme.border_marked = theme.fg_urgent

-- Titlebar buttons
theme.titlebar_button_padding_horizontal = dpi(16)
theme.titlebar_button_padding_vertical = dpi(8)
theme.titlebar_button_color = theme.fg_normal

-- Generate taglist squares:
local taglist_square_size = dpi(4)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]
theme.notification_font = "JetBrainsMono Nerd Font 16"
--
-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = themes_path.."submenu.png"
theme.menu_height = dpi(15)
theme.menu_width  = dpi(100)

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

theme.titlebar_close_button_normal = gc.recolor_image(themes_path.."/titlebar/close_normal.svg", theme.titlebar_button_color)

theme.wallpaper = themes_path.."wallpaper.jpg"

theme.layout_floating = gc.recolor_image(themes_path.."/layouts/floatingw.png", theme.fg_normal)
theme.layout_tile = gc.recolor_image(themes_path.."/layouts/tilew.png", theme.fg_normal)

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
