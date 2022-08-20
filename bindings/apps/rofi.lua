local awful = require'awful'
local mod = require'bindings.mod'

awful.keyboard.append_global_keybindings{
   awful.key{
      modifiers   = {mod.super, mod.shift},
      key         = 'space',
      description = 'rofi pass',
      group       = 'rofi',
      on_press    = function () awful.util.spawn("rofi-pass") end
   },
   awful.key{
      modifiers   = {mod.super},
      key         = 'space',
      description = 'rofi combi',
      group       = 'rofi',
      on_press    = function () 
         awful.util.spawn("rofi -config ~/.config/rofi/config.rasi -show combi -combi-modi \"window,run\" -modi combi,xr:/home/raph/Code/langageBash/rofi-modi-xrandr.sh,ssh,clip:\"greenclip print\",emoji:~/.scripts/rofiemoji/rofiemoji.sh,calc") 
      end
   },
   awful.key{
      modifiers   = {mod.super},
      key         = '=',
      description = 'calc',
      group       = 'rofi',
      on_press    = function () awful.util.spawn("= --") end
   },
   awful.key{
      modifiers   = {mod.super, mod.shift},
      key         = 'p',
      description = 'cours',
      group       = 'rofi',
      on_press    = function () awful.spawn.with_shell("/usr/bin/grep cours /home/raph/.fzf-marks | rofi -config ~/.config/rofi/config.rasi -dmenu -p Cours | cut -d ':' -f 2 | xargs --no-run-if-empty " .. terminal .. " -e ranger")       end
   },
   awful.key{
      modifiers   = {mod.super, mod.shift},
      key         = 'd',
      description = 'mpd playlists',
      group       = 'rofi',
      on_press    = function () 
         awful.spawn.with_shell("mpc lsplaylists| rofi -config ~/.config/rofi/config.rasi -dmenu -p \"Choose playlist\" | xargs --no-run-if-empty /home/raph/.scripts/mpc-startPlaylist.sh") 
      end
   },
   awful.key{
      modifiers   = {mod.super, mod.shift},
      key         = '=',
      description = 'notes',
      group       = 'rofi',
      on_press    = function () awful.util.spawn("/home/raph/.scripts/rofi/rofi-notes/rofi_notes.sh") end
   },
   awful.key{
      modifiers   = {mod.super},
      key         = 'q',
      description = 'rofi-mpc',
      group       = 'rofi',
      on_press    = function () 
         awful.util.spawn("rofi-mpc -config ~/.config/rofi/config.rasi ")
      end
   },

   awful.key{
      modifiers   = {mod.alt, mod.shift},
      key         = 'a',
      description = 'backlight',
      group       = 'rofi',
      on_press    = function () awful.util.spawn("/home/raph/.config/rofi/applets/menu/backlight.sh") end
   },
   awful.key{
      modifiers   = {mod.alt, mod.shift},
      key         = 'q',
      description = 'power menu',
      group       = 'rofi',
      on_press    = function () awful.util.spawn("/home/raph/.config/rofi/applets/menu/powermenu.sh") end
   },
   awful.key{
      modifiers   = {mod.alt, mod.shift},
      key         = 's',
      description = 'screenshots',
      group       = 'rofi',
      on_press    = function () awful.util.spawn("/home/raph/.config/rofi/applets/menu/screenshot.sh") end
   },
   awful.key{
      modifiers   = {mod.alt, mod.shift},
      key         = 'd',
      description = 'mpd',
      group       = 'rofi',
      on_press    = function () awful.util.spawn("/home/raph/.config/rofi/applets/menu/mpd.sh") end
   },
   awful.key{
      modifiers   = {mod.alt, mod.shift},
      key         = 'w',
      description = 'volume menu',
      group       = 'rofi',
      on_press    = function () awful.util.spawn("/home/raph/.config/rofi/applets/menu/volume.sh") end
   },
}
