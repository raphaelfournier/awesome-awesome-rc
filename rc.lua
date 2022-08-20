-- awesome_mode: api-level=4:screen=on

-- load luarocks if installed
pcall(require, 'luarocks.loader')

-- home variable
home_var        = os.getenv("HOME")

-- user preferences
terminal    = "alacritty"
editor      = "vim"
editor_cmd  = terminal .. " -e " .. editor
web         = "firefox"
files       = "thunar"
username = os.getenv("USER"):gsub("^%l", string.upper)

-- load modules
require("modules")

-- load theme
require("theme")

-- load key and mouse bindings
require("bindings")

-- load rules
require("rules")

-- load signals
require("signals")
