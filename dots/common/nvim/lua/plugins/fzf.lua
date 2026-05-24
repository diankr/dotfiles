return {
  {
	"ibhagwan/fzf-lua",
	-- 图标可选
	dependencies = {
	  "nvim-tree/nvim-web-devicons",
	  -- 若本机没装 fzf，可解开下面注释，在 nvim 里顺便装二进制
	  -- { "junegunn/fzf", build = "./install --bin" },  -- macOS/Linux 通用
	},
	-- 仅在用到这些键位/命令时再加载，实现懒加载
	keys = {
	  { "<C-p>",	  function() require("fzf-lua").files() end,		desc = "FZF Files" },
	  -- 你原来 <C-f> 走 :Rg，这里换成 fzf-lua 的项目级 grep
	  { "<C-f>",	  function() require("fzf-lua").grep_project() end, desc = "FZF Ripgrep (project)" },
	  { "<C-h>",	  function() require("fzf-lua").oldfiles({ cwd = "~" }) end, desc = "FZF Oldfiles ~" },
	  { "<C-q>",	  function() require("fzf-lua").builtin() end,	  desc = "FZF Builtins" },
	  { "<C-t>",	  function() require("fzf-lua").lines() end,		desc = "FZF Lines (open buffers)" },

	  -- Leader 系：保持和你旧配置一致
	  { "<leader>fb", function() require("fzf-lua").buffers() end,	  desc = "Buffers" },
	  { "<leader>ff", function() require("fzf-lua").files() end,		desc = "Files" },
	  { "<leader>fs", function() require("fzf-lua").grep_project() end, desc = "Search (ripgrep)" },
	  { "<leader>fh", function() require("fzf-lua").oldfiles({ cwd = "~" }) end, desc = "Oldfiles ~" },
	  { "<leader>fl", function() require("fzf-lua").lines() end,		desc = "Lines" },

	  -- 兼容你习惯的 :Rg 命令（如果你肌肉记忆就是 :Rg）
	  { ":Rg",  function() require("fzf-lua").grep_project() end, mode = "c", desc = "Ripgrep (project)" },
	},
	cmd = { "FzfLua" },

	opts = function()
	  local actions = require("fzf-lua.actions")

	  return {
		-- 直接启用 fzf-vim 档：会生成 :Files / :Rg 等命令
		-- 这样你可以继续用 :Rg，同时又不需要安装 fzf.vim
		"fzf-vim",  -- <== 关键点
		winopts = {
		  width  = 0.95,
		  height = 0.95,
		  preview = {
			scrollbar = "float",
		  },
		  -- 需要更“全屏”时，把 fullscreen=true / 覆盖 keymap 里 <c-f> 动作即可
		  fullscreen = false,
		},

		-- 这里把你在 vimscript 里写过的 fzf 内部快捷键复刻过来
		keymap = {
		  builtin = {
			["<c-f>"]	= "toggle-fullscreen",
			["<c-r>"]	= "toggle-preview-wrap",
			["<c-p>"]	= "toggle-preview",
			["<c-y>"]	= "preview-page-down",
			["<c-l>"]	= "preview-page-up",
			["<S-left>"] = "preview-page-reset",
		  },
		  fzf = {
			["esc"]		= "abort",
			["ctrl-h"]	 = "unix-line-discard",
			["ctrl-k"]	 = "half-page-down",
			["ctrl-b"]	 = "half-page-up",
			["ctrl-n"]	 = "beginning-of-line",
			["ctrl-a"]	 = "end-of-line",
			["alt-a"]	  = "toggle-all",
			["f3"]		 = "toggle-preview-wrap",
			["f4"]		 = "toggle-preview",
			["shift-down"] = "preview-page-down",
			["shift-up"]   = "preview-page-up",
			["ctrl-e"]	 = "down",
			["ctrl-u"]	 = "up",
		  },
		},

		-- 文件与 Buffer 分别按你旧配置做了细节对齐
		files = {
			prompt       = "Files❯ ",
			multiprocess = true,
			git_icons    = true,
			file_icons   = true,
			color_icons  = true,
			-- 隐藏文件 + 忽略 .git
			fd_opts      = "--color=never --type f --hidden --follow --exclude .git",
			rg_opts      = "--color=never --files --hidden --follow -g '!.git'",
		},
		buffers = {
			prompt   = "Buffers❯ ",
			file_icons   = true,
			color_icons  = true,
			sort_lastused = true,
			-- 这里给你做了「Ctrl-D 删除 buffer + 继续选择」的动作组合，
			-- 等价你原来自定义的 :BD 工作流
			actions = {
				["default"] = actions.buf_edit,
				["ctrl-d"]  = { actions.buf_del, actions.resume },
			},
		},

		-- 预览器示例（可按需精简）
		previewers = {
			bat = {
			cmd   = "bat",
			args  = "--style=numbers,changes --color always",
			theme = "Coldark-Dark",
			},
			builtin = {
			syntax		 = true,
			syntax_limit_l = 0,
			syntax_limit_b = 1024 * 1024,
			},
		},
	}
	end,

	config = function(_, opts)
	  local fzf = require("fzf-lua")
	  fzf.setup(opts)
	  -- 生成 :Files / :Rg / :Buffers ... 等 fzf.vim 同名命令
	  fzf.setup_fzfvim_cmds()
	end,
  },
}
