local map = vim.api.nvim_buf_set_keymap
map(0, "n", "<localleader>e", "<cmd>lua require('snacks').explorer.open()<CR>", {noremap = true, silent = true})

if vim.g.gdscript_first_read == nil then
	vim.g.gdscript_first_read = true
end

-- Focus iterm app
local cmd = [[osascript -e 'tell application "iTerm2" to activate']]
vim.fn.jobstart(cmd, {detach = true})

-- Auto Open Snacks.Explorer when first_read (moved out of autocmd)
if vim.g.gdscript_first_read then
	require("snacks").explorer.open()
	vim.defer_fn(function ()
		vim.cmd("wincmd l")
	end, 100)
	vim.g.gdscript_first_read = false
end

-- Markdown Snippets
require("snippets.gdscript")

-- run current godot scene
require("ft_impl.gdscript.debug_run")
require("ft_impl.gdscript.locate_file")

