local util = {}
local forest = require('forest.theme')

-- Go trough the table and highlight the group with the color values
util.highlight = function (group, color)
    local style = color.style and "gui=" .. color.style or "gui=NONE"
    local fg = color.fg and "guifg=" .. color.fg or "guifg=NONE"
    local bg = color.bg and "guibg=" .. color.bg or "guibg=NONE"
    local sp = color.sp and "guisp=" .. color.sp or ""

local hl = "highlight " .. group .. " " .. style .. " " .. fg .. " " .. bg .. " " .. sp

vim.cmd(hl)
    if color.link then vim.cmd("highlight! link " .. group .. " " .. color.link) end
end

-- Only define nord if it's the active colorscheme
function util.onColorScheme()
    if vim.g.colors_name ~= "forest" then
        vim.cmd [[autocmd! forest]]
        vim.cmd [[augroup! forest]]
    end
end

-- Change the background for the terminal, packer and qf windows
util.contrast = function()
    vim.cmd [[augroup forest]]
    vim.cmd [[  autocmd!]]
    vim.cmd [[  autocmd ColorScheme * lua require("forest.util").onColorScheme()]]
    vim.cmd [[  autocmd TermOpen * setlocal winhighlight=Normal:NormalFloat,SignColumn:NormalFloat]]
    vim.cmd [[  autocmd FileType packer setlocal winhighlight=Normal:NormalFloat,SignColumn:NormalFloat]]
    vim.cmd [[  autocmd FileType qf setlocal winhighlight=Normal:NormalFloat,SignColumn:NormalFloat]]
    vim.cmd [[augroup end]]
end

-- Load the theme
function util.load()
    -- Set the theme environment
    vim.cmd("hi clear")
    if vim.fn.exists("syntax_on") then vim.cmd("syntax reset") end
    vim.o.background = "dark"
    vim.o.termguicolors = true
    vim.g.colors_name = "forest"

    -- load the most importaint parts of the theme
    local editor = forest.loadEditor()
    local syntax = forest.loadSyntax()
    local treesitter = forest.loadTreeSitter()

    -- load editor highlights
    for group, colors in pairs(editor) do
        util.highlight(group, colors)
    end

    -- load syntax highlights
    for group, colors in pairs(syntax) do
        util.highlight(group, colors)
    end

    -- loop trough the treesitter table and highlight every member
    for group, colors in pairs(treesitter) do
        util.highlight(group, colors)
    end

    forest.loadTerminal()

    -- imort tables for plugins and lsp
    local plugins = forest.loadPlugins()
    local lsp = forest.loadLSP()

    -- loop trough the plugins table and highlight every member
    for group, colors in pairs(plugins) do
        util.highlight(group, colors)
    end

    -- loop trough the lsp table and highlight every member
    for group, colors in pairs(lsp) do
        util.highlight(group, colors)
    end

    -- if contrast is enabled, apply it to sidebars and floating windows
    if vim.g.forest_contrast == true then
        util.contrast()
    end
end

return util
