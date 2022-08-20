-------------------------------------------------
-- DemoMode button for Awesome Window Manager
-- Turns off notifications and send a heartbeat to xscreensaver

-- @author Raphaël Fournier-S'niehotta
-- @copyright 2018 Raphaël Fournier-S'niehotta
-------------------------------------------------

local wibox         = require("wibox")
local watch         = require("awful.widget.watch")
local awful         = require("awful")
local beautiful     = require("beautiful")
local naughty       = require("naughty")
local gears         = require("gears")

--local XSCREENSAVER_DEACTIVATE_COMMAND = "xscreensaver-command -deactivate"
local XSCREENSAVER_DEACTIVATE_COMMAND = "xdotool mousemove_relative 1 1 restore"
local STRETCHLY_DEACTIVATE_COMMAND = "stretchly reset"
local XSCREENSAVER_TIMER = 19
local iconpath = "/home/raph/.config/awesome/themes/myzenburn/demomode.png"

local mytimer = gears.timer {
    timeout   = XSCREENSAVER_TIMER,
    --autostart = true,
    --call_now = true,
    --single_shot = true,
    callback  = function()
        awful.spawn(XSCREENSAVER_DEACTIVATE_COMMAND)
        awful.spawn(STRETCHLY_DEACTIVATE_COMMAND)
        --naughty.notify{ 
         --title= "notif suspended",
         --text = "naughty works:".. tostring(not naughty.is_suspended()),
         --ignore_suspend = true,
       --}
      end,
}

local demoMode_widget = wibox.widget {
  wibox.widget {
      image  = beautiful.demomode_icon or iconpath,
      resize = true,
      widget = wibox.widget.imagebox
    },
    shape        = gears.shape.rounded_bar,
    widget = wibox.container.background,
    }

--watch(XSCREENSAVER_DEACTIVATE_COMMAND, XSCREENSAVER_TIMER, demoMode_widget)

function demoModeReleased()
  mytimer:stop()
end

function demoModeActivated()
  mytimer:start()
end

demoMode_widget:buttons(
  awful.util.table.join(
    awful.button({ }, 1, function () 
      naughty.toggle()
      if naughty.is_suspended() then
        demoModeActivated()
        demoMode_widget.bg =  beautiful.default_focus
      else
        demoModeReleased()
        demoMode_widget.bg =  beautiful.wibar_bg
      end
    end)
  )
)


return demoMode_widget
