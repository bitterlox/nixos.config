-- cycle these themes randomly

local darkcolorfuns = {}
local lightcolorfuns = {}

local addtheme = function(tbl, themeName, themefn)
  tbl[themeName] = themefn
end

-- dark themes --

addtheme(darkcolorfuns, "rose-pine", function()
  local color = color or "rose-pine"
  vim.cmd.colorscheme(color)
  --  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  --  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end)

addtheme(darkcolorfuns, "adwaita", function()
  local color = color or "adwaita"
  vim.g.adwaita_darker = true
  vim.cmd.colorscheme(color)
  --  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  --  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end)
addtheme(darkcolorfuns, "sonokai", function()
  local color = color or "sonokai"
  vim.g.sonokai_style = "espresso"
  vim.cmd.colorscheme(color)
end)

addtheme(darkcolorfuns, "citruszest", function()
  local color = color or "citruszest"
  vim.cmd.colorscheme(color)
end)

addtheme(darkcolorfuns, "caret", function()
  local color = color or "caret"
  vim.cmd.colorscheme(color)
end)

addtheme(darkcolorfuns, "melange", function()
  local color = color or "melange"
  vim.cmd.colorscheme(color)
end)

-- light themes --

--addtheme(lightcolorfuns, function()
--  local color = color or "rose-pine"
--
--  vim.o.background = "light"
--
--  vim.cmd.colorscheme(color)
--end)

--addtheme(lightcolorfuns, function()
--  local color = color or "adwaita"
--
--  vim.o.background = "light"
--
--  vim.cmd.colorscheme(color)
--end)

-- addtheme(lightcolorfuns, function()
--   local color = color or "dayfox"
--   vim.cmd.colorscheme(color)
-- end)
--
-- addtheme(lightcolorfuns, function()
--   local color = color or "dawnfox"
--   vim.cmd.colorscheme(color)
-- end)

local datetable = os.date("*t")
local isnighttime = datetable.hour > 20


-- if isnighttime then
--   local idx = require("math").fmod(tonumber(datetable.day), #darkcolorfuns) + 1
--   todaystheme = darkcolorfuns[idx]
-- else
--   local idx = require("math").fmod(tonumber(datetable.day), #lightcolorfuns) + 1
--   todaystheme = lightcolorfuns[idx]
-- end

local function getThemeIndex(themeCount, yday)
  return require("math").fmod(
    math.floor(yday / 7),
    themeCount
  ) + 1
end

vim.cmd("set termguicolors")

local pickTheme = function(idx)
  local keys = vim.tbl_keys(darkcolorfuns)
  table.sort(keys)

  local themeName = keys[idx]

  return themeName
end

-- for i = 1, 365, 1 do
--   local tidx = getThemeIndex(
--     #vim.tbl_keys(darkcolorfuns),
--     i
--   )
--   print(i, pickTheme(tidx))
-- end

local selectTheme = function(idx)
  local theme = pickTheme(idx)
  darkcolorfuns[theme]()
  print("selected theme", theme)
end

local themeCount = #vim.tbl_keys(darkcolorfuns)
local themeIdx = getThemeIndex(
  themeCount,
  tonumber(datetable.yday)
)

selectTheme(themeIdx)

vim.api.nvim_create_user_command("SwitchTheme", function()
  themeIdx = themeIdx + 1
  if themeCount < themeIdx then
    themeIdx = 1
  end
  selectTheme(themeIdx)
end, {})

vim.api.nvim_create_user_command("GetTheme", function()
  local theme = pickTheme(themeIdx)
  print("selected theme", theme)
end, {})
