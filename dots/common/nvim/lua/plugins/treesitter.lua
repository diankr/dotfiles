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
				-- Godot / GDScript
				"gdscript", "godot_resource", "gdshader",
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
  },
}
