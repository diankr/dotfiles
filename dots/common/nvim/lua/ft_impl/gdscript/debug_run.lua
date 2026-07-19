vim.api.nvim_create_user_command("RunInGodotActiveScene", function()
  -- focus godot app window
  vim.fn.jobstart({
    "osascript",
    "-e", 'tell application "Godot" to activate'
  }, { detach = true })

  -- delay run
  vim.defer_fn(function()
    -- send cmd+r to godot
    vim.fn.jobstart({
      "osascript",
      "-e", 'tell application "System Events" to keystroke "r" using {command down}'
    }, { detach = true })
  end, 100)
end, { desc = "Run current active scene in Godot" })

vim.keymap.set("n", "<localleader>r", "<cmd>RunInGodotActiveScene<CR>", { buffer = true, desc = "RunInGodotActiveScene" })

-- Register autocommand for any subsequent GDScript buffers
vim.api.nvim_create_autocmd("FileType", {
	pattern = "gdscript",
	callback = function(args)
		vim.keymap.set("n", "<localleader>r", "<cmd>RunInGodotActiveScene<CR>", { buffer = args.buf, desc = "RunInGodotActiveScene" })
	end,
})

