local _M = {}

local awful = require'awful'
local beautiful = require'beautiful'

_M.layouts = {
   awful.layout.suit.tile, 
   awful.layout.suit.max, 
   awful.layout.suit.tile.bottom, 
   awful.layout.suit.floating, 
}

awful.tag.add("work", {
    icon = beautiful.tag_icon_term,
    layout             = awful.layout.suit.max,
    master_width_factor = 0.6,
    --gap_single_client  = true,
    --gap                = 15,
    screen             = 1,
    selected           = true,
  })

awful.tag.add("web", {
    icon = beautiful.tag_icon_web,
    layout = awful.layout.suit.max,
    --layout = awful.layout.suit.tile.bottom,
    --master_fill_policy = "master_width_factor",
    master_width_factor = 0.75,
    screen = 1,
  })

awful.tag.add("mail", {
    icon = beautiful.tag_icon_mail,
    layout = awful.layout.suit.tile,
    master_width_factor = 0.6,
    --master_fill_policy = "master_width_factor",
    screen = 1,
  })

awful.tag.add("im", {
    icon = beautiful.tag_icon_im,
    layout = awful.layout.suit.max,
    screen = screen:count(),
    --selected = true,
 })

awful.tag.add("media", {
    icon = beautiful.tag_icon_media,
    layout = awful.layout.suit.tile.bottom,
    master_fill_policy = "master_width_factor",
    master_width_factor = 0.66,
    screen = screen:count(),
  })

awful.tag.add("pdf", {
    icon = beautiful.tag_icon_pdf,
    layout = awful.layout.suit.max,
    master_fill_policy = "master_width_factor",
    screen = 1,
  })

awful.tag.add("graph", {
    icon = beautiful.tag_icon_graph,
    layout = awful.layout.suit.tile,
    --master_fill_policy = "master_width_factor",
    screen = 1,
  })

awful.tag.add("root", {
    icon = beautiful.tag_icon_root,
    layout = awful.layout.suit.max,
    master_fill_policy = "master_width_factor",
    screen = 1,
  })

awful.tag.add("term2", { -- hat icon
    icon = beautiful.tag_icon_term2,
    layout = awful.layout.suit.max,
    master_fill_policy = "master_width_factor",
    screen = 1,
  })

awful.tag.add("todo", {
    icon = beautiful.tag_icon_todo,
    layout = awful.layout.suit.max,
    screen = screen:count(),
  })

_M.tags = root.tags()



local function delete_tag()
  local t = awful.screen.focused().selected_tag
  if not t then return end
  t:delete()
end

local function add_tag()
  foo = #awful.screen.focused().tags + 1
  awful.tag.add(foo .. "_term",
    {
      screen= awful.screen.focused(),
      layout = awful.layout.suit.max,
      volatile = true,
    }):view_only()
end

local function rename_tag()
  awful.prompt.run {
    prompt       = "New tag name: ",
    textbox      = awful.screen.focused().mypromptbox.widget,
    exe_callback = function(new_name)
      if not new_name or #new_name == 0 then return end

      local t = awful.screen.focused().selected_tag
      if t then
        t.name = new_name
      end
    end
  }
end

local function move_to_new_tag()
	local c = client.focus
	if not c then return end

	local t = awful.tag.add(c.class,{screen= c.screen })
	c:tags({t})
	t:view_only()
end

local function copy_tag()
	local t = awful.screen.focused().selected_tag
	if not t then return end

	local clients = t:clients()
	local t2 = awful.tag.add(t.name, awful.tag.getdata(t))
	t2:clients(clients)
	t2:view_only()
end

return _M
