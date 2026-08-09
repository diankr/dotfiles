return {
	{
		"neoclide/coc.nvim",
		branch = "release",
		-- lazy load
		event = { "BufReadPre", "BufNewFile" },

		init = function()
			vim.g.coc_global_extensions = {
				"coc-rust-analyzer",
				"coc-gdscript",
				"coc-json",
				"coc-toml",
				"coc-yaml",
				"coc-lua",
				"coc-snippets",
				"coc-explorer",
			}
		end,

		config = function()
			local map = vim.keymap.set
			local opts = { silent = true, noremap = false }
			local cmplOpts = { silent = true, noremap = true, expr = true, replace_keycodes = false }
		-- 
		-- ==========  Key Mappings  ==========
		-- 
			map("n", "gd", "<Plug>(coc-definition)",  opts)
			map("n", "gr", "<Plug>(coc-references)",  opts)
			map("n", "gy", "<Plug>(coc-type-definition)", opts)
			map("n", "gi", "<Plug>(coc-implementation)",  opts)
			map("n", "<leader>rn", "<Plug>(coc-rename)",  opts)
			map({ "n", "x" }, "<leader>ca", "<Plug>(coc-codeaction)", opts)

			-- document 
			map({ "n", "x" }, "<leader>f", "<Plug>(coc-format-selected)", opts)
			--  map("n", "<leader>F", "<Cmd>CocCommand editor.action.formatDocument<CR>", { silent = true })

			-- Diagnostic
			map("n", "[g", "<Plug>(coc-diagnostic-prev)", opts)
			map("n", "]g", "<Plug>(coc-diagnostic-next)", opts)

			-- Hover Function
			map("n", "[k", function()
			if vim.fn.CocActionAsync("doHover") == 0 then
				vim.cmd("lua vim.lsp.buf.hover()")
			end
			end, { silent = true })

			-- Snippets
			vim.keymap.set("i", "<C-s>", "<Plug>(coc-snippets-expand)", { silent = true } )
			-- vim.keymap.set({"i","s"}, "<C-n>", "<Plug>(coc-snippets-expand-jump)", { silent = true } )
			-- vim.keymap.set({"i","s"}, "<C-a>", "<Plug>(coc-snippets-jump-prev)", { silent = true } )
			vim.g.coc_snippet_next = "<Tab>"
			vim.g.coc_snippet_prev = "<S-Tab>"

			-- Completion
			-- map("i", "<Up>",    [[coc#pum#visible() ? coc#pum#prev(1) : "\<Up>"]],      cmplOpts)
			-- map("i", "<Down>",  [[coc#pum#visible() ? coc#pum#next(1) : "\<Down>"]],    cmplOpts)
			-- map("i", "<Left>", [[coc#pum#visible() ? coc#pum#cancel() : "\<Left>"]],   cmplOpts)
			-- map("i", "<Right>", [[coc#pum#visible() ? coc#pum#confirm() : "\<Right>"]], cmplOpts)
			map("i", "<Right>", [[coc#pum#visible() ? coc#pum#cancel() : "\<Right>"]],   cmplOpts)
			map("i", "<Tab>", [[coc#pum#visible() ? coc#pum#confirm() : "\<Tab>"]], cmplOpts)

			-- Explorer
			map("n", "<leader>e", "<cmd>CocCommand explorer --position floating --floating-position center<CR>", { silent = true, desc = "coc-explorer (floating center)" })

			--
			-- ==========  Highlighting & Signature  ==========
			--
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
			callback = function()
				pcall(vim.fn.CocActionAsync, "highlight")
			end,
			})
			-- save signature
			-- vim.api.nvim_create_autocmd("BufWritePre", {
			--   callback = function() vim.fn.CocAction("format") end,
			-- })
			vim.opt.completeopt = { "menuone", "noselect" }
		end,
	},
}

