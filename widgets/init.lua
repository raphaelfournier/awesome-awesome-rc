local _M = {}

local awful = require'awful'
local gears = require'gears'
local hotkeys_popup = require'awful.hotkeys_popup'
local beautiful = require'beautiful'
local wibox = require'wibox'

local apps = require'config.apps'
local mod = require'bindings.mod'

local mpdarc_widget     = require("modules.mpdarc-widget.mpdarc")
local batteryarc_widget = require("modules.batteryarc-widget.batteryarc")
local volumearc_widget  = require("modules.volumearc-widget.volumearc")
local demoMode_widget   = require("modules.demomode-widget.demomode") -- teaching mode


function find_empty_tag()
   local s = awful.screen.focused()
   for i = 1, #s.tags do
      local tag = s.tags[i]
      if next(tag:clients()) == nil then return i end
   end
end

-- {{{ menus
_M.awesomemenu = {
   { "hotkeys", function() return false, hotkeys_popup.show_help end},
   { "manual", terminal .. " -e man awesome" },
   { "arandr", function() awful.util.spawn("arandr") end},
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end}
}

_M.followcursormenu = {
   {"start follow", function() awful.util.spawn("find-cursor --repeat 0 --follow --distance 1 --wait 1000 --line-width 18 --size 18 --color red") end },
   {"stop follow", function() awful.util.spawn("killall find-cursor") end },
}

_M.mainmenu = awful.menu({ items = { { "awesome", _M.awesomemenu, icon=beautiful.awesome_icon },
         { "set config", configsets },
         { "coffee break", function() awful.util.spawn(apps.screenlock_cmd) end, beautiful.coffee },
         { "insideOutside", function() awful.util.spawn_with_shell("bash ~/.scripts/insideOutside.sh") end },
         { "cursor", _M.followcursormenu, beautiful.menu_submenu_icon },
         { "blockOnTag", function(self) 
               tagBlocked = not tagBlocked
               if tagBlocked then
                  _M.launcher.image = gears.color.recolor_image(beautiful.awesome_icon, beautiful.fg_urgent)
                  local s = awful.screen.focused()
                  local i = find_empty_tag()
                  local tag = s.tags[i]
                  if tag then
                     tag:view_only()
                  end
               else
                  _M.launcher.image = beautiful.awesome_icon
               end
            end },
            { "open terminal", terminal }
         }
      }
      )

_M.launcher = awful.widget.launcher({ image = beautiful.awesome_icon,
   menu = _M.mainmenu })

--- }}}

--_M.keyboardlayout = awful.widget.keyboardlayout()
_M.textclock = wibox.widget.textclock("%a %d %H:%M")
_M.textclock.font = "Inconsolata Medium 14"

function _M.create_promptbox() return awful.widget.prompt() end

--- {{{ layoutbox
function _M.create_layoutbox(s)
   return awful.widget.layoutbox{
      screen = s,
      buttons = {
         awful.button{
            modifiers = {},
            button    = 1,
            on_press  = function() awful.layout.inc(1) end,
         },
         awful.button{
            modifiers = {},
            button    = 3,
            on_press  = function() awful.layout.inc(-1) end,
         },
         awful.button{
            modifiers = {},
            button    = 4,
            on_press  = function() awful.layout.inc(-1) end,
         },
         awful.button{
            modifiers = {},
            button    = 5,
            on_press  = function() awful.layout.inc(1) end,
         },
      }
   }
end
--- }}}

