terminal = "alacritty"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor
modkey = "Mod4"

require("configuration.binds")
require("configuration.layout")
