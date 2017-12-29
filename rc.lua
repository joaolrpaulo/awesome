
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget
local common = require("awful.widget.common")
local cyclefocus = require('extras/cyclefocus')
local volume_control = require("extras/volume-control")

require("awful.autofocus")
require("awful.hotkeys_popup.keys")

-- Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors
    })
end

-- Handle runtime errors after startup
do
    local in_error = false

    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        
        in_error = true

        naughty.notify({
            preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err)
        })
        
        in_error = false
    end )
end

-- Theming
beautiful.init(awful.util.getdir("config") .. "/themes/joaopaulo/theme.lua")

-- Envoriment variables
terminal = "terminator"
editor = os.getenv("EDITOR") or "code"
editor_cmd = terminal .. " -e " .. editor

-- Default mod key - Windows
modkey = "Mod4"

-- Layouts available
awful.layout.layouts = {
    awful.layout.suit.fair
}

-- Helper functions
local function client_menu_toggle_fn()
    local instance = nil

    return function ()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ theme = { width = 250 } })
        end
    end
end

local function list_update(w, buttons, label, data, objects)
    common.list_update(w, buttons, label, data, objects)
    w:set_max_widget_size(300)
end

-- Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
    { "hotkeys", function () return false, hotkeys_popup.show_help end }, 
    { "manual", terminal .. " -x man awesome" },
    { "edit config", editor_cmd .. " " .. awesome.conffile },
    { "restart", awesome.restart },
    { "quit", function() awesome.quit() end }
}
 
mymainmenu = awful.menu({
    items = {
        { "awesome", myawesomemenu, beautiful.awesome_icon },
        { "open terminal", terminal }
    }
})

-- Menubar configuration
menubar.utils.terminal = terminal
menubar.icon_theme_name = "Numix Square"

-- Keyboard Layout
mykeyboardlayout = awful.widget.keyboardlayout()

-- Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()
volumecfg = volume_control({ tooltip = true })

-- Create a wibox for each screen and add it
local taglist_buttons =
    gears.table.join(
        awful.button(
            { }, 1,
            function(t) t:view_only() end
        ),

        awful.button(
            { modkey },
            1,
            function(t)
                if client.focus then
                    client.focus:move_to_tag(t)
                end
            end
        ),

        awful.button(
            { },
            3,
            awful.tag.viewtoggle
        ),

        awful.button(
            { modkey }, 
            3, 
            function(t)
                if client.focus then
                    client.focus:toggle_tag(t)
                end
            end
        ),

        awful.button(
            { }, 4,
            
            function(t) awful.tag.viewnext(t.screen) end
        ),

        awful.button(
            { }, 5,
            function(t) awful.tag.viewprev(t.screen) end
        )
    )

local tasklist_buttons = gears.table.join(
    awful.button(
        { },
        1,
        function (c)
            if c == client.focus then
                c.minimized = true
            else
                -- Without this, the following
                -- :isvisible() makes no sense
                c.minimized = false
                
                if not c:isvisible() and c.first_tag then
                    c.first_tag:view_only()
                end

                -- This will also un-minimize
                -- the client, if needed
                client.focus = c
                c:raise()
            end
        end
    ),

    awful.button(
        { }, 3,
        
        client_menu_toggle_fn()
    ),

    awful.button(
        { }, 4,
        
        function () awful.client.focus.byidx(1) end
    ),
    awful.button(
        { }, 5,
        
        function () awful.client.focus.byidx(-1) end
    )
)

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

