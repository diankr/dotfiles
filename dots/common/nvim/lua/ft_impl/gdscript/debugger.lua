vim.keymap.set("n", "<localleader>b", "Obreakpoint<Esc>j", { buffer = true, desc = "Insert breakpoint above" })

vim.api.nvim_create_autocmd("FileType", {
	pattern = "gdscript",
	callback = function(args)
		vim.keymap.set("n", "<localleader>b", "Obreakpoint<Esc>j", { buffer = args.buf, desc = "Insert breakpoint above" })
	end,
})
