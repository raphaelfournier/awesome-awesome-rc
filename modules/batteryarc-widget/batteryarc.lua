local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")
local wibox = require("wibox")
local watch = require("awful.widget.watch")

local HOME = os.getenv("HOME")

-- only text
local text = wibox.widget {
    id = "txt",
    font = "Play 8",
    widget = wibox.widget.textbox
}

-- mirror the text, because the whole widget will be mirrored after
local mirrored_text = wibox.container.mirror(text, { horizontal = true })

-- mirrored text with background
local mirrored_text_with_background = wibox.container.background(mirrored_text)

local batteryarc = wibox.widget {
    mirrored_text_with_background,
    max_value = 1,
    rounded_edge = true,
    thickness = beautiful.arcwidgets_thickness,
    start_angle = 4.71238898, -- 2pi*3/4
    forced_height = 32,
    forced_width = 32,
    bg = beautiful.fg_normal, -- bg for the arcchart
    paddings = 4,
    widget = wibox.container.arcchart,
    set_value = function(self, value)
        self.value = value
    end,
}

-- mirror the widget, so that chart value increases clockwise
local batteryarc_widget = wibox.container.mirror(batteryarc, { horizontal = true })

watch("acpi", 30,
    function(widget, stdout, stderr, exitreason, exitcode)
        local batteryType
        local _, status, charge_str, time = string.match(stdout, '(.+): (%a+), (%d?%d%d)%%,? ?.*')
        local charge = tonumber(charge_str)
        widget.value = charge / 100
        if status == 'Charging' then
            mirrored_text_with_background.fg = beautiful.widget_green
        else
          mirrored_text_with_background.bg = beautiful.widget_transparent
          mirrored_text_with_background.fg = beautiful.widget_main_color
        end

        if charge <= 12 then
            batteryarc.colors = { beautiful.border_marked }
            if status == 'Charging' then
              batteryarc.colors = { beautiful.widget_green }
            end
            --mirrored_text_with_background.bg = beautiful.border_marked
            mirrored_text_with_background.fg = beautiful.fg_normal
            show_battery_warning()
        elseif charge > 12 and charge < 25 then
            batteryarc.colors = { beautiful.widget_yellow }
            if status == 'Charging' then
              batteryarc.colors = { beautiful.widget_green }
            end
            --mirrored_text_with_background.bg = beautiful.widget_yellow
            mirrored_text_with_background.fg = beautiful.widget_yellow
        elseif charge < 100 then
            if status == 'Charging' then
              batteryarc.colors = { beautiful.widget_green }
            --mirrored_text_with_background.bg = beautiful.bg_normal
            mirrored_text_with_background.fg = beautiful.fg_normal
            else
              batteryarc.colors = { beautiful.widget_main_color }
            end
        else
            batteryarc.colors = { beautiful.widget_main_color }
        end

        if charge == 100 then
          --text.text = string.format("%03d", charge)
          text.text = "OK"
          text.font = beautiful.arcwidgets_font .. " " .. beautiful.arcwidgets_fontsize
        else
          text.text = charge
          text.font = beautiful.arcwidgets_font .. " " .. beautiful.arcwidgets_fontsize
        end
    end,
    batteryarc)

-- Popup with battery info
-- One way of creating a pop-up notification - naughty.notify
local notification
function show_battery_status()
    awful.spawn.easy_async([[bash -c 'acpi']],
        function(stdout, _, _, _)
            notification = naughty.notify {
                text = stdout,
                title = "Battery status",
                timeout = 5,
                hover_timeout = 0.5,
            }
        end)
end

batteryarc:connect_signal("mouse::enter", function() show_battery_status() end)
batteryarc:connect_signal("mouse::leave", function() naughty.destroy(notification) end)

-- Alternative to naughty.notify - tooltip. You can compare both and choose the preferred one

--battery_popup = awful.tooltip({objects = {battery_widget}})

-- To use colors from beautiful theme put
-- following lines in rc.lua before require("battery"):
-- beautiful.tooltip_fg = beautiful.fg_normal
-- beautiful.tooltip_bg = beautiful.bg_normal

--[[ Show warning notification ]]
function show_battery_warning()
    naughty.notify {
        preset = naughty.config.presets.critical,
        icon = "/usr/share/icons/Arc/emblems/128/emblem-danger.png",
        icon_size = 200,
        text = "La batterie est bientôt épuisée !",
        title = "ATTENTION !",
        timeout = 5,
        hover_timeout = 0.5,
        position = "bottom_right",
    }
end

return batteryarc_widget
