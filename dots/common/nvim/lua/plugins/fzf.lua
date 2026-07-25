local function get_project_root()
  local path = require("fzf-lua.path")
  local current_file_dir = vim.fn.expand("%:p:h")
  if current_file_dir == "" then
    current_file_dir = vim.fn.getcwd()
  end
  local git_root = path.git_root({ cwd = current_file_dir }, true)
  return (git_root and git_root ~= "") and git_root or vim.fn.getcwd()
end

local function fzf_exec(fn_name, default_opts)
  return function()
    local opts = default_opts and vim.deepcopy(default_opts) or {}
    if not opts.cwd then
      opts.cwd = get_project_root()
    end
    require("fzf-lua")[fn_name](opts)
  end
end

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
	  { "<C-p>",	  fzf_exec("files"),		desc = "FZF Files" },
	  -- 你原来 <C-f> 走 :Rg，这里换成 fzf-lua 的项目级 grep
	  { "<C-f>",	  fzf_exec("grep_project"), desc = "FZF Ripgrep (project)" },
	  { "<C-h>",	  fzf_exec("oldfiles", { cwd = "~" }), desc = "FZF Oldfiles ~" },
	  { "<C-q>",	  fzf_exec("builtin"),	  desc = "FZF Builtins" },
	  { "<C-t>",	  fzf_exec("lines"),		desc = "FZF Lines (open buffers)" },

	  -- Leader 系：保持和你旧配置一致
	  { "<leader>fb", fzf_exec("buffers"),	  desc = "Buffers" },
	  { "<leader>ff", fzf_exec("files"),		desc = "Files" },
	  { "<leader>fs", fzf_exec("grep_project"), desc = "Search (ripgrep)" },
	  { "<leader>fh", fzf_exec("oldfiles", { cwd = "~" }), desc = "Oldfiles ~" },
	  { "<leader>fl", fzf_exec("lines"),		desc = "Lines" },

	  -- 兼容你习惯的 :Rg 命令（如果你肌肉记忆就是 :Rg）
	  { ":Rg",  fzf_exec("grep_project"), mode = "c", desc = "Ripgrep (project)" },
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
			["Q"]		= "abort",
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