awful.screen.connect_for_each_screen(
    function(s)
        local left_layout   = wibox.layout.fixed.horizontal()
        local center_layout = wibox.layout.fixed.horizontal()
        local right_layout  = wibox.layout.fixed.horizontal()
        local layout        = wibox.layout.align.horizontal()
        local systray       = wibox.layout.margin(wibox.widget.systray(), 3, 3, 3, 3)

        -- Wallpaper
        set_wallpaper(s)

        -- Each screen has its own tag table.                            
        if screen.count() == 1 then
            awful.tag({ "IntelliJ", "Web", "Terminal", "HipChat", "Telegram", "Spotify", "Aux", "Aux", "Aux" }, s, awful.layout.layouts[1])
        
        elseif screen.count() == 2 then
            if s.index == 1 then
                awful.tag({ "IntelliJ", "Web", "Spotify" }, s, awful.layout.layouts[1])
            elseif s.index == 2 then
                awful.tag({ "Terminal", "HipChat", "Telegram" }, s, awful.layout.layouts[1])
            end
        
        elseif screen.count() == 3 then
            -- Each screen has its own tag table.            
            if s.index == 1 then
                awful.tag({ "IntelliJ", "Code", "Aux" }, s, awful.layout.layouts[1])
            elseif s.index == 2 then
                awful.tag({ "Terminal", "HipChat", "Telegram" }, s, awful.layout.layouts[1])
            elseif s.index == 3 then
                awful.tag({ "Web", "Spotify", "Aux"}, s, awful.layout.layouts[1])
            end
        end

        -- Create a promptbox for each screen
        s.mypromptbox = awful.widget.prompt()

        -- Create a taglist widget
        s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

        -- Create a tasklist widget
        s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons, nil, list_update, wibox.layout.flex.horizontal())

        -- Create the wibox
        s.mywibox = awful.wibar({ position = "bottom", height = 25, screen = s })

        -- Left Layout
        left_layout:add(s.mytaglist)
        left_layout:add(s.mypromptbox)

        -- Center Layout        
        center_layout:add(s.mytasklist)

        -- Right Layout
        right_layout:add(systray)
        right_layout:add(mykeyboardlayout)
        right_layout:add(volumecfg.widget)
        right_layout:add(mytextclock)

        -- Create the wibar
        layout:set_left(left_layout)
        layout:set_middle(center_layout)
        layout:set_right(right_layout)
        s.mywibox:set_widget(layout)
        
    end
)

-- Mouse bindings
root.buttons(
    gears.table.join(
        awful.button( { }, 3, function () mymainmenu:toggle() end ),
        awful.button( { }, 4, awful.tag.viewnext ),
        awful.button( { }, 5, awful.tag.viewprev )
    )
)