--- {{{ taglist
local taglist_buttons = awful.util.table.join(
   awful.button({ }, 1, function(t) 
      if not tagBlocked then
         t:view_only() 
      end
   end),
   awful.button({ modkey }, 1, function(t)
      if client.focus then
         client.focus:move_to_tag(t)
      end
   end),
   --awful.button({ }, 2, function(t) naughty.notify{ title="tag debug", text = t.name } end),
   awful.button({ }, 3, function(t) 
      if not tagBlocked then
         awful.tag.viewtoggle()
      end
   end),
   awful.button({ modkey }, 3, function(t)
      if client.focus then
         client.focus:toggle_tag(t)
      end
   end),
   awful.button({ }, 4, function(t) 
      if not tagBlocked then
         awful.tag.viewnext(t.screen) 
      end
   end),
   awful.button({ }, 5, function(t) 
      if not tagBlocked then
         awful.tag.viewprev(t.screen) 
      end
   end)
   )

function _M.create_taglist(s)
   return {
      {
         awful.widget.taglist {
            screen  = s,
            filter  = awful.widget.taglist.filter.noempty,
            style   = {
               shape        = gears.shape.rounded_bar,
               spacing = 2,
            },
            widget_template = 
            {
               {
                  {
                     {
                        id     = 'index_role',
                        font = "Inconsolata Medium 16",
                        widget = wibox.widget.textbox,
                     },
                     {
                        id     = 'icon_role',
                        widget = wibox.widget.imagebox,
                     },
                     layout  = wibox.layout.fixed.horizontal,
                     spacing = 0,
                  },
                  left = 0,
                  right = 4,
                  widget  = wibox.container.margin,
               },
               id     = 'background_role',
               bg     = beautiful.bg_focus .. "00",
               widget = wibox.container.background,

               create_callback = function(self, c3, index, objects)
                  local tooltip = awful.tooltip({
                        objects = { self },
                        timer_function = function()
                           return c3.index .. ": " .. c3.name .. " | " .. c3.layout.name
                        end,
                        delay_show = 0.6
                     })
                  -- Then you can set tooltip props if required
                  tooltip.margins_leftright = 8
                  tooltip.margins_topbottom = 4

                  self:get_children_by_id('index_role')[1].markup = '<b> '..tostring(c3.index%10)..' </b>'

                  --self:connect_signal('mouse::enter', function()
                        --self.bgbackup     = self.bg
                        --self.fgbackup     = self.fg
                        --self.has_backup = true
                        --self.bg = beautiful.fg_focus
                        --self.fg = beautiful.bg_normal
                        --end)
                        --self:connect_signal('mouse::leave', function()
                              --self.bg = self.bgbackup 
                              --self.fg = self.fgbackup 
                              --end)
                           end,

                           update_callback = function(self, c3, index, objects)
                              self:get_children_by_id('index_role')[1].markup = '<b> '..tostring(c3.index%10)..' </b>'
                           end,
                        },
                        buttons = taglist_buttons
                     },
                     shape        = gears.shape.rounded_bar,
                     bg           = beautiful.tasklist_bg_normal .. "00",
                     fg           = beautiful.tasklist_fg_normal, -- couleurs des chiffres des tags
                     widget = wibox.container.background,
                  },
                  right =8,
                  widget = wibox.container.margin
      }
end
--- }}}

--- {{{ tasklist
local tasklist_buttons = awful.util.table.join(
   awful.button({ }, 1, function (c)
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
   end),
   awful.button({ }, 2, function (c) 
      if not tagBlocked then
         c:kill() 
      end
   end),
   awful.button({ }, 3, function (c) rofi.client_flags(c) end),
   --awful.button({ }, 3, client_menu_toggle_fn()),
   awful.button({ }, 4, function ()
      if not tagBlocked then
         awful.client.focus.byidx(1)
      end
   end),
   awful.button({ }, 5, function ()
      if not tagBlocked then
         awful.client.focus.byidx(-1)
      end
   end))

function _M.create_tasklist(s)
   return awful.widget.tasklist {
      screen   = s,
      filter   = awful.widget.tasklist.filter.currenttags,
      buttons  = tasklist_buttons,
      layout   = {
         spacing = 8,
         layout  = wibox.layout.flex.horizontal
      },
      widget_template = {
         {
            {
               {
                  {
                     id     = 'icon_role',
                     widget = wibox.widget.imagebox,
                  },
                  --margins = 4,
                  left = 4,
                  right = 6,
                  widget  = wibox.container.margin,
               },
               {
                  id     = 'text_role',
                  widget = wibox.widget.textbox,
               },
               layout = wibox.layout.fixed.horizontal,
            },
            left  = 4,
            right = 4,
            widget = wibox.container.margin
         },
         id     = 'background_role',
         widget = wibox.container.background,
         create_callback = function(self, client, index, objects)
            local tooltip = awful.tooltip({
                  objects = { self },
                  timer_function = function()
                     return client.name .. " | " .. tostring(client.width) .. "x" .. tostring(client.height)
                  end,
                  delay_show = 0.6
               })
            -- Then you can set tooltip props if required
            tooltip.margins_leftright = 8
            tooltip.margins_topbottom = 4
         end
      },
   }
end
--- }}}

