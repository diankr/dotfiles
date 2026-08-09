return {
  {
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		-- 高亮应尽早生效，比 VeryLazy 更合适
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			ensure_installed = {
				-- Common
				"lua", "vim", "vimdoc", "bash", "json", "toml", "yaml",
				"cpp", "rust",
				-- Godot / GDScript / Shader
				"gdscript", "godot_resource", "gdshader", "glsl",
			},
			highlight = {
				enable = true,
			-- additional_vim_regex_highlighting = false, -- 避免双重上色
			},
			indent = { enable = true },
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection	= "<CR>",
					node_incremental  = "<CR>",
					scope_incremental = "<S-CR>",
					node_decremental  = "<BS>",
				},
			},
		},
		config = function(_, opts)
			local pcall_ok, ts_configs = pcall(require, "nvim-treesitter.configs")
			if not pcall_ok then
				pcall_ok, ts_configs = pcall(require, "nvim-treesitter.config")
			end
			if pcall_ok and ts_configs and ts_configs.setup then
				ts_configs.setup(opts)
			end
			vim.treesitter.language.register("gdshader", { "gdshader", "gsl" })
			vim.treesitter.language.register("glsl", "glsl")
		end,
  },
}