-- Key bindings
globalkeys = gears.table.join(
    awful.key(
        { modkey }, "s",

        hotkeys_popup.show_help,
        { description="show help", group="awesome" }
    ),

    awful.key(
        { modkey }, "Left",
        
        awful.tag.viewprev,
        { description = "view previous", group = "tag" }
    ),

    awful.key(
        { modkey }, "Right",
        
        awful.tag.viewnext,
        { description = "view next", group = "tag" }
    ),

    awful.key(
        { modkey }, "Escape",
        
        awful.tag.history.restore,
        { description = "go back", group = "tag" }
    ),

    awful.key(
        { modkey }, "j",

        function () awful.client.focus.byidx(1) end,
        { description = "focus next by index", group = "client" }
    ),

    awful.key(
        { modkey }, "k",
        
        function () awful.client.focus.byidx(-1) end,
        { description = "focus previous by index", group = "client" }
    ),

    awful.key(
        { modkey }, "w",
        
        function () mymainmenu:show() end,
        { description = "show main menu", group = "awesome" }
    ),

    -- Layout manipulation
    awful.key(
        { modkey, "Shift" }, "j",
        
        function () awful.client.swap.byidx(  1) end,
        { description = "swap with next client by index", group = "client" }
    ),

    awful.key(
        { modkey, "Shift" }, "k",
        
        function () awful.client.swap.byidx( -1) end,
        { description = "swap with previous client by index", group = "client" }
    ),

    awful.key(
        { modkey, "Control" }, "j",
        
        function () awful.screen.focus_relative( 1) end,
        { description = "focus the next screen", group = "screen" }
    ),

    awful.key(
        { modkey, "Control" }, "k",
        
        function () awful.screen.focus_relative(-1) end,
        { description = "focus the previous screen", group = "screen" }
    ),

    awful.key(
        { modkey }, "u",
        
        awful.client.urgent.jumpto,
        { description = "jump to urgent client", group = "client" }
    ),


    awful.key(
        { modkey }, "Tab",
        
        function(c)
            cyclefocus.cycle({
                modifier="Super_L",
            })
        end,
        { description = "next window on history", group = "client"}
    ),

    awful.key(
        { modkey, "Shift" }, "Tab",
        
        function(c)
            cyclefocus.cycle({modifier="Super_L"})
        end,
        { description = "previous window on history", group = "client"}
    ),

    awful.key(
        { modkey }, "Return",
        
        function () awful.spawn(terminal) end,
        { description = "open a terminal", group = "launcher" }
    ),

    awful.key(
        { modkey, "Control" }, "r",
        
        awesome.restart,
        { description = "reload awesome", group = "awesome"}
    ),

    awful.key(
        { modkey, "Shift" }, "q",
        
        awesome.quit,
        { description = "quit awesome", group = "awesome" }
    ),

    awful.key(
        { modkey }, "l",
        
        function () awful.tag.incmwfact(0.05) end,
        { description = "increase master width factor", group = "layout" }
    ),

    awful.key(
        { modkey }, "h",
        
        function () awful.tag.incmwfact(-0.05) end,
        { description = "decrease master width factor", group = "layout" }
    ),

    awful.key(
        { modkey, "Shift" }, "h", 
        
        function () awful.tag.incnmaster( 1, nil, true) end,
        { description = "increase the number of master clients", group = "layout" }
    ),

    awful.key(
        { modkey, "Shift" }, "l", 
        
        function () awful.tag.incnmaster(-1, nil, true) end,
        { description = "decrease the number of master clients", group = "layout" }
    ),

    awful.key(
        { modkey, "Control" }, "h", 
        
        function () awful.tag.incncol( 1, nil, true) end,
        { description = "increase the number of columns", group = "layout" }
    ),

    awful.key(
        { modkey, "Control" }, "l", 
        
        function () awful.tag.incncol(-1, nil, true) end,
        { description = "decrease the number of columns", group = "layout" }
    ),

    awful.key(
        { modkey, "Control" }, "n",

        function ()
            local c = awful.client.restore()

            -- Focus restored client
            if c then
                client.focus = c
                c:raise()
            end
        end,
        { description = "restore minimized", group = "client" }
    ),

    awful.key(
        { modkey }, "r",
        
        function () awful.screen.focused().mypromptbox:run() end,
        { description = "run prompt", group = "launcher" }
    ),

    awful.key(
        { modkey }, "x",

        function ()
            awful.prompt.run {
                prompt       = "Run Lua code: ",
                textbox      = awful.screen.focused().mypromptbox.widget,
                exe_callback = awful.util.eval,
                history_path = awful.util.get_cache_dir() .. "/history_eval"
            }
        end,
        { description = "lua execute prompt", group = "awesome" }
    ),

    awful.key(
        { modkey }, "p",
        
        function() menubar.show() end,
        { description = "show the menubar", group = "launcher" }
    ),

    -- Personal
    awful.key(
        { modkey, "Control" }, "l",
        
        function () awful.util.spawn("dm-tool lock") end,
        { description = "locks the screen", group = "personal" }        
    ), 

    awful.key(
        { modkey }, "e",
        
        function () awful.util.spawn("thunar") end,
        { description = "launches thunar file manager", group = "personal" }
    ),

    -- Personal
    -- Media
    awful.key(
        { }, "XF86AudioRaiseVolume",
        
        function () awful.util.spawn("amixer -D pulse sset Master 10%+") end,
        { description = "raises the volume", group = "personal-media" }
    ),

    awful.key(
        { }, "XF86AudioLowerVolume",
        
        function () awful.util.spawn("amixer -D pulse sset Master 10%-") end,
        { description = "decreases the volume", group = "personal-media" }
    ),
    
    awful.key(
        { }, "XF86AudioMute",
        
        function () awful.util.spawn("amixer -D pulse sset Master toggle") end,
        { description = "mute audio", group = "personal-media" }
    ),

    awful.key(
        { }, "XF86AudioPlay",
        
        function () awful.util.spawn("playerctl play-pause") end,
        { description = "play/pause song", group = "personal-media" }
    ),

    awful.key(
        { }, "XF86AudioNext",
        
        function () awful.util.spawn("playerctl next") end,
        { description = "next song", group = "personal-media" }
    ),

    awful.key(
        { }, "XF86AudioPrev",
        
        function () awful.util.spawn("playerctl previous") end,
        { description = "previous song", group = "personal-media" }
    )
)

