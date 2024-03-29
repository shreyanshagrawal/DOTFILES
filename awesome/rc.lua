-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local lain = require("lain")
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
local dpi   = require("beautiful.xresources").apply_dpi
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
local themes = {
    "blackburn",       -- 1
    "copland",         -- 2
    "dremora",         -- 3
    "holo",            -- 4
    "multicolor",      -- 5
    "powerarrow",      -- 6
    "powerarrow-dark", -- 7
    "rainbow",         -- 8
    "steamburn",       -- 9
    "vertex"           -- 10
}

local chosen_theme = themes[5]
local modkey       = "Mod4"
local altkey       = "Mod1"
local terminal     = "urxvtc"
local vi_focus     = false -- vi-like client focus https://github.com/lcpz/awesome-copycats/issues/275
local cycle_prev   = true  -- cycle with only the previously focused client or all https://github.com/lcpz/awesome-copycats/issues/274
local editor       = os.getenv("EDITOR") or "nvim"
local browser      = "librewolf"
-- Themes define colours, icons, font and wallpapers.
beautiful.init(string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), chosen_theme))

-- This is used later as the default terminal and editor to run.
terminal = "alacritty"
editor = os.getenv("nvim") or "nano"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
local modkey1 = "Mod1"
local ctrlkey = "Control"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    --awful.layout.suit.tile.left,
    --awful.layout.suit.tile.bottom,
    --awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    --awful.layout.suit.fair.horizontal,
    --awful.layout.suit.spiral,
    --awful.layout.suit.spiral.dwindle,
    --awful.layout.suit.max,
    --awful.layout.suit.max.fullscreen,
    --awful.layout.suit.magnifier,
    --awful.layout.suit.corner.nw,
    --awful.layout.suit.floating,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}
local markup = lain.util.markup

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock(markup("#7788af", "%A %d %B ") .. markup("#ab7367", ">") .. markup("#de5e1e", " %H:%M "))

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

--ICONS--

local HOME = os.getenv("HOME")
local icons = {}

