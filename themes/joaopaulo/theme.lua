local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local gears = require("gears")

local dpi = xresources.apply_dpi

local themes_path = os.getenv("HOME") .. "/.config/awesome/themes/joaopaulo"
local theme = {}

-- Font Properties
theme.font          = "Roboto 10"

-- Theme colors
theme.fg_normal                                 = "#FEFEFE"
theme.fg_focus                                  = "#32D6FF"
theme.fg_urgent                                 = "#C83F11"
theme.bg_normal                                 = "#222222"
theme.bg_focus                                  = "#1E2320"
theme.bg_urgent                                 = "#3F3F3F"
theme.taglist_fg_focus                          = "#00CCFF"
theme.tasklist_bg_focus                         = "#222222"
theme.tasklist_fg_focus                         = "#00CCFF"
theme.border_width                              = 1
theme.border_normal                             = "#3F3F3F"
theme.border_focus                              = "#6F6F6F"
theme.border_marked                             = "#CC9393"
theme.titlebar_bg_focus                         = "#3F3F3F"
theme.titlebar_bg_normal                        = "#3F3F3F"
theme.titlebar_bg_focus                         = theme.bg_focus
theme.titlebar_bg_normal                        = theme.bg_normal
theme.titlebar_fg_focus                         = theme.fg_focus
theme.bg_systray = theme.bg_normal

-- Icon
theme.widget_ac                                 = themes_path .. "/icons/ac.png"
theme.widget_battery                            = themes_path .. "/icons/battery.png"
theme.widget_battery_low                        = themes_path .. "/icons/battery_low.png"
theme.widget_battery_empty                      = themes_path .. "/icons/battery_empty.png"
theme.widget_mem                                = themes_path .. "/icons/mem.png"
theme.widget_cpu                                = themes_path .. "/icons/cpu.png"
theme.widget_temp                               = themes_path .. "/icons/temp.png"
theme.widget_net                                = themes_path .. "/icons/net.png"


-- Layout icons
-- You can use your own layout icons like this:
theme.layout_fairh = themes_path.."/layouts/fairhw.png"
theme.layout_fairv = themes_path.."/layouts/fairvw.png"
theme.layout_floating  = themes_path.."/layouts/floatingw.png"
theme.layout_magnifier = themes_path.."/layouts/magnifierw.png"
theme.layout_max = themes_path.."/layouts/maxw.png"
theme.layout_fullscreen = themes_path.."/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path.."/layouts/tilebottomw.png"
theme.layout_tileleft   = themes_path.."/layouts/tileleftw.png"
theme.layout_tile = themes_path.."/layouts/tilew.png"
theme.layout_tiletop = themes_path.."/layouts/tiletopw.png"
theme.layout_spiral  = themes_path.."/layouts/spiralw.png"
theme.layout_dwindle = themes_path.."/layouts/dwindlew.png"
theme.layout_cornernw = themes_path.."/layouts/cornernww.png"
theme.layout_cornerne = themes_path.."/layouts/cornernew.png"
theme.layout_cornersw = themes_path.."/layouts/cornersww.png"
theme.layout_cornerse = themes_path.."/layouts/cornersew.png"

-- Gap between windows
theme.useless_gap   = dpi(0)
theme.border_width = dpi(0)

-- Tasklist
theme.tasklist_disable_icon = true

-- Little Hack to hide the titlebar text
-- theme.titlebar_fg = theme.bg_normal

-- Systray
theme.systray_icon_spacing = dpi(4)

-- Wallpaper
theme.wallpaper = "~/.config/awesome/awesome-wallpaper.png"

return theme
