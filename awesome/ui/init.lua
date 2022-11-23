local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local lain = require("lain")
local wibox = require("wibox")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local theme = beautiful.get()

-- Create a spacer widget
w_spacer = wibox.widget.textbox(" ")
w_line_spacer = wibox.widget.textbox(lain.util.markup.font("Tamzen 3", " ") .. lain.util.markup.fontfg(theme.font, "#777777", "|") .. lain.util.markup.font("Tamzen 3", " "))

-- Create a textclock widget
w_textclock = wibox.widget.textclock("%l:%M %P")

-- Create a battery widget
w_battery_icon = wibox.widget.imagebox(theme.bat)
local batbar = wibox.widget {
    forced_height    = dpi(1),
    forced_width     = dpi(59),
    color            = theme.fg_normal,
    background_color = theme.bg_normal,
    margins          = 1,
    paddings         = 1,
    ticks            = true,
    ticks_size       = dpi(6),
    widget           = wibox.widget.progressbar,
}
local batupd = lain.widget.bat({
    battery = "BAT0",
    settings = function()
        if (not bat_now.status) or bat_now.status == "N/A" or type(bat_now.perc) ~= "number" then return end

        if bat_now.status == "Charging" then
            w_battery_icon:set_image(theme.ac)
            if bat_now.perc >= 98 then
                batbar:set_color(theme.fg_normal)
            elseif bat_now.perc > 50 then
                batbar:set_color(theme.fg_normal)
            elseif bat_now.perc > 15 then
                batbar:set_color(theme.fg_normal)
            else
                batbar:set_color(theme.bg_urgent)
            end
        else
            if bat_now.perc >= 98 then
                batbar:set_color(theme.fg_normal)
            elseif bat_now.perc > 50 then
                batbar:set_color(theme.fg_normal)
                w_battery_icon:set_image(theme.bat)
            elseif bat_now.perc > 15 then
                batbar:set_color(theme.fg_normal)
                w_battery_icon:set_image(theme.bat_low)
            else
                batbar:set_color(theme.bg_urgent)
                w_battery_icon:set_image(theme.bat_no)
            end
        end
        batbar:set_value(bat_now.perc / 100)
    end
})
local batbg = wibox.container.background(batbar, "#474747", gears.shape.rectangle)
w_battery = wibox.container.margin(batbg, dpi(2), dpi(7), dpi(4), dpi(4))

-- Create a volume widget
local w_volume_icon = wibox.widget.imagebox(theme.vol)
local volume = lain.widget.alsabar {
    width = dpi(59), border_width = 0, ticks = true, ticks_size = dpi(6),
    notification_preset = { font = theme.font },
    settings = function()
        if volume_now.status == "off" then
            w_volume_icon:set_image(theme.vol_mute)
        elseif volume_now.level == 0 then
            voliw_volume_iconcon:set_image(theme.vol_no)
        elseif volume_now.level <= 50 then
            w_volume_icon:set_image(theme.vol_low)
        else
            w_volume_icon:set_image(theme.vol)
        end
    end,
    colors = {
        background   = theme.bg_normal,
        mute         = theme.bg_urgent,
        unmute       = theme.fg_normal
    }
}
volume.tooltip.wibox.fg = theme.fg_focus
local volumebg = wibox.container.background(volume.bar, "#474747", gears.shape.rectangle)
w_volume = wibox.container.margin(volumebg, dpi(2), dpi(7), dpi(4), dpi(4))

-- Create a system tray widget
w_systray = wibox.layout.margin(wibox.widget.systray(), 0, 0, 3, 3)

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewprev(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewnext(t.screen) end)
                )

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  c:emit_signal(
                                                      "request::activate",
                                                      "tasklist",
                                                      {raise = true}
                                                  )
                                              end
                                          end),
                     awful.button({ }, 3, function()
                                              awful.menu.client_list({ theme = { width = 250 } })
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.w_layoutbox = wibox.layout.margin(awful.widget.layoutbox(s), 2, 2, 2, 2)
    s.w_layoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))

    -- Create a taglist widget
    s.w_taglist = wibox.container.background(awful.widget.taglist {
        screen = s,
        filter = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
        bg = beautiful.bg_normal
    }, beautiful.bg_normal)

    -- Create a tasklist widget
    s.w_tasklist = awful.widget.tasklist {
        screen   = s,
        filter   = awful.widget.tasklist.filter.currenttags,
        buttons  = tasklist_buttons,
        widget_template = {
            {
                {
                    {
                        {
                            id = 'icon_role',
                            widget = wibox.widget.imagebox,
                        },
                        margins = 2,
                        widget = wibox.container.margin,
                    },
                    {
                        id = 'text_role',
                        widget = wibox.widget.textbox,
                    },
                    layout = wibox.layout.fixed.horizontal,
                },
                left = 0,
                right = 8,
                widget = wibox.container.margin
            },
            id = 'background_role',
            widget = wibox.container.background,
        },
    }

    -- Create the bar
    s.bar = awful.wibar({
        position = "top",
        screen = s,
        --height = dpi(32),
        height = dpi(18),
    })

    -- Add widgets to the bar
    s.bar:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.w_layoutbox,
            s.w_taglist,
            s.w_tasklist,
        },
        {
            layout = wibox.layout.align.horizontal { visible = false },
            wibox.widget.separator({ visible = false }),
        },
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            w_systray,
            w_line_spacer,
            w_volume_icon,
            w_volume,
            w_line_spacer,
            w_battery_icon,
            w_battery,
            w_line_spacer,
            w_textclock,
            w_spacer,
        },
    }
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    local function padded_button(widget)
        return wibox.container.margin(
            widget,
            beautiful.titlebar_button_padding_horizontal,
            beautiful.titlebar_button_padding_horizontal,
            beautiful.titlebar_button_padding_vertical,
            beautiful.titlebar_button_padding_vertical
        )
    end
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c, {
        size = 32
    }) : setup {
        {
            -- Button
            padded_button(awful.titlebar.widget.closebutton(c)),
            layout = wibox.layout.fixed.horizontal
        },
        {
            { -- Title
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        layout = wibox.layout.fixed.horizontal
    }
end)