icons.widget_temp                               = HOME.."/.config/awesome/themes/multicolor/icons/temp.png"
icons.widget_uptime                             = HOME.."/.config/awesome/themes/multicolor/icons/ac.png"
icons.widget_cpu                                = HOME.."/.config/awesome/themes/multicolor/icons/cpu.png"
icons.widget_weather                            = HOME.."/.config/awesome/themes/multicolor/icons/dish.png"
icons.widget_fs                                 = HOME.."/.config/awesome/themes/multicolor/icons/fs.png"
icons.widget_mem                                = HOME.."/.config/awesome/themes/multicolor/icons/mem.png"
icons.widget_note                               = HOME.."/.config/awesome/themes/multicolor/icons/note.png"
icons.widget_note_on                            = HOME.."/.config/awesome/themes/multicolor/icons/note_on.png"
icons.widget_netdown                            = HOME.."/.config/awesome/themes/multicolor/icons/net_down.png"
icons.widget_netup                              = HOME.."/.config/awesome/themes/multicolor/icons/net_up.png"
icons.widget_mail                               = HOME.."/.config/awesome/themes/multicolor/icons/mail.png"
icons.widget_batt                               = HOME.."/.config/awesome/themes/multicolor/icons/bat.png"
icons.widget_clock                              = HOME.."/.config/awesome/themes/multicolor/icons/clock.png"
icons.widget_vol                                = HOME.."/.config/awesome/themes/multicolor/icons/spkr.png"
icons.taglist_squares_sel                       = HOME.."/.config/awesome/themes/multicolor/icons/square_a.png"
icons.layout_tile                               = HOME.."/.config/awesome/themes/multicolor/icons/tile.png"
icons.layout_tilegaps                           = HOME.."/.config/awesome/themes/multicolor/icons/tilegaps.png"
icons.layout_tileleft                           = HOME.."/.config/awesome/themes/multicolor/icons/tileleft.png"
icons.layout_tilebottom                         = HOME.."/.config/awesome/themes/multicolor/icons/tilebottom.png"
icons.layout_tiletop                            = HOME.."/.config/awesome/themes/multicolor/icons/tiletop.png"
icons.layout_fairv                              = HOME.."/.config/awesome/themes/multicolor/icons/fairv.png"
icons.layout_fairh                              = HOME.."/.config/awesome/themes/multicolor/icons/fairh.png"
icons.layout_spiral                             = HOME.."/.config/awesome/themes/multicolor/icons/spiral.png"
icons.layout_dwindle                            = HOME.."/.config/awesome/themes/multicolor/icons/dwindle.png"
icons.layout_max                                = HOME.."/.config/awesome/themes/multicolor/icons/max.png"
icons.layout_fullscreen                         = HOME.."/.config/awesome/themes/multicolor/icons/fullscreen.png"
icons.layout_magnifier                          = HOME.."/.config/awesome/themes/multicolor/icons/magnifier.png"
icons.layout_floating                           = HOME.."/.config/awesome/themes/multicolor/icons/floating.png"
icons.titlebar_close_button_normal              = HOME.."/.config/awesome/themes/multicolor/icons/titlebar/close_normal.png"
icons.titlebar_close_button_focus               = HOME.."/.config/awesome/themes/multicolor/icons/titlebar/close_focus.png"
icons.titlebar_minimize_button_normal           = HOME.."/.config/awesome/themes/multicolor/icons/titlebar/minimize_normal.png"
icons.titlebar_minimize_button_focus            = HOME.."/.config/awesome/themes/multicolor/icons/titlebar/minimize_focus.png"
icons.titlebar_ontop_button_normal_inactive     = HOME.."/.config/awesome/themes/multicolor/icons/titlebar/ontop_normal_inactive.png"
icons.titlebar_ontop_button_focus_inactive      = HOME.."/.config/awesome/themes/multicolor/icons/titlebar/ontop_focus_inactive.png"
icons.titlebar_ontop_button_normal_active       = HOME.."/.config/awesome/themes/multicolor/icons/titlebar/ontop_normal_active.png"
icons.titlebar_ontop_button_focus_active        = HOME.."/.config/awesome/themes/multicolor/icons/titlebar/ontop_focus_active.png"
icons.titlebar_sticky_button_normal_inactive    = HOME.."/.config/awesome/themes/multicolor/icons/titlebar/sticky_normal_inactive.png"
icons.titlebar_sticky_button_focus_inactive     = HOME.."/.config/awesome/themes/multicolor/icons/titlebar/sticky_focus_inactive.png"
icons.titlebar_sticky_button_normal_active      = HOME.."/.config/awesome/themes/multicolor/icons/titlebar/sticky_normal_active.png"
icons.titlebar_sticky_button_focus_active       = HOME.."/.config/awesome/themes/multicolor/icons/titlebar/sticky_focus_active.png"
icons.titlebar_floating_button_normal_inactive  = HOME.."/.config/awesome/themes/multicolor/icons/titlebar/floating_normal_inactive.png"
icons.titlebar_floating_button_focus_inactive   = HOME.."/.config/awesome/themes/multicolor/icons/titlebar/floating_focus_inactive.png"
icons.titlebar_floating_button_normal_active    = HOME.."/.config/awesome/themes/multicolor/icons/titlebar/floating_normal_active.png"
icons.titlebar_floating_button_focus_active     = HOME.."/.config/awesome/themes/multicolor/icons/titlebar/floating_focus_active.png"
icons.titlebar_maximized_button_normal_inactive = HOME.."/.config/awesome/themes/multicolor/icons/titlebar/maximized_normal_inactive.png"
icons.titlebar_maximized_button_focus_inactive  = HOME.."/.config/awesome/themes/multicolor/icons/titlebar/maximized_focus_inactive.png"
icons.titlebar_maximized_button_normal_active   = HOME.."/.config/awesome/themes/multicolor/icons/titlebar/maximized_normal_active.png"
icons.titlebar_maximized_button_focus_active    = HOME.."/.config/awesome/themes/multicolor/icons/titlebar/maximized_focus_active.png"
icons.taglist_squares_unsel                     = HOME.."/.config/awesome/themes/multicolor/icons/square_b.png"
icons.font                                      = "Terminus 8"
icons.fg_normal                                 = "#aaffff"

