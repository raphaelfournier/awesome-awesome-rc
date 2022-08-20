local awful = require'awful'

local tags = require'config.tags'

awful.layout.layouts = tags.layouts

--tag.connect_signal('request::default_layouts', function()
   --awful.layout.append_default_layouts(tags.layouts)
--end)
