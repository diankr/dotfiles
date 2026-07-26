vim.api.nvim_create_user_command('LocateFileInGodot', function()
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
	-- 比如把 /User/game/src/main.gd 截取为 src/main.gd
	local rel_path = filepath:sub(#root + 2)
	local res_path = 'res://' .. rel_path

	local uv = vim.uv or vim.loop
	local client = uv.new_udp()
	client:send(res_path, '127.0.0.1', 4242, function(err)
		client:close()
		if err then
			print("发送失败: " .. err)
		end
	end)
	print("在Godot中定位: " .. res_path)
end, {})

-- 绑定你喜欢的快捷键，比如 <leader>gl
vim.keymap.set('n', '<localleader>fs', ':LocateFileInGodot<CR>', { desc = 'Locate file in Godot FileSystem' })
