local file_diffs = {}

local function toggle_file_diff()
	local api = vim.api
	local tab = api.nvim_get_current_tabpage()
	local view = file_diffs[tab]
	if view then
		if view.pending then
			return
		end
		local had_panel = false
		for win, buf in pairs(view.panels) do
			if api.nvim_win_is_valid(win) and api.nvim_win_get_buf(win) == buf then
				had_panel = true
				-- Index buffers can be edited: never force-close unsaved changes.
				if vim.bo[buf].modified then
					vim.notify("Save or undo changes in the Git comparison buffer before closing it.", vim.log.levels.WARN)
					return
				end
				local ok, err = pcall(api.nvim_win_close, win, false)
				if not ok then
					vim.notify(err, vim.log.levels.WARN)
					return
				end
			end
		end
		file_diffs[tab] = nil
		if api.nvim_win_is_valid(view.source) then
			api.nvim_win_call(view.source, function()
				vim.cmd("diffoff")
			end)
			if had_panel then
				api.nvim_set_current_win(view.source)
			end
		end
		if had_panel then
			return
		end
	end

	local existing = {}
	for _, win in ipairs(api.nvim_tabpage_list_wins(tab)) do
		existing[win] = true
	end
	view = { source = api.nvim_get_current_win(), panels = {}, pending = true }
	file_diffs[tab] = view
	require("gitsigns").diffthis(nil, { vertical = true }, function(err)
		view.pending = false
		if err or not api.nvim_tabpage_is_valid(tab) then
			file_diffs[tab] = nil
			if err then
				vim.notify(tostring(err), vim.log.levels.ERROR)
			end
			return
		end
		for _, win in ipairs(api.nvim_tabpage_list_wins(tab)) do
			if not existing[win] and vim.wo[win].diff then
				local buf = api.nvim_win_get_buf(win)
				view.panels[win] = buf
				vim.keymap.set("n", "<leader>gd", toggle_file_diff, {
					buffer = buf,
					silent = true,
					desc = "Toggle Git Diff Current File",
				})
			end
		end
		if not next(view.panels) then
			file_diffs[tab] = nil
		end
	end)
end

local function setup_git_colors()
	local function apply()
		-- Screenshot colors #8EC07C / #FB4934 with HSV S and V scaled to 70%.
		local add, delete = "#6E8665", "#B0584E"
		vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = add })
		vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = delete })
		vim.api.nvim_set_hl(0, "GitSignsTopdelete", { fg = delete })
		-- Native diff splits and Gitsigns previews share these backgrounds.
		vim.api.nvim_set_hl(0, "DiffAdd", { bg = add })
		vim.api.nvim_set_hl(0, "DiffDelete", { bg = delete })
		vim.api.nvim_set_hl(0, "GitSignsAddPreview", { link = "DiffAdd" })
		vim.api.nvim_set_hl(0, "GitSignsDeletePreview", { link = "DiffDelete" })
	end
	apply()
	vim.api.nvim_create_autocmd("ColorScheme", {
		group = vim.api.nvim_create_augroup("GitDiffColors", { clear = true }),
		callback = apply,
	})
end

