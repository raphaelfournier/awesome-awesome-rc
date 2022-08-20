local awful = require'awful'
local hotkeys_popup = require'awful.hotkeys_popup'
require'awful.hotkeys_popup.keys'
local menubar = require'menubar'

local apps = require'config.apps'
local mod = require'bindings.mod'
local widgets = require'widgets'
local bling = require('modules.bling')

menubar.utils.terminal = apps.terminal

local function tag_view_nonempty(step, s)
   step = step or 1
   s = s or awful.screen.focused()
   local tags = s.tags
   local bound = step > 0 and #tags or 1

   for i = s.selected_tag.index + step, bound, step do
      local t = tags[i]
      if #t:clients() > 0 then
         t:view_only()
         return
      end
   end
end

--- {{{ scratchpads
-- https://blingcorp.github.io/bling/#/module/scratch
local term_scratch = bling.module.scratchpad {
    command = terminal .. " --class spad",            -- How to spawn the scratchpad
    rule = { instance = "spad" },                     -- The rule that the scratchpad will be searched by
    sticky = true,                                    -- Whether the scratchpad should be sticky
    autoclose = true,                                 -- Whether it should hide itself when losing focus
    floating = true,                                  -- Whether it should be floating (MUST BE TRUE FOR ANIMATIONS)
    geometry = {x=360, y=90, height=900, width=1200}, -- The geometry in a floating state
    reapply = true,                                   -- Whether all those properties should be reapplied on every new opening of the scratchpad (MUST BE TRUE FOR ANIMATIONS)
    dont_focus_before_close  = false,                 -- When set to true, the scratchpad will be closed by the toggle function regardless of whether its focused or not. When set to false, the toggle function will first bring the scratchpad into focus and only close it on a second call
    --rubato = {x = anim_x, y = anim_y}                 -- Optional. This is how you can pass in the rubato tables for animations. If you don't want animations, you can ignore this option.
}

local calc_scratch = bling.module.scratchpad {
    command = terminal .. " --class calc -e sh -c 'echo \"---- eva ----\nprevious answer _\n\";eva'", 
    rule = { instance = "calc" }, sticky = true, autoclose = true, floating = true,
    geometry = {x=360, y=90, height=900, width=1200}, reapply = true,
    dont_focus_before_close  = true, 
}
local python_scratch = bling.module.scratchpad {
    command = terminal .. " --class python -e python", 
    rule = { instance = "python" }, sticky = true, autoclose = true, floating = true,
    geometry = {x=360, y=90, height=900, width=1200}, reapply = true,
    dont_focus_before_close  = false, 
}
--- }}}

-- general awesome keys
awful.keyboard.append_global_keybindings{
   awful.key{
      modifiers   = {mod.super, mod.ctrl},
      key         = 's',
      description = 'show help',
      group       = 'awesome',
      on_press    = hotkeys_popup.show_help,
   },
   awful.key{
      modifiers   = {mod.super, mod.ctrl},
      key         = 'w',
      description = 'show main menu',
      group       = 'awesome',
      on_press    = function() widgets.mainmenu:show() end,
   },
   awful.key{
      modifiers   = {mod.super, mod.ctrl},
      key         = 'r',
      description = 'reload awesome',
      group       = 'awesome',
      on_press    = awesome.restart,
   },
   --awful.key{
      --modifiers   = {mod.super, mod.shift},
      --key         = 'q',
      --description = 'quit awesome',
      --group       = 'awesome',
      --on_press    = awesome.quit,
   --},
   --awful.key{
      --modifiers   = {mod.super, mod.shift},
      --key         = 'r',
      --description = 'lua execute prompt',
      --group       = 'awesome',
      --on_press    = function()
         --awful.prompt.run{
            --prompt = 'Run Lua code: ',
            --textbox = awful.screen.focused().promptbox.widget,
            --exe_callback = awful.util.eval,
            --history_path = awful.util.get_cache_dir() .. '/history_eval'
         --}
      --end,
   --},
   awful.key{
      modifiers   = {mod.super},
      key         = 'x',
      description = 'open a terminal',
      group       = 'launcher',
      on_press    = function() awful.spawn(apps.terminal) end,
   },
   awful.key{
      modifiers   = {mod.super, mod.shift},
      key         = 'x',
      description = 'open a slave terminal',
      group       = 'launcher',
      on_press    = function () awful.spawn("alacritty --class Alacritty-slave") end
   },
   awful.key{
      modifiers   = {mod.super},
      key         = 'Return',
      description = 'run prompt',
      group       = 'launcher',
      on_press    = function() awful.screen.focused().promptbox:run() end,
   },
   awful.key{
      modifiers   = {mod.super, mod.ctrl},
      key         = 'p',
      description = 'show the menubar',
      group       = 'launcher',
      on_press    = function() menubar.show() end,
   },
   awful.key{
      modifiers   = {mod.super, mod.ctrl},
      key         = 'a',
      description = 'lock screen',
      group       = 'apps',
      on_press    = function () awful.util.spawn(apps.screenlock_cmd) end
   },
   awful.key{
      modifiers   = {mod.super, mod.shift},
      key         = '<',
      description = 'find cursor',
      group       = 'apps',
      on_press    = function () awful.spawn("find-cursor --color red --line-width 16") end
   },
}

