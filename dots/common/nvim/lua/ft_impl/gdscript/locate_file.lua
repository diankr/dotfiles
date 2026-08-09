local function locate_current_file_in_godot()
	-- 获取当前缓冲区的绝对路径
	local filepath = vim.fn.expand('%:p')

	-- 向上寻找 project.godot 以确定项目根目录
	local root = vim.fn.findfile('project.godot', '.;')
	if root == '' then
		print('当前不在Godot项目中！')
		return
	end

	-- 获取根目录绝对路径
	root = vim.fn.fnamemodify(root, ':p:h')

	-- 将系统的绝对路径转换为 Godot 认识的 res:// 路径
	local rel_path = filepath:sub(#root + 2)
	local res_path = 'res://' .. rel_path

	local uv = vim.uv or vim.loop
	local client = uv.new_udp()
	client:send(res_path, '127.0.0.1', 4242, function(err)
		client:close()
		if err then
			print("发送失败: " .. err)
		else
			vim.schedule(function()
				vim.fn.jobstart({
					"osascript",
					"-e", 'tell application "Godot" to activate'
				}, { detach = true })
			end)
		end
	end)
	print("在Godot中定位: " .. res_path)
end

vim.api.nvim_create_user_command('LocateFileInGodot', locate_current_file_in_godot, { desc = "Locate current file in Godot FileSystem" })

-- 绑定当前 GDScript Buffer 的局部快捷键
vim.keymap.set('n', '<localleader>fs', ':LocateFileInGodot<CR>', { buffer = true, desc = 'Locate file in Godot FileSystem' })

-- 为后续打开的所有 GDScript Buffer 注册局部快捷键
vim.api.nvim_create_autocmd("FileType", {
	pattern = "gdscript",
	callback = function(args)
		vim.keymap.set("n", "<localleader>fs", ":LocateFileInGodot<CR>", { buffer = args.buf, desc = "Locate file in Godot FileSystem" })
	end,
})
