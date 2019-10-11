-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox") -- Widget and layout library
local beautiful = require("beautiful") -- Theme handling library
local naughty = require("naughty") -- Notification library

local lain = require('lain')
local ezconfig = require('ezconfig/ezconfig.lua')
local scratch = require('scratch/scratch.lua')

modkey = 'Mod4'
ezconfig.modkey = modkey
ezconfig.altkey = 'Mod1'

HOME = os.getenv("HOME")
TERMINAL = os.getenv("TERMINAL") or "x-terminal-emulator"
EDITOR = os.getenv("EDITOR") or "editor"

-- Utility functions
function join(...)
    return table.concat({...}, " ")
end

-- Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors})
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function(err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true
        naughty.notify({
            preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err)})
        in_error = false
    end)
end

-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

beautiful.useless_gap = 5
beautiful.border_width = 5
beautiful.border_focus = "#ff00ff"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    lain.layout.termfair.center,
    lain.layout.centerwork,
}

-- Create a textclock widget
local mytextclock = wibox.widget.textclock("%H:%M:%S | %a %b %d", 1)
-- local mycpu = lain.widget.cpu()
local mycpu = lain.widget.cpu({
    settings = function()
        widget:set_markup("CPU: " .. cpu_now.usage .. "% | ")
    end})
local mymem = lain.widget.mem({
    settings = function()
        widget:set_markup("MEM: " .. math.floor(mem_now.used/1024) .. " GB | ")
    end})

awful.screen.connect_for_each_screen(function(s)
    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
    }

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.systray(),
            mycpu.widget,
            mymem.widget,
            mytextclock,
            s.mylayoutbox,
        },
    } end)

-- Key bindings
globalkeys = ezconfig.keytable.join({
    ['M-<Left>'] = awful.tag.viewprev, -- Previous tag
    ['M-<Right>'] = awful.tag.viewnext, -- Next tag
    ['M-<Esc>'] = awful.tag.history.restore, -- Go back
    ['M-j'] = { awful.client.focus.byidx, 1 }, -- Focus next
    ['M-k'] = { awful.client.focus.byidx, -1 }, -- Focus prev
    ['M-S-j'] = { awful.client.swap.byidx, 1 }, -- Swap next
    ['M-S-k'] = { awful.client.swap.byidx, -1 }, -- Swap next
    ['M-C-j'] = { awful.screen.focus_relative, 1 }, -- Focus next (relative)
    ['M-C-k'] = { awful.screen.focus_relative, -1 }, -- Focus prev (relative)

    ['M-C-r'] = awesome.restart, -- Restart
    ['M-C-q'] = awesome.quit, -- Quit

    ['M-l'] = { awful.tag.incmwfact, 0.05 }, -- Increase width
    ['M-h'] = { awful.tag.incmwfact, -0.05 }, -- Decrease width
    ['M-S-h'] = { awful.tag.incnmaster, 1, nil, true }, -- Increase number of clients
    ['M-S-l'] = { awful.tag.incnmaster, -1, nil, true }, -- Decrease number of clients
    ['M-C-h'] = { awful.tag.incncol,  1, nil, true }, -- Increase number of columns
    ['M-C-l'] = { awful.tag.incncol, -1, nil, true }, -- Decrease number of columns
    -- ['M-<space>'] = { awful.layout.inc, 1 }, -- Next layout
    -- ['M-S-<space>'] = { awful.layout.inc, -1 }, -- Previous layout

    ['M-a'] = { awful.spawn, join(TERMINAL, '-e', EDITOR, HOME .. '/.config/awesome/rc.lua') },

    -- scratchpads
    ['M-p'] = { scratch.toggle, join(TERMINAL, '-n scratch-python', '-e python'), { instance = 'scratch-python' } },
    ['M-t'] = { scratch.toggle, join(TERMINAL, '-n scratch-incoming', '-e', EDITOR, HOME .. '/Incoming.md'), { instance = "scratch-incoming" } },
    ['M-n'] = function() 
        awful.menu.menu_keys.down = { "Down", "Alt_L" }
        local cmenu = awful.menu.clients({width=400}, {keygrabber=true, coords={x=0, y=10}})
    end
})

for i = 1, 9 do globalkeys = gears.table.join(globalkeys,
    -- View tag only.
    awful.key({ modkey }, "#" .. i + 9, function()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
           tag:view_only()
        end
    end, {description = "view tag #"..i, group = "tag"}),

    -- Toggle tag display.
    awful.key({ modkey, "Control" }, "#" .. i + 9, function()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
           awful.tag.viewtoggle(tag)
        end
    end, {description = "toggle tag #" .. i, group = "tag"}),

    -- Move client to tag.
    awful.key({ modkey, "Shift" }, "#" .. i + 9, function()
        if client.focus then
            local tag = client.focus.screen.tags[i]
            if tag then
                client.focus:move_to_tag(tag)
            end
        end
    end, {description = "move focused client to tag #"..i, group = "tag"}),

    -- Toggle tag on focused client.
    awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9, function()
        if client.focus then
            local tag = client.focus.screen.tags[i]
            if tag then
                client.focus:toggle_tag(tag)
            end
        end
    end, {description = "toggle focused client on tag #" .. i, group = "tag"}))
end

root.keys(globalkeys)

clientkeys = ezconfig.keytable.join({
    ['M-f'] = function (c) -- Toggle fullscreen
        c.fullscreen = not c.fullscreen
        c:raise()
    end,
    ['M-S-c'] = function (c) c:kill() end, -- Kill
    ['M-C-<space>'] = awful.client.floating.toggle, -- Toggle floating
    ['M-C-<Return>'] = function (c) c:swap(awful.client.getmaster()) end, -- Move to master
    ['M-o'] = function (c) c:move_to_screen() end, -- Move to screen
    -- ['M-t'] = function (c) c.ontop = not c.ontop end, -- Toggle keep-on-top
    -- ['M-n'] = function (c) c.minimized = true end, -- Minimize
    -- ['M-n'] = function (c) c:restore() end, -- Minimize
    ['M-m'] = function (c) -- Maximize
        c.maximized = not c.maximized
        c:raise()
    end,
    ['M-C-m'] = function (c) -- (Un)maximize vertically
        c.maximized_vertical = not c.maximized_vertical
        c:raise()
    end,
    ['M-S-m'] = function (c) -- (Un)maximize horizontally
        c.maximized_horizontal = not c.maximized_horizontal
        c:raise()
    end,

    ['M-S-<space>'] = awful.client.floating.toggle, -- Toggle floating
    ['M-<space>'] = function (c) c:swap(awful.client.getmaster()) end, -- Move to master
})

clientbuttons = ezconfig.btntable.join({
    ['1'] = function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end,
    ['M-1'] = function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end,
    ['M-3'] = function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end
})

-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = {},
      properties = {
          border_width = beautiful.border_width,
          border_color = beautiful.border_normal,
          focus = awful.client.focus.filter,
          raise = true,
          keys = clientkeys,
          buttons = clientbuttons,
          screen = awful.screen.preferred,
          placement = awful.placement.no_overlap + awful.placement.no_offscreen}
    },

    { rule_any = { instance = { "scratch" } },
      properties = { floating = true },
      callback = function (c)
          local f = awful.placement.scale + awful.placement.centered
          f(c, { to_percent = 0.5 })
      end,
    },
}

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
        and not c.size_hints.user_position
        and not c.size_hints.program_position
    then -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

client.connect_signal("focus", function (c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function (c) c.border_color = beautiful.border_normal end)
