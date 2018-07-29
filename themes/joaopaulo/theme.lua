local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local gears = require("gears")
local dpi = xresources.apply_dpi

local themes_path = "~/.config/awesome/themes/joaopaulo"

local theme = {}

-- Font Properties
theme.font          = "Roboto 10"

-- Theme colors
theme.bg_normal     = "#222d32"
theme.bg_focus      = "#222d32"
theme.bg_urgent     = "#CC575D"
theme.bg_minimize   = "#5294E2"
theme.bg_systray = theme.bg_normal
theme.fg_normal     = "#ffffff"
theme.fg_focus      = "#ffffff"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"

-- Gap between windows
theme.useless_gap   = dpi(0)
theme.border_width = dpi(0)

-- Tasklist
theme.tasklist_disable_icon = true

-- Generate taglist squares:
local taglist_square_size = dpi(6)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)

-- Little Hack to hide the titlebar text
-- theme.titlebar_fg = theme.bg_normal

-- Systray
theme.systray_icon_spacing = dpi(4)

-- Wallpaper
theme.wallpaper = "~/.config/awesome/awesome-wallpaper.png"

return theme