-- 与 fzf_exec 一样，返回快捷键使用的回调；只替换光标所在的改动块。
local function reset_hunk_to(revision)
	return function()
		local api = vim.api
		local buf = api.nvim_get_current_buf()
		local file = api.nvim_buf_get_name(buf)
		if vim.bo[buf].buftype ~= "" or not vim.bo[buf].modifiable or file == "" then
			return
		end
		local tick = api.nvim_buf_get_changedtick(buf)
		local row = api.nvim_win_get_cursor(0)[1]
		local current = api.nvim_buf_get_lines(buf, 0, -1, false)
		local object = revision .. ":./" .. vim.fs.basename(file)

		-- 直接读取指定版本，不切换 Gitsigns 的比较基准，也不改动暂存区。
		vim.system({ "git", "-C", vim.fs.dirname(file), "show", object }, { text = true },
			vim.schedule_wrap(function(result)
				if not api.nvim_buf_is_valid(buf) then
					return
				end
				if result.code ~= 0 then
					vim.notify(vim.trim(result.stderr), vim.log.levels.WARN)
					return
				end
				if api.nvim_buf_get_changedtick(buf) ~= tick then
					vim.notify("Buffer changed; retry the hunk reset.", vim.log.levels.INFO)
					return
				end
				local text = result.stdout:gsub("\r\n", "\n"):gsub("^\239\187\191", "")
				local reference = vim.split(text, "\n", { plain = true })
				if reference[#reference] == "" then
					table.remove(reference)
				end
				local base = #reference == 0 and "" or table.concat(reference, "\n") .. "\n"
				local hunks = vim.diff(base, table.concat(current, "\n") .. "\n", {
					result_type = "indices",
					algorithm = "myers",
					linematch = 40,
				})
				for _, hunk in ipairs(hunks) do
					local old_start, old_count, new_start, new_count = unpack(hunk)
					local first = math.max(1, new_start)
					local last = math.max(first, new_start + new_count - 1)
					if row >= first and row <= last then
						local lines = {}
						for i = old_start, old_start + old_count - 1 do
							lines[#lines + 1] = reference[i]
						end
						local start = new_count == 0 and new_start or new_start - 1
						api.nvim_buf_set_lines(buf, start, start + new_count, false, lines)
						return
					end
				end
				vim.notify("No hunk at the cursor for this revision.", vim.log.levels.INFO)
			end))
	end
end

return {
	{
		"kdheepak/lazygit.nvim",
		cmd = "LazyGit",
		keys = {
			{ "<leader>lg", "<cmd>LazyGit<CR>", desc = "LazyGit" }
		}
	},
	{
		"lewis6991/gitsigns.nvim",
		event = "VeryLazy",
		opts = {
			signcolumn = true,
			numhl = false,
			linehl = false,
			word_diff = false,
			current_line_blame = false,
			attach_to_untracked = false,
			on_attach = function(bufnr)
				local gs = require("gitsigns")
				local function map(lhs, rhs, desc)
					vim.keymap.set("n", lhs, rhs, {
						buffer = bufnr,
						silent = true,
						desc = desc,
					})
				end

				-- Keep native hunk navigation in Vim diff windows.
				map("]c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "]c", bang = true })
					else
						gs.nav_hunk("next")
					end
				end, "Next Git Change")
				map("[c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "[c", bang = true })
					else
						gs.nav_hunk("prev")
					end
				end, "Previous Git Change")
				map("<leader>gp", gs.preview_hunk, "Git Preview Hunk")
				map("<leader>gd", toggle_file_diff, "Toggle Git Diff Current File")
				map("<leader>gb", gs.blame_line, "Git Blame Line")
				map("<leader><leader>rs", reset_hunk_to(""), "Reset Hunk to Stage")
				map("<leader><leader>rh", reset_hunk_to("HEAD"), "Reset Hunk to HEAD")
			end,
		},
		config = function(_, opts)
			require("gitsigns").setup(opts)
			setup_git_colors()
		end,
	},
	{
		"esmuellert/codediff.nvim",
		cmd = "CodeDiff",
		keys = {
			{ "<leader>gD", "<cmd>CodeDiff<CR>", desc = "Git Diff Repository" },
			{ "<leader>gh", "<cmd>CodeDiff history %<CR>", desc = "Git History Current File" },
			{ "<leader>gH", "<cmd>CodeDiff history<CR>", desc = "Git History Repository" },
		},
		opts = {
			-- 单独调暗 CodeDiff 背景，保持红绿色相与 Gitsigns 配色不变。
			highlights = {
				line_insert = "#293226",
				line_delete = "#38201C",
				char_insert = "#2D3729",
				char_delete = "#46231F",
			},
			keymaps = {
				view = {
					-- Preserve the existing gm mapping for mark navigation.
					align_move = false,
				},
			},
		},
	},
}
