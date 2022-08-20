local awful = require'awful'
local beautiful = require'beautiful'
require'awful.autofocus'
local wibox = require'wibox'

client.connect_signal('mouse::enter', function(c)
   c:activate{context = 'mouse_enter', raise = false}
end)

client.connect_signal('request::titlebars', function(c)
   -- buttons for the titlebar
   local buttons = {
      awful.button{
         modifiers = {},
         button    = 1,
         on_press  = function()
            c:activate{context = 'titlebar', action = 'mouse_move'}
         end
      },
      awful.button{
         modifiers = {},
         button    = 3,
         on_press  = function()
            c:activate{context = 'titlebar', action = 'mouse_resize'}
         end
      },
   }

   awful.titlebar(c).widget = {
      -- left
      {
         awful.titlebar.widget.iconwidget(c),
         buttons = buttons,
         layout  = wibox.layout.fixed.horizontal,
      },
      -- middle
      {
         -- title
         {
            align = 'center',
            widget = awful.titlebar.widget.titlewidget(c),
         },
         buttons = buttons,
         layout  = wibox.layout.flex.horizontal,
      },
      -- right
      {
         awful.titlebar.widget.floatingbutton(c),
         awful.titlebar.widget.maximizedbutton(c),
         awful.titlebar.widget.stickybutton(c),
         awful.titlebar.widget.ontopbutton(c),
         awful.titlebar.widget.closebutton(c),
         layout = wibox.layout.fixed.horizontal()
      },
      layout = wibox.layout.align.horizontal,
   }
end)

client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    --if slave then awful.client.setslave(c) end
    
    -- Coins arrondis pour les fenêtres
    --if not c.fullscreen then
      --c.shape = function(cr,w,h)
          --gears.shape.rounded_rect(cr,w,h,20)
      --end
    --end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end

    c.original_tags = c:tags()
    c.original_screen = c.screen
end)

client.connect_signal("manage", function(c)
  local currentTag = awful.tag.selected(1).name
  local clientTag = c.first_tag.name
  if (clientTag ~= currentTag) and not awesome.startup then
    naughty.notification({title = (c.name or "Application") .. " started", text = "on tag " .. clientTag  , width=300, height=100})
  end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

client.connect_signal("focus", function(c) 
  c.border_color = beautiful.border_focus 
  c.opacity = 1
end)

client.connect_signal("unfocus", function(c) 
  c.border_color = beautiful.border_normal 
  c.opacity = 0.7
end)

