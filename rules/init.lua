local awful = require'awful'
local ruled = require'ruled'
local beautiful = require'beautiful'

ruled.client.connect_signal('request::rules', function()
   -- All clients will match this rule.
   ruled.client.append_rule{
      id         = 'global',
      rule       = {},
      properties = {
         focus     = awful.client.focus.filter,
         raise     = true,
         screen    = awful.screen.preferred,
         keys = clientkeys,
         border_width = beautiful.border_width,
         border_color = beautiful.border_normal,
         size_hints_honor = false,
         buttons = clientbuttons,
         placement = awful.placement.no_overlap + awful.placement.no_offscreen
      }
   }

   -- Floating clients.
   ruled.client.append_rule{
      id = 'floating',
      rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "scratch",  -- Includes session name in class.
        },
         class = {
            --'Arandr',
            'Blueman-manager',
            'Gpick',
            'Kruler',
            'Sxiv',
            'Tor Browser',
            'Wpa_gui',
            'veromix',
            'xtightvncviewer',
         },
         -- Note that the name property shown in xprop might be set slightly after creation of the client
         -- and the name shown there might not match defined rules here.
         name = {
            'Event Tester',  -- xev.
         },
         role = {
            'AlarmWindow',    -- Thunderbird's calendar.
            'ConfigManager',  -- Thunderbird's about:config.
            'pop-up',         -- e.g. Google Chrome's (detached) Developer Tools.
         }
      },
      properties = {floating = true}
   }

   -- Add titlebars to normal clients and dialogs
   --ruled.client.append_rule{
      --id         = 'titlebars',
      --rule_any   = {type = {'normal', 'dialog'}},
      --properties = {titlebars_enabled = true},
   --}

   -- Set Firefox to always map on the tag named '2' on screen 1.
    ruled.client.append_rules {
       {  rule       = {class = 'Firefox'},
       properties = {screen = 1, tag = 'web'}
    },
    { rule = { instance = "Alacritty-slave" },
       callback = function(c)
          awful.client.setslave(c)
       end,
    },
    { rule = { name = "mutt" },
      properties = { screen = 1, tag = "mail", switchtotag = true  } },
    { rule = { class = "Opera" },
      properties = { screen = 1, tag = "web" } },
    { rule = { name = "screen" },
      properties = { screen = 1, tag = "work" } },
    { rule = { instance = "microsoft teams" },
      properties = { screen = screen:count(), tag = "im", focus = false} },
    { rule = { instance = "zoom" },
      properties = { screen = screen:count(), tag = "im"} },
    { rule = { class = "zoom", name = "Discussion" },
      properties = { screen = screen:count(), tag = "im"}}, 
    { rule = { name = "Signal" },
      properties = { screen = screen:count(), tag = "im"} },
    { rule = { instance = "biscuit" },
      properties = { screen = screen:count(), tag = "im"} },
    { rule = { name = "Ferdi" },
      properties = { screen = screen:count(), tag = "im"} },
    { rule = { name = "zihap" },
      properties = { screen = screen:count(), tag = "im"} },
    { rule = { name = "Rambox" },
      properties = { screen = screen:count(), tag = "im"} },
    { rule = { name = "Franz" },
      properties = { screen = screen:count(), tag = "im"} },
    { rule = { name = "FreeCAD" },
      properties = { screen = 1, tag = "root", switchtotag = false  } },
    { rule = { name = "Eclipse" },
      properties = { screen = 1, tag = "work", switchtotag = false  } },
    { rule = { name = "Sonata" },
      properties = { screen = screen:count(), tag = "media", switchtotag = true  } },
    { rule = { instance = "ncmpcpp" },
      properties = { screen = screen:count(), tag = "media", switchtotag = true  } },
    { rule = { class = "Acroread" },
      properties = { tag = "pdf", switchtotag = true } },
    { rule = { class = "Epdfview" },
      properties = { tag = "pdf", switchtotag = true } },
    { rule = { class = "okular" },
      properties = { tag = "pdf", switchtotag = true } },
    { rule = { class = "Evince" },
      properties = { tag = "pdf", switchtotag = true } },
    { rule = { class = "Zathura" },
      properties = { tag = "pdf", switchtotag = true } },
    { rule = { class = "Xephyr" },
      properties = { placement = awful.placement.centered }},
    { rule = { instance = "floating" },
      properties = { floating = true, placement = awful.placement.centered }},
    { rule = { class = "Xsane", name = "Information" },
      properties = { floating = true, geometry = { height=200, width=300 } }},
    { rule = { class = "Zathura", name = "Imprimer" },
      properties = { floating = false }},
    { rule = { class = "QtPass" }, properties = { 
      floating = true, screen = 1, tag = "web", geometry = { height=600, width=800 },
   } },
          --c.floating = not c.floating
          --c.width = c.screen.geometry.width*3/5
          --c.x = c.screen.geometry.x+(c.screen.geometry.width/5)
          --c.height = c.screen.geometry.height * 0.93
          --c.y = c.screen.geometry.height* 0.04
    { rule = { class = "Alarm-clock" }, properties = { floating = true } },
    { rule = { instance = "libreoffice" }, properties = { tag = "pdf", maximized = false, switchtotag = true } },
    { rule = { name = "alsamixer" }, properties = { screen = 1, tag = "root", switchtotag = true } },
    { rule = { class = "communications" }, properties = { screen = screen:count(),tag = "im"} },
    { rule = { class = "calendar" }, properties = { screen = screen:count(),tag = "todo",switchtotag=true, maximized = false} },
    { rule = { class = "wordreference" }, properties = { screen = screen:count(),tag = "todo",switchtotag=true,maximized=false} },
    { rule = { class = "todolist" }, properties = { screen = screen:count(),tag = "todo",switchtotag=true, maximized = false} },
    { rule = { instance = "watson" }, properties = { screen = screen:count(),tag = "todo",switchtotag=true,maximized=false} },
    { rule = { class = "code-oss" }, properties = { screen = 1, tag = "work", switchtotag = true } },
    { rule = { instance = "rootterm" }, properties = { screen = 1, tag = "root", switchtotag = true } },
    { rule = { class = "Deluge" },
      properties = { screen = screen:count(), tag = "media" } },
    --{ rule = { class = "Homebank" },
      --properties = { screen = screen:count(), tag = "media", switchtotag = true} },
    { rule = { class = "ticktick-" },
      properties = { screen = screen:count(), tag = "todo"} },
    { rule = { class = "yakyak" },
      properties = { screen = screen:count(), tag = "im"} },
    { rule = { class = "Chromium" },
      properties = { screen = 1, tag = "web", switchtotag = true} },
    { rule = { class = "Surf" },
      properties = { screen = 1, tag = "term", floating = false, switchtotag = true } },
    { rule = { class = "Pavucontrol" },
      properties = { screen =screen:count(), tag = "media", floating = true,  geometry = { height=600, width=1100, y=200, x=200 },} },
    { rule = { class = "Spotify" },
      properties = { screen =screen:count(), tag = "media" } },
    { rule = { class = "Scribus" },
      properties = { screen = 1, tag = "graph" } },
    { rule = { class = "Gorilla" },
      properties = { screen = 1, tag = "graph", switchtotag = true, floating = true } },
    { rule = { class = "Inkscape" },
      properties = { screen = 1, tag = "graph", maximized = false } },
    { rule = { class = "Pinentry" },
      properties = { floating = true } },
    { rule = { class = "Openshot" },
      properties = { screen = 1, tag = "graph", floating = false } },
    { rule = { class = "xpad" },
      properties = { floating = true, skip_taskbar = true } },
    { rule = { class = "mpv" },
      properties = { floating = true, skip_taskbar = true } },
    { rule = { class = "Gimp" },
      properties = { screen = 1, tag = "graph", floating = false, maximized = false } },
 }
end)