--WIDGET--

local cpuicon = wibox.widget.imagebox(icons.widget_cpu)
local cpu = lain.widget.cpu({
    settings = function()
        widget:set_markup(markup.fontfg(icons.font, "#e33a6e", cpu_now.usage .. "% "))
    end
})

-- Coretemp
local tempicon = wibox.widget.imagebox(icons.widget_temp)
local temp = lain.widget.temp({
    settings = function()
        widget:set_markup(markup.fontfg(icons.font, "#f1af5f", coretemp_now .. "°C "))
    end
})

-- Battery
local baticon = wibox.widget.imagebox(icons.widget_batt)
local bat = lain.widget.bat({
    settings = function()
        local perc = bat_now.perc ~= "N/A" and bat_now.perc .. "%" or bat_now.perc

        if bat_now.ac_status == 1 then
            perc = perc .. " plug"
        end

        widget:set_markup(markup.fontfg(icons.font, icons.fg_normal, perc .. " "))
    end
})

-- ALSA volume
local volicon = wibox.widget.imagebox(icons.widget_vol)
local volume = lain.widget.alsa({
    settings = function()
        if volume_now.status == "off" then
            volume_now.level = volume_now.level .. "M"
        end

        widget:set_markup(markup.fontfg(icons.font, "#7493d2", volume_now.level .. "% "))
    end
})

-- Net
local netdownicon = wibox.widget.imagebox(icons.widget_netdown)
local netdowninfo = wibox.widget.textbox()
local netupicon = wibox.widget.imagebox(icons.widget_netup)
local netupinfo = lain.widget.net({
    settings = function()
        --[[ uncomment if using the weather widget
        if iface ~= "network off" and
           string.match(theme.weather.widget.text, "N/A")
        then
            theme.weather.update()
        end
        --]]

        widget:set_markup(markup.fontfg(icons.font, "#e54c62", net_now.sent .. " "))
        netdowninfo:set_markup(markup.fontfg(icons.font, "#87af5f", net_now.received .. " "))
    end
})

-- MEM
local memicon = wibox.widget.imagebox(icons.widget_mem)
local memory = lain.widget.mem({
    settings = function()
        widget:set_markup(markup.fontfg(icons.font, "#e0da37", mem_now.used .. "M "))
    end
})

-- MPD
local mpdicon = wibox.widget.imagebox()
local mpd = lain.widget.mpd({
    settings = function()
        mpd_notification_preset = {
            text = string.format("%s [%s] - %s\n%s", mpd_now.artist,
                   mpd_now.album, mpd_now.date, mpd_now.title)
        }

        if mpd_now.state == "play" then
            artist = mpd_now.artist .. " > "
            title  = mpd_now.title .. " "
            mpdicon:set_image(icons.widget_note_on)
        elseif mpd_now.state == "pause" then
            artist = "mpd "
            title  = "paused "
        else
            artist = ""
            title  = ""
            --mpdicon:set_image() -- not working in 4.0
            mpdicon._private.image = nil
            mpdicon:emit_signal("widget::redraw_needed")
            mpdicon:emit_signal("widget::layout_changed")
        end
        widget:set_markup(markup.fontfg(icons.font, "#e54c62", artist) .. markup.fontfg(icons.font, "#b2b2b2", title))
    end
})

--spotify

local spotify_widget = require("awesome-wm-widgets.spotify-widget.spotify")



local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons
    }

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup {
       layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist,
            s.mypromptbox,
        },
        { -- middle widget
            layout = wibox.layout.flex.horizontal,

        }, 
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            
            spotify_widget({
                font = 'Ubuntu Mono 9',
                play_icon = '/usr/share/icons/Papirus-Light/24x24/categories/spotify.svg',
                pause_icon = '/usr/share/icons/Papirus-Dark/24x24/panel/spotify-indicator.svg',
                dim_when_paused = true,
                dim_opacity = 0.5,
                max_length = -1,
                show_tooltip = false
            }),
            baticon,
            bat.widget,
            volicon,
            volume.widget,
            memicon,
            memory.widget,
            tempicon,
            temp.widget,
            cpuicon,
            cpu.widget,
            mytextclock,
        },
    }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

