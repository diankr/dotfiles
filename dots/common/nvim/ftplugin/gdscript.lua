local map = vim.api.nvim_buf_set_keymap
map(0, "n", "<localleader>e", "<cmd>lua require('snacks').explorer.open()<CR>", {noremap = true, silent = true})

local first_read = true
vim.api.nvim_create_autocmd("FileType", {
	pattern = "gdscript",
	callback = function()
		-- Focus iterm app
		local cmd = [[osascript -e 'tell application "iTerm2" to activate']]
		vim.fn.jobstart(cmd, {detach = true})
		-- Auto Open Snacks.Explorer when first_read
		if first_read then
			require("snacks").explorer.open()
			vim.defer_fn(function ()
				vim.cmd("wincmd l")
			end, 100)
			first_read = false
		end
	end,
})

-- Markdown Snippets
require("snippets.gdscript")

-- run current godot scene
require("ft_impl.gdscript.debug_run")