-- tags related keybindings
awful.keyboard.append_global_keybindings{
   awful.key{
      modifiers   = {mod.super},
      key         = 'Prior',
      description = 'view previous',
      group       = 'tag',
      on_press    = awful.tag.viewprev,
   },
   awful.key{
      modifiers   = {mod.super},
      key         = 'Next',
      description = 'view next',
      group       = 'tag',
      on_press    = awful.tag.viewnext,
   },
   awful.key{
      modifiers   = {mod.super},
      key         = 'Escape',
      description = 'go back',
      group       = 'tag',
      on_press    = awful.tag.history.restore,
   },
   awful.key{
      modifiers   = {mod.super},
      key         = 'l',
      description = 'view next non empty',
      group       = 'tag',
      on_press    = function () tag_view_nonempty(1) end,
   },
   awful.key{
      modifiers   = {mod.super},
      key         = 'h',
      description = 'view previous non empty',
      group       = 'tag',
      on_press    = function () tag_view_nonempty(-1) end,
   },
   awful.key{
      modifiers   = {mod.super},
      key         = 'Left',
      description = 'view previous non empty',
      group       = 'tag',
      on_press    = function () tag_view_nonempty(-1) end,
   },
   awful.key{
      modifiers   = {mod.super},
      key         = 'Right',
      description = 'view next non empty',
      group       = 'tag',
      on_press    = function () tag_view_nonempty(1) end,
   },
   awful.key{
      modifiers   = {mod.super, mod.alt},
      key         = 'a',
      description = 'add a tag',
      group       = 'tag',
      on_press    = add_tag,
   },
   awful.key{
      modifiers   = {mod.super, mod.alt},
      key         = 'd',
      description = 'delete a tag',
      group       = 'tag',
      on_press    = delete_tag,
   },
   awful.key{
      modifiers   = {mod.super, mod.alt},
      key         = 'r',
      description = 'add a tag',
      group       = 'tag',
      on_press    = rename_tag,
   },
}

