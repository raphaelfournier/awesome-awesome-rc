local awful = require'awful'
local naughty = require'naughty'
local mod = require'bindings.mod'

local muttcommand = terminal .. " -e zsh -c \'echo -en \"\\e]1;mutt\\a\";echo -en \"\\e]2;mutt\\a\";echo -en \"\\e]0;mutt\\a\";sleep 0.05s; screen -S mutt mutt -F .muttrc\'"

awful.keyboard.append_global_keybindings{
   awful.key{
      modifiers   = {mod.super},
      key         = 'd',
      description = 'ncmpcpp',
      group       = 'apps',
      on_press    = function () 
         local matcher = function (c)
            return awful.rules.match(c, {name = "ncmpcpp"})
         end
         awful.client.run_or_raise(terminal .. ' --class ncmpcpp -e ncmpcpp', matcher)
      end
   },
   awful.key{
      modifiers   = {mod.super, mod.shift},
      key         = 'q',
      description = 'ticktick',
      group       = 'apps',
      on_press    = function () 
         local matcher = function (c)
            return awful.rules.match(c, {name = "ticktick"})
         end
         awful.client.run_or_raise('ticktick', matcher)
      end
   },
   awful.key{
      modifiers   = {mod.super},
      key         = 'e',
      description = 'ranger',
      group       = 'apps',
      on_press    = function () awful.util.spawn(terminal .." --class ranger -e ranger") end
   },
   awful.key{
      modifiers   = {mod.super, mod.shift},
      key         = 'e',
      description = 'file explorer nemo',
      group       = 'apps',
      on_press    = function () awful.util.spawn("nemo") end
   },
   awful.key{
      modifiers   = {mod.super},
      key         = 'c',
      description = 'mutt',
      group       = 'apps',
      on_press    = function () 
         -- TODO
         --awful.util.spawn(muttcommand, {tag = "mail"}) 
         --if not naughty.is_suspended() then
            awful.screen.focus(1)
            awful.tag.viewonly(awful.tag.find_by_name(screen[1], "mail"))
            awful.util.spawn(muttcommand, {tag = "mail"}) 
         --end
      end
   },
}
