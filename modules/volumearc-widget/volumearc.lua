-------------------------------------------------
-- Volume Arc Widget for Awesome Window Manager
-- Shows the current volume level
-- More details could be found here:
-- https://github.com/streetturtle/awesome-wm-widgets/tree/master/volumearc-widget

-- @author Pavel Makhov
-- @copyright 2017 Pavel Makhov
-------------------------------------------------

local awful = require("awful")
local beautiful = require("beautiful")
local spawn = require("awful.spawn")
local watch = require("awful.widget.watch")
local wibox = require("wibox")
local gears = require("gears")

local GET_VOLUME_CMD = 'amixer -D pulse sget Master'
--local INC_VOLUME_CMD = 'amixer -q -c 0 sset Master 2dB+'
local INC_VOLUME_CMD = 'pamixer --increase 4'
--local DEC_VOLUME_CMD = 'amixer -q -c 0 sset Master 2dB-'
local DEC_VOLUME_CMD = 'pamixer --decrease 4'
--local TOG_VOLUME_CMD = 'amixer -D pulse sset Master toggle'
local TOG_VOLUME_CMD = 'pamixer -t'
local MIXER_CMD = 'urxvtc -e bash -c "alsamixer -c0"'

local volume_menu = {}
--local table_len = 0 -- keep track of table length
local vol_menu
local shown = false

local text = wibox.widget {
    id = "txt",
    font = "Inconsolata Medium 10",
    widget = wibox.widget.textbox
}
-- mirror the text, because the whole widget will be mirrored after
--local mirrored_text = wibox.container.margin(wibox.container.mirror(text, { horizontal = true }))
--mirrored_text.right = 2 -- pour centrer le texte dans le rond
--
local mirrored_text = wibox.container.mirror(text, { horizontal = true})

-- mirrored text with background
local mirrored_text_with_background = wibox.container.background(mirrored_text)

local volumearc = wibox.widget {
    id = "volumearc",
    mirrored_text_with_background,
    max_value = 1,
    start_angle = 4.71238898, -- 2pi*3/4
    thickness = beautiful.arcwidgets_thickness,
    forced_height = 32,
    forced_width = 32,
    rounded_edge = true,
    bg = "#ffffff11",
    paddings = 4,
    widget = wibox.container.arcchart
}

--local volumearc_widget = wibox.container.margin(wibox.container.mirror(volumearc, { horizontal = true }))
--volumearc_widget.margins = 4
--local mirrored_text = wibox.container.margin(wibox.container.mirror(text, { horizontal = true }))
--mirrored_text.right = 2 -- pour centrer le texte dans le rond
local volumearc_widget = wibox.container.mirror(volumearc, { horizontal = true })

local update_graphic = function(widget, stdout, _, _, _)
    local mute = string.match(stdout, "%[(o%D%D?)%]")
    local volume1 = string.match(stdout, "(%d?%d?%d)%%")
    volume = tonumber(string.format("% 3d", volume1))
    volumepad = tonumber(string.format("% 3d", volume1))

    widget.value = volume / 100;
    if mute == "off" then
        widget.colors = { beautiful.widget_red }
    else
        widget.colors = { beautiful.widget_main_color }
    end
    if volume >= 100 then
        text.font = beautiful.arcwidgets_font .. " " .. beautiful.arcwidgets_fontsize
        text.text = " T "
    else
      text.text = string.format("%02d", volumepad)
      text.font = beautiful.arcwidgets_font .. " " .. beautiful.arcwidgets_fontsize
    end
end

--local function update_volume()
    --awful.spawn.easy_async_with_shell("pamixer --get-volume-human", function(stdout)
        --if not string.match(stdout, 'muted') then
            --local volume_out = stdout:gsub('%%', '') -- remove percentage
            --volume:get_children_by_id("textbox")[1].text = "V: " .. volume_out
            --volume:get_children_by_id("bar")[1].value    = tonumber(volume_out)
            --muted = false
        --else
            --muted               = true
            ----volume:get_children_by_id("textbox")[1].text = "V: Muted"
        --end
    --end)
--end
--
local function sink_menu()
  awful.spawn.easy_async_with_shell("pamixer --list-sinks | cut -f 1,3- -d ' '", function(out)
      awful.spawn.easy_async_with_shell("pamixer --list-sinks | cut -f 1,3- -d ' ' | grep -E '[0-9]' | cut -f 1 -d ' '", function(stdout)
          volume_menu = {} -- reset the table
          for s in stdout:gmatch("[^\r\n]+") do
            -- Lua hates tables at 0 yet pamixer starts at 0... add 1 to each index
            if not volume_menu[tonumber(s) + 1] then
              volume_menu[tonumber(s) + 1] = 0
              --table_len = table_len + 1
            else
              volume_menu[tonumber(s) + 1] = volume_menu[tonumber(s) + 1] + 1
            end
          end
        end)
        sink = out
      end)
      return sink
    end

volumearc:connect_signal("button::press", function(_, _, _, button)
    if (button == 4) then awful.spawn(INC_VOLUME_CMD, false)
    elseif (button == 5) then awful.spawn(DEC_VOLUME_CMD, false)
    elseif (button == 1) then awful.spawn(TOG_VOLUME_CMD, false)
    elseif (button == 3) then 
          sink_menu() -- parses list of sinks, populates volume_menu
          local volume_items = {}
          for k,v in pairs(volume_menu) do
              local index = tonumber(k) - 1 -- counteract our padding earlier of the index
              local string = "Sink " .. index
              local cmd = "pactl set-default-sink " .. index
              table.insert(volume_items,  {string, function() awful.spawn(cmd) end} )
        end
        if shown == false then
          vol_menu = awful.menu(volume_items)
            shown = true
            -- Start a timer to autoclose the menu
            gears.timer {
                timeout = 2,
                autostart = true,
                single_shot = true,
                callback = function()
                    vol_menu:hide()
                    shown = false
                end
            }
            vol_menu:show()
        end
    elseif (button == 2) then 
      local matcher = function (c)
        return awful.rules.match(c, {class = "Pavucontrol"})
      end
      awful.client.run_or_raise('pavucontrol', matcher)
    end

    spawn.easy_async(GET_VOLUME_CMD, function(stdout, stderr, exitreason, exitcode)
        update_graphic(volumearc, stdout, stderr, exitreason, exitcode)
    end)
end)

local volume_t = awful.tooltip {
    objects = {volumearc}, -- Attach tooltip to slider
    timer_function = sink_menu()
    --timer_function = function()
        --local a = awful.spawn.easy_async_with_shell("pactl list short | grep RUNNING | cut -f1")
    --end
}

watch(GET_VOLUME_CMD, 1, update_graphic, volumearc)

return volumearc_widget