-- focus related keybindings
awful.keyboard.append_global_keybindings{
   awful.key{
      modifiers   = {mod.super},
      key         = 'j',
      description = 'focus next by index',
      group       = 'client',
      on_press    = function() awful.client.focus.byidx(1) end,
   },
   awful.key{
      modifiers   = {mod.super},
      key         = 'k',
      description = 'focus previous by index',
      group       = 'client',
      on_press    = function() awful.client.focus.byidx(-1) end,
   },
   awful.key{
      modifiers   = {mod.alt},
      key         = 'Tab',
      description = 'go back',
      group       = 'client',
      on_press    = function()
         awful.spawn.with_shell("rofi -modi windowcd -show windowcd -kb-accept-entry '!Alt-Tab' -kb-row-down Alt-Tab,Down -kb-row-up Alt+Shift+Tab,Up")
      end,
   },
   awful.key{
      modifiers   = {mod.super},
      key         = 'Tab',
      description = 'go back',
      group       = 'client',
      on_press    = function()
         awful.client.focus.history.previous()
         if client.focus then
            client.focus:raise()
         end
      end,
   },
   awful.key{
      modifiers   = {mod.super, mod.ctrl},
      key         = 'k',
      description = 'focus the next screen',
      group       = 'screen',
      on_press    = function() awful.screen.focus_relative(-1) end,
   },
   awful.key{
      modifiers   = {mod.super, mod.ctrl},
      key         = 'j',
      description = 'focus the previous screen',
      group       = 'screen',
      on_press    = function() awful.screen.focus_relative(1) end,
   },
   awful.key{
      modifiers   = {mod.super, mod.ctrl},
      key         = 'l',
      description = 'remove cursor',
      group       = 'mouse',
      on_press    = function () mouse.coords { x = 185, y = 38, silent=true } end
   },
   awful.key{
      modifiers   = {mod.super, mod.ctrl},
      key         = 'n',
      description = 'restore minimized',
      group       = 'client',
      on_press    = function()
         local c = awful.client.restore()
         if c then
            c:active{raise = true, context = 'key.unminimize'}
         end
      end,
   },
}

-- layout related keybindings
awful.keyboard.append_global_keybindings{
   awful.key{
      modifiers   = {mod.super, mod.shift},
      key         = 'j',
      description = 'swap with next client by index',
      group       = 'client',
      on_press    = function() awful.client.swap.byidx(1) end,
   },
   awful.key{
      modifiers   = {mod.super, mod.shift},
      key         = 'k',
      description = 'swap with previous client by index',
      group       = 'client',
      on_press    = function() awful.client.swap.byidx(-1) end,
   },
   awful.key{
      modifiers   = {mod.super},
      key         = 'u',
      description = 'jump to urgent client',
      group       = 'client',
      on_press    = awful.client.urgent.jumpto,
   },
   awful.key{
      modifiers   = {mod.super, mod.shift},
      key         = 'l',
      description = 'increase master width factor',
      group       = 'layout',
      on_press    = function() awful.tag.incmwfact(0.05) end,
   },
   awful.key{
      modifiers   = {mod.super, mod.shift},
      key         = 'h',
      description = 'decrease master width factor',
      group       = 'layout',
      on_press    = function() awful.tag.incmwfact(-0.05) end,
   },
   awful.key{
      modifiers   = {mod.super},
      key         = 'n',
      description = 'increase the number of master clients',
      group       = 'layout',
      on_press    = function() awful.tag.incnmaster(1, nil, true) end,
   },
   awful.key{
      modifiers   = {mod.super},
      key         = 'p',
      description = 'decrease the number of master clients',
      group       = 'layout',
      on_press    = function() awful.tag.incnmaster(-1, nil, true) end,
   },
   awful.key{
      modifiers   = {mod.super, mod.ctrl},
      key         = 'h',
      description = 'increase the number of columns',
      group       = 'layout',
      on_press    = function() awful.tag.incnmaster(1, nil, true) end,
   },
   awful.key{
      modifiers   = {mod.super, mod.ctrl},
      key         = 'l',
      description = 'decrease the number of columns',
      group       = 'layout',
      on_press    = function() awful.tag.incnmaster(-1, nil, true) end,
   },
   awful.key{
      modifiers   = {mod.super},
      key         = '<',
      description = 'select next',
      group       = 'layout',
      on_press    = function() awful.layout.inc(1) end,
   },
   awful.key{
      modifiers   = {mod.super, mod.shift},
      key         = '<',
      description = 'select previous',
      group       = 'layout',
      on_press    = function() awful.layout.inc(-1) end,
   },
   awful.key{
      modifiers   = {mod.super},
      key         = 'w',
      description = 'layout max',
      group       = 'layout',
      on_press    = function () awful.layout.set(awful.layout.suit.max) end
   },
   awful.key{
      modifiers   = {mod.super, mod.shift},
      key         = 'w',
      description = 'layout tile',
      group       = 'layout',
      on_press    = function () awful.layout.set(awful.layout.suit.tile) end
   },
}

