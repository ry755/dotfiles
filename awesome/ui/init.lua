local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local net_widgets = require("net_widgets")
local wibox = require("wibox")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

-- Create a spacer widget
w_spacer = wibox.container.background(wibox.widget.textbox(" "), beautiful.bg_normal)

-- Create a net_widgets widget
w_net = wibox.container.background(net_widgets.wireless({
    interface = "wlan0",
    popup_signal = true
}), beautiful.bg_normal)

-- Create a textclock widget
w_textclock = wibox.container.background(wibox.widget.textclock(" %a %b %d, %l:%M %P "), beautiful.bg_normal)

-- Create a battery widget
w_battery = wibox.container.background(awful.widget.watch('bash -c "~/.config/awesome/bin/status bat"', 30), beautiful.bg_normal)

-- Create a volume widget
w_volume = wibox.container.background(awful.widget.watch('bash -c "~/.config/awesome/bin/status vol"', 5), beautiful.bg_normal)

-- Create a system tray widget
w_systray = wibox.container.background(wibox.widget.systray(), beautiful.bg_normal)

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
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
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
    s.w_layoutbox = wibox.container.background(awful.widget.layoutbox(s), beautiful.bg_normal)
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

    -- Create the left bar
    s.bar = awful.wibar({
        position = "top",
        screen = s,
        width = dpi(1888), -- 1920 - (16 * 2)
        height = dpi(32),
        bg = "#00000000"
    })
    s.bar.x = dpi(16)
    s.bar.y = dpi(16)
    s.bar:struts { top = dpi(48) }

    -- Add widgets to the bar
    s.bar:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.w_taglist,
        },
        {
            layout = wibox.layout.align.horizontal { visible = false },
            wibox.widget.separator({ visible = false }),
        },
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            w_systray,
            w_spacer,
            w_net,
            w_spacer,
            w_volume,
            w_spacer,
            w_battery,
            w_textclock,
            s.w_layoutbox,
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

