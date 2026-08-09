return {
	{
		"habamax/vim-godot",
		ft = { "gd", "gdscript", "tscn", "scn", "tres", "gdshader", "gsl", "glsl" },
	},
	{
		"skywind3000/asyncrun.vim",
		ft = { "gd", "gdscript", "tscn", "scn", "tres", "gdshader", "gsl", "glsl" },
	},
	{
		"teatek/gdscript-extended-lsp.nvim",
		ft = { "gd", "gdscript", "tscn", "scn", "tres", "gdshader", "gsl", "glsl" },
		opts = {
			view_type = "floating",
			picker = "snacks",
			-- semantic_tokens = true,
		},
	},
	{
		"folke/snacks.nvim",
		ft = { "gd", "gdscript", "tscn", "scn", "tres", "gdshader", "gsl", "glsl" },
		opts = {
			explorer = {
				auto_open = true,
				persist = true,
			},
			picker = {
				sources = {
					explorer = {
						hidden = true, -- show hidden files 
						ignored = false, -- don't show gitignored files 
						exclude = { -- exclude specific patterns 
							"*.uid", -- glob pattern for files ending with .uid 
							"server.pipe", -- exact filename match 
						},
						focus = "list",
						win = {
							input = {
								keys = {
									["<Tab>"] = "toggle_focus",
								},
							},
							list = {
								keys = {
									['<BS>'] = '',
									['<Tab>'] = 'toggle_focus',
									['<Space><Tab>'] = function() vim.cmd("wincmd l") end,
									['s'] = 'select_and_next',
									['S'] = 'select_and_prev',
									['.'] = 'explorer_up',
									['<Space>g'] = 'picker_grep',
									['f'] = 'explorer_focus',
									['O'] = 'explorer_open',
								}
							}
						}
					},
				},
			},
		},
	},
}