globalkeys = gears.table.join(
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey1,           }, "Tab",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Prompt
    awful.key({ modkey },            "r",     function () awful.util.spawn("rofi -show-icons -show") end,
              {description = "run rofi", group = "launcher"}),
-- google
    awful.key({ modkey },            "c",     function () awful.util.spawn("google-chrome-stable") end,
              {description = "google", group = "launcher"}),
--discord
    awful.key({ modkey },            "d",     function () awful.util.spawn("discord") end,
              {description = "discord", group = "launcher"}),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"}),
-- nitrogen
    awful.key({ modkey }, "w", function() awful.util.spawn("nitrogen") end,
              {description = "nitrogen", group = "launcher"}),
--filemanager
    awful.key({ modkey1 }, "f", function() awful.util.spawn("thunar") end,
              {description = "filemanager", group = "launcher"}),
--spotify
    awful.key({ ctrlkey }, "m", function() awful.util.spawn("spotify ") end,
              {description = "spotify", group = "launcher"}),
--trayer
    awful.key({ modkey },            "t",     function () awful.util.spawn("trayer") end,
              {description = "trayer", group = "launcher"}),
--audiobook
    awful.key({ modkey },            "a",     function () awful.util.spawn("alacritty  --class book,books -e ranger /media/SlowStorage/Audiobooks/") end,
              {description = "audiobook", group = "launcher"}),
--torrent
    awful.key({ modkey }, "q", function() awful.util.spawn("qbittorrent") end,
              {description = "torrent", group = "launcher"}),
--screenshot custom
    awful.key({ ctrlkey },            "Print",     function () awful.util.spawn("flameshot gui") end,
              {description = "printscreen", group = "launcher"}),
--books
    awful.key({ modkey },            "b",     function () awful.util.spawn("calibre") end,
              {description = "book", group = "launcher"}),
--screenshot fullscreen
    awful.key({},            "Print",     function () awful.util.spawn("flameshot screen -c") end,
              {description = "coustom printscreen", group = "launcher"})
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey1,    }, "F4",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
              -- books
              awful.key({modkey1},  "b",
                  function ()
                        local screen = awful.screen.focused()
                        local books = screen.tags[6]
                        if books then
                           books:view_only()
                        end
                  end,
                  {description = "toggle to screen 6 books", group = "tag"}),
              awful.key({modkey1},  "g",
                  function ()
                        local screen = awful.screen.focused()
                        local books = screen.tags[2]
                        if books then
                           books:view_only()
                        end
                  end,
                  {description = "toggle to screen 2 google", group = "tag"}),
              awful.key({modkey1},  "d",
                  function ()
                        local screen = awful.screen.focused()
                        local books = screen.tags[3]
                        if books then
                           books:view_only()
                        end
                  end,
                  {description = "toggle to screen 3 discord", group = "tag"}),
              awful.key({modkey1},  "m",
                  function ()
                        local screen = awful.screen.focused()
                        local books = screen.tags[4]
                        if books then
                           books:view_only()
                        end
                  end,
                  {description = "toggle to screen 4 media", group = "tag"}),
              awful.key({modkey1},  "s",
                  function ()
                        local screen = awful.screen.focused()
                        local books = screen.tags[5]
                        if books then
                           books:view_only()
                        end
                  end,
                  {description = "toggle to screen 5 spotify", group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},
    {rule = { instance="discord" },
    properties = {tag = "3"}},
    {rule = { class="Spotify" },
    properties = {tag = "5"}},
    {rule = { instance="google-chrome" },
    properties = {tag = "2"}},
    {rule = { class="books" },
    properties = {tag = "6"}},
    {rule = { instance="calibre-gui" },
    properties = {tag = "6"}},
    {rule = { class="qBittorrent" },
    properties = {tag = "9"}},
    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    if not awesome.startup then awful.client.setslave(c) end

        if awesome.startup
          and not c.size_hints.user_position
          and not c.size_hints.program_position then
--         Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)



beautiful.border_focus = "#ffa0a0"
client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
awful.spawn.with_shell("~/.config/awesome/autostart.sh")
--gaps
beautiful.useless_gap = 5
