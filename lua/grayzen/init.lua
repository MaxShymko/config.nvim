local util = require("grayzen.util")

local M = {}

function M.setup()
    M.load(true)
end

function M.load(exec_autocmd)
    local colors = require("grayzen.colors")
    util.load(colors, exec_autocmd)
end

return M