awful.keyboard.append_global_keybindings{
   awful.key{
      modifiers   = {mod.super},
      keygroup    = 'numrow',
      description = 'only view tag',
      group       = 'tag',
      on_press    = function(index)
         local screen = awful.screen.focused()
         local tag = screen.tags[index]
         if tag then
            tag:view_only(tag)
         end
      end
   },
   awful.key{
      modifiers   = {mod.super, mod.ctrl},
      keygroup    = 'numrow',
      description = 'toggle tag',
      group       = 'tag',
      on_press    = function(index)
         local screen = awful.screen.focused()
         local tag = screen.tags[index]
         if tag then
            tag:viewtoggle(tag)
         end
      end
   },
   awful.key{
      modifiers   = {mod.super, mod.shift},
      keygroup    = 'numrow',
      description = 'move focused client to tag',
      group       = 'tag',
      on_press    = function(index)
         if client.focus then
            local tag = client.focus.screen.tags[index]
            if tag then
               client.focus:move_to_tag(tag)
            end
         end
      end
   },
   awful.key {
      modifiers   = {mod.super, mod.ctrl, mod.shift},
      keygroup    = 'numrow',
      description = 'toggle focused client on tag',
      group       = 'tag',
      on_press    = function(index)
         if client.focus then
            local tag = client.focus.screen.tags[index]
            if tag then
               client.focus:toggle_tag(tag)
            end
         end
      end,
   },
   awful.key{
      modifiers   = {mod.super},
      keygroup    = 'numpad',
      description = 'select layout directrly',
      group       = 'layout',
      on_press    = function(index)
         local tag = awful.screen.focused().selected_tag
         if tag then
            tag.layout = tag.layouts[index] or tag.layout
         end
      end
   },
}

-- app launch
awful.keyboard.append_global_keybindings{
   -- audio
   awful.key{
      modifiers   = {},
      key         = 'XF86AudioPrev',
      description = 'Previous track',
      group       = 'Audio',
      on_press    = function () awful.util.spawn("mpc prev") end
   },
   awful.key{
      modifiers   = {},
      key         = 'XF86AudioNext',
      description = 'Next track',
      group       = 'Audio',
      on_press    = function () awful.util.spawn("mpc next") end
   },
   awful.key{
      modifiers   = {},
      key         = 'XF86AudioPlay',
      description = 'Toggle play track',
      group       = 'Audio',
      on_press    = function () awful.util.spawn("mpc toggle") end
   },
   awful.key{
      modifiers   = {},
      key         = 'XF86AudioRaiseVolume',
      description = 'Raise volume',
      group       = 'Audio',
      on_press    = function () awful.util.spawn("amixer -q -c 0 sset Master 2dB+") end
   },
   awful.key{
      modifiers   = {},
      key         = 'XF86AudioMute',
      description = 'Mute volume',
      group       = 'Audio',
      on_press    = function () awful.util.spawn("amixer -q -c 0 sset Master toggle") end
   },
   awful.key{
      modifiers   = {},
      key         = 'XF86AudioPlay',
      description = 'Toggle play track',
      group       = 'Audio',
      on_press    = function () awful.util.spawn("mpc toggle") end
   },
   
   -- scratchpads
   awful.key{
      modifiers   = {mod.super},
      key         = 'z',
      description = 'scratch term',
      group       = 'scratchpads',
      on_press    = function () term_scratch:toggle() end
   },
   awful.key{
      modifiers   = {mod.super},
      key         = 'a',
      description = 'calc term',
      group       = 'scratchpads',
      on_press    = function () calc_scratch:toggle() end
   },
   awful.key{
      modifiers   = {mod.super,mod.shift},
      key         = 'z',
      description = 'scratch term',
      group       = 'scratchpads',
      on_press    = function () python_scratch:toggle() end
   },
}
--
-- vim: set fdm=marker fmr={{{,}}} fdl=0:fdc=2
