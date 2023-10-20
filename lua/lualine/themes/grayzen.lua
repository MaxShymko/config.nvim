local colors = require("grayzen.colors")

local M = {}

M.normal = {
    a = { fg = colors.bg, bg = colors.cyan, gui = "bold" },
    b = { fg = colors.cyan, bg = colors.float },
    c = { fg = colors.fg, bg = colors.float },
    tabline = { fg = colors.cyan, bg = colors.float, gui = "bold" }
}

M.insert = {
    a = { fg = colors.gray, bg = colors.new_light_gray, gui = "bold" },
    b = { fg = colors.gray, bg = colors.float },
}

M.command = {
    a = { fg = colors.bg, bg = colors.yellow, gui = "bold" },
    b = { fg = colors.yellow, bg = colors.float },
}

M.visual = {
    a = { fg = colors.bg, bg = colors.info, gui = "bold" },
    b = { fg = colors.info, bg = colors.float },
}

M.replace = {
    a = { fg = colors.bg, bg = colors.dark_red, gui = "bold" },
    b = { fg = colors.dark_red, bg = colors.float },
}

M.inactive = {
    a = { fg = colors.gray, bg = colors.float, gui = "bold" },
    b = { fg = colors.gray, bg = colors.float },
    c = { fg = colors.gray, bg = colors.float },
    tabline = { fg = colors.gray, bg = colors.float }
}

return M
