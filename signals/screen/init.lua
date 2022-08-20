local awful = require'awful'
local gears = require'gears'
local beautiful = require'beautiful'
local wibox = require'wibox'

local tags = require'config.tags'
local widgets = require'widgets'

function set_wallpaper(s)
  if beautiful.wallpaper then
    local wallpaper = beautiful.wallpaper
    --local wallpaper2 = beautiful.wallpaper2
    -- If wallpaper is a function, call it with the screen
    if type(wallpaper) == "function" then
      wallpaper = wallpaper(s)
    end
    for i = 1, screen.count() do
      if i < 2 then
        gears.wallpaper.maximized(wallpaper, i, true)
      elseif s.geometry.height < s.geometry.width then -- it's the second screen
          gears.wallpaper.maximized(beautiful.wallpaperlandscape, s, true)
      else
        gears.wallpaper.maximized(beautiful.wallpaperportrait, s, true)
      end
    end
  end
end

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

local function set_taglist(s)
			s.mytaglist = 
			{
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

screen.connect_signal('request::wallpaper', function(s)
   awful.wallpaper{
      screen = s,
      widget = {
         {
            image     = beautiful.wallpaper,
            upscale   = true,
            downscale = true,
            widget    = wibox.widget.imagebox,
         },
         valign = 'center',
         halign = 'center',
         tiled = false,
         widget = wibox.container.tile,
      }
   }
end)

screen.connect_signal('request::desktop_decoration', function(s)
   tags.tags,
   s.promptbox = widgets.create_promptbox()
   s.layoutbox = widgets.create_layoutbox(s)
   s.taglist   = widgets.create_taglist(s)
   s.tasklist  = widgets.create_tasklist(s)
   s.wibox     = widgets.create_wibox(s)
end)

--screen.connect_signal("list", awesome.restart)

-- vim: set fdm=marker fmr={{{,}}} fdl=0:fdc=2
