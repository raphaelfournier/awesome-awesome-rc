local awful = require'awful'
local rofi = require'modules.rofi'

local mod = require'bindings.mod'

client.connect_signal('request::default_keybindings', function()
   awful.keyboard.append_client_keybindings{
      awful.key{
         modifiers   = {mod.super},
         key         = 'f',
         description = 'toggle fullscreen',
         group       = 'client',
         on_press    = function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
         end,
      },
      awful.key{
         modifiers   = {mod.super, mod.shift},
         key         = 'c',
         description = 'close',
         group       = 'client',
         on_press    = function(c) c:kill() end,
      },
      awful.key{
         modifiers   = {mod.super, mod.shift},
         key         = 'a',
         description = 'flags rofi menu',
         group       = 'client',
         on_press    = function (c) rofi.client_flags(c) end
      },
      awful.key{
         modifiers   = {mod.super, mod.shift},
         key         = 'i',
         description = 'debug notification',
         group       = 'client',
         on_press    = function (c) 
            naughty.notify{ 
               title= "debug",
               text = 'This notification has actions!',
               actions = {
                  naughty.action {
                     name = 'Accept',
                  },
                  naughty.action {
                     name = 'Refuse',
                  },
                  naughty.action {
                     name = 'Ignore',
                  },
               }
            }
         end
      },
      awful.key{
         modifiers   = {mod.super, mod.shift},
         key         = 'f',
         description = 'special floating window',
         group       = 'client',
         on_press    = function (c)   
            c.floating = not c.floating
            c.width = c.screen.geometry.width*3/5
            c.x = c.screen.geometry.x+(c.screen.geometry.width/5)
            c.height = c.screen.geometry.height * 0.93
            c.y = c.screen.geometry.y+c.screen.geometry.height* 0.04
         end
      },
      awful.key{
         modifiers   = {mod.super, mod.shift},
         key         = 't',
         description = 'toggle floating',
         group       = 'client',
         on_press    = awful.client.floating.toggle,
      },
      awful.key{
         modifiers   = {mod.super, mod.ctrl},
         key         = 'm',
         description = 'minimize all but focused',
         group       = 'client',
         on_press    = function ()
            for _, c in ipairs(mouse.screen.selected_tag:clients()) do
               if c ~= client.focus then
                  c.minimized = true
               end
            end
         end
      },
      awful.key{
         modifiers   = {mod.super, mod.shift},
         key         = 'm',
         description = 'minimize client',
         group       = 'client',
         on_press    = function (c) c.minimized = true end
      },
      awful.key{
         modifiers   = {mod.super, mod.ctrl},
         key         = 'Return',
         description = 'move to master',
         group       = 'client',
         on_press    = function(c) c:swap(awful.client.getmaster()) end,
      },
      awful.key{
         modifiers   = {mod.super, mod.shift},
         key         = 'o',
         description = 'restore tags',
         group       = 'client',
         on_press    = function(c) 
            c:tags(c.original_tags)          
            c.screen = c.original_screen
         end,
      },
      awful.key{
         modifiers   = {mod.super, mod.ctrl},
         key         = 'o',
         description = 're-apply rules on client',
         group       = 'client',
         on_press    = function(c) 
            awful.rules.apply(c)
         end,
      },
      awful.key{
         modifiers   = {mod.super},
         key         = 'o',
         description = 'move to screen',
         group       = 'client',
         on_press    = function(c) c:move_to_screen() end,
      },
      awful.key{
         modifiers   = {mod.super},
         key         = 't',
         description = 'toggle keep on top',
         group       = 'client',
         on_press    = function(c) c.ontop = not c.ontop end,
      },
      awful.key{
         modifiers   = {mod.super},
         key         = 'n',
         description = 'minimize',
         group       = 'client',
         on_press    = function(c) c.minimized  = true end,
      },
      awful.key{
         modifiers   = {mod.super},
         key         = 'm',
         description = '(un)maximize',
         group       = 'client',
         on_press    = function(c)
            c.maximized = not c.maximized
            c:raise()
         end,
      },
      awful.key{
         modifiers   = {mod.super, mod.ctrl},
         key         = 'm',
         description = '(un)maximize vertically',
         group       = 'client',
         on_press    = function(c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
         end,
      },
      awful.key{
         modifiers   = {mod.super, mod.shift},
         key         = 'm',
         description = '(un)maximize horizontally',
         group       = 'client',
         on_press    = function(c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
         end,
      },
   }
end)