clientkeys = gears.table.join(
    awful.key(
        { modkey }, "f",
        
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        { description = "toggle fullscreen", group = "client" }
    ),
    
    awful.key(
        { modkey }, "q",
        
        function (c) c:kill() end,
        { description = "close", group = "client" }
    ),

    awful.key(
        { modkey, "Control" }, "space",
        
        awful.client.floating.toggle,
        { description = "toggle floating", group = "client" }
    ),

    awful.key(
        { modkey, "Control" }, "Return",
        
        function (c) c:swap(awful.client.getmaster()) end,
        { description = "move to master", group = "client" }
    ),

    awful.key(
        { modkey }, "o",
        
        function (c) c:move_to_screen() end,
        { description = "move to screen", group = "client" }
    ),

    awful.key(
        { modkey }, "t",
        
        function (c) c.ontop = not c.ontop end,
        { description = "toggle keep on top", group = "client" }
    ),

    awful.key(
        { modkey }, "n",

        function (c) c.minimized = true end,
        { description = "minimize", group = "client"} ),

    awful.key(
        { modkey }, "m",
        
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        { description = "(un)maximize", group = "client" }
    ),

    awful.key(
        { modkey, "Control" }, "m",

        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        { description = "(un)maximize vertically", group = "client" }
    ),

    awful.key(
        { modkey, "Shift" }, "m",
        
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        { description = "(un)maximize horizontally", group = "client" }
    )
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
local workspaces_count = screen.count() == 1 and 9 or 3

for i = 1, workspaces_count do
    globalkeys = gears.table.join(
        globalkeys,

        -- View tag only.
        awful.key(
            { modkey }, "#" .. i + 9,
            
            function ()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]

                if tag then
                    tag:view_only()
                end
            end,
            { description = "view tag #"..i, group = "tag" }
        ),

        -- Toggle tag display.
        awful.key(
            { modkey, "Control" }, "#" .. i + 9,

            function ()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]

                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end,
            { description = "toggle tag #" .. i, group = "tag"}
        ),

        -- Move client to tag.
        awful.key(
            { modkey, "Shift" }, "#" .. i + 9,
            
            function ()
                if client.focus then
                    local tag = client.focus.screen.tags[i]

                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
            { description = "move focused client to tag #"..i, group = "tag" }
        ),

        -- Toggle tag on focused client.
        awful.key(
            { modkey, "Control", "Shift" }, "#" .. i + 9,

            function ()
                if client.focus then
                    local tag = client.focus.screen.tags[i]

                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end,
            { description = "toggle focused client on tag #" .. i, group = "tag" }
        )
    )
end

clientbuttons = gears.table.join(
    awful.button(
        { }, 1,

        function (c)
            client.focus = c
            c:raise()
        end
    ),
    
    awful.button(
        { modkey }, 1,
        
        awful.mouse.client.move
    ),
    
    awful.button(
        { modkey }, 3,

        awful.mouse.client.resize
    )
)

-- Set keys
root.keys(globalkeys)

-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    {
        rule = { },
        properties = {
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap+awful.placement.no_offscreen
        }
    },

    -- Floating clients.
    { 
        rule_any = {
            instance = { "DTA", "copyq" },

            class = {
                "Arandr",
                "Gpick",
                "Kruler",
                "MessageWin",
                "Sxiv",
                "Wpa_gui",
                "pinentry",
                "veromix",
                "xtightvncviewer"
            },

            name = {
                "Event Tester"
            },

            role = { "AlarmWindow", "pop-up" }
        },

        properties = { 
            floating = true 
        }
    },

    -- Add titlebars to normal clients and dialogs
    {
        rule_any ={
            type = { "normal", "dialog" }
        },
        
        properties = {
            titlebars_enabled = true
        }
    },
}

-- Signal function to execute when a new client appears.
client.connect_signal("manage",
    function (c)
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- if not awesome.startup then awful.client.setslave(c) end

        if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
            
            -- Prevent clients from being unreachable after screen count changes.
            awful.placement.no_offscreen(c)
        end
    end
)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars",
    function(c)
        -- buttons for the titlebar
        local buttons = gears.table.join(
            awful.button(
                { }, 1,
                
                function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end
            ),

            awful.button(
                { }, 3,
                
                function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end
            )
        )

        awful.titlebar(c) : setup {
            { layout  = wibox.layout.fixed.horizontal },
            {
                { align  = "center", widget = awful.titlebar.widget.titlewidget(c) },

                buttons = buttons,
                layout  = wibox.layout.flex.horizontal
            },
            { layout = wibox.layout.align.horizontal },
            layout = wibox.layout.align.horizontal
        }
    end
)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter",
    function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end
)

-- Better Spotify Notifications.
naughty.config.presets.spotify = { 
    callback = function(args)
        return true
    end,

    height = 100,
    width  = 400,
    icon_size = 90
}
table.insert(naughty.dbus.config.mapping, { { appname = "Spotify" }, naughty.config.presets.spotify } )

-- Startup commands
awful.spawn.with_shell("~/.config/awesome/autorun.sh")