--- {{{ calendar for clock
local styles = {}
local function rounded_shape(size, partial)
    if partial then
        return function(cr, width, height)
                   gears.shape.partially_rounded_rect(cr, width, height,
                        false, true, false, true, 5)
               end
    else
        return function(cr, width, height)
                   gears.shape.rounded_rect(cr, width, height, size)
               end
    end
end

styles.month   = { 
  padding      = 5, 
  bg_color     = beautiful.fg_normal or '#555555', 
  border_width = 2, 
  --shape        = rounded_shape(10)
}
styles.normal  = { shape    = rounded_shape(5), }
styles.focus   = { fg_color = beautiful.fg_focus or '#000000',
                   bg_color = beautiful.default_focus or '#ff9800',
                   markup   = function(t) return '<b>' .. t .. '</b>' end,
                   shape    = rounded_shape(5, true)
}
styles.header  = { fg_color = beautiful.fg_normal,
                   bg_color = beautiful.default_focus or '#ff9800',
                   markup   = function(t) return '<b>' .. t .. '</b>' end,
                   shape    = rounded_shape(10)
}
styles.weeknumber = { fg_color = beautiful.fg_urgent,
                   markup   = function(t) return '<b>' .. t .. '</b>' end,
                   shape    = rounded_shape(5)
}
styles.weekday = { fg_color = '#7788af',
                   markup   = function(t) return '<b>' .. t .. '</b>' end,
                   shape    = rounded_shape(5)
}

local month_calendar = awful.widget.calendar_popup.month(
{
  bg=beautiful.fg_normal,
  week_numbers=true,
  start_sunday=false,
  long_weekdays=false,
  style_month=styles.month,
	style_header=styles.header,
	style_weekday=styles.weekday,
	style_weeknumber=styles.weeknumber,
	style_normal=styles.normal,
	style_focus=styles.focus,
})
month_calendar:attach(_M.textclock, "tr", {on_hover=true} )
--- }}}

--- {{{ wibox
function _M.create_wibox(s)
   return awful.wibar{
      screen = s,
      position = 'top',
      widget = {
         layout = wibox.layout.align.horizontal,
         -- left widgets
         {
            layout = wibox.layout.fixed.horizontal,
            _M.launcher,
            s.layoutbox,
            _M.demoMode_widget,
            s.promptbox,
            s.taglist,
         },
         -- middle widgets
         s.tasklist,
         -- right widgets
         --{
            --layout = wibox.layout.fixed.horizontal,
            --_M.keyboardlayout,
            --_M.demoMode_widget,
            --mpdarc_widget,
            --volumearc_widget,
            --batteryarc_widget,
            --_M.textclock,
            --wibox.widget.systray(),
         --}
			{ 
        layout = wibox.layout.fixed.horizontal,
        spacing       = 2,
        {
          {
            wibox.widget {
              smallspace,
              mpdarc_widget,
            demoMode_widget,
              volumearc_widget,
              batteryarc_widget,
              smallspace,
              layout  = wibox.layout.fixed.horizontal,
              spacing       = 4,
            },
            shape        = gears.shape.rounded_bar,
            bg           = beautiful.tasklist_bg_normal,
            fg           = beautiful.tasklist_fg_normal,
            widget       = wibox.container.background
          },
          left = 4,
          widget       = wibox.container.margin
        },
        {
					{
						_M.textclock,
						left   = 5,  -- space between border of shape and text
						right  = 5,
						top    = 3,
						bottom = 3,
						widget = wibox.container.margin
					},
					shape        = gears.shape.rounded_bar,
					bg           = beautiful.tasklist_bg_normal,
					fg           = beautiful.tasklist_fg_normal,
					widget       = wibox.container.background
				},
        {
             {
                wibox.widget.systray(),
                left   = 10,
                right  = 10,
              top    = 3,
              bottom = 3,
              widget = wibox.container.margin
            },
            shape        = gears.shape.rounded_bar,
            bg           = beautiful.tasklist_bg_normal,
            fg           = beautiful.tasklist_fg_normal,
            widget       = wibox.container.background
        }
			},
      }
   }
end
--- }}}

return _M

-- vim: set fdm=marker fmr={{{,}}} fdl=0:fdc=2
