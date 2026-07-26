return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local lualine = require("lualine")
			-- load basic theme
			local theme = require("lualine.themes.gruvbox-material")
			-- customize theme colorscheme
			theme.normal.a.bg = "#718D83"
			theme.normal.b.bg = "#303436"
			theme.normal.b.fg = "#90a59d"
			theme.normal.c.bg = "#242728"
			theme.normal.c.fg = "#948a79"
			theme.insert.a.bg = "#8EC07C"
			theme.visual.a.bg = "#D3869B"
			-- setup
			lualine.setup({
				options = {
					theme = theme,
					icons_enabled = true,
					globalstatus = true,
					always_show_tabline = false,
					section_separators = { left = "", right = "" },
					component_separators = { left = ">", right = "<" },
					disabled_filetypes = {
					statusline = { "alpha", "dashboard" },
					winbar = {},
				},
				always_divide_middle = true,
				refresh = { statusline = 100, tabline = 100, winbar = 100 },
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = { { "filename", path = 1 } },
				lualine_x = { "encoding", "fileformat", "filetype" },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { { "filename", path = 1 } },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {
				lualine_a = { { "filename", path = 1 } },
				lualine_b = { "tabs" },
			},
			extensions = { "fzf", "quickfix", "man", "nvim-tree", "lazy", "toggleterm" },
			})
		end,
  },
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"rcarriga/nvim-notify",
			opts = {
				timeout = 5000,
				top_down = false, -- 改为右下角弹窗 (false 表示从下往上堆叠)
				stages = "static",
				render = "compact",
				minimum_width = 60,
				on_open = function(win)
					vim.api.nvim_win_set_config(win, { border = "rounded", width = 60 })
					vim.wo[win].wrap = true
					vim.wo[win].linebreak = true
					vim.wo[win].breakindent = true
				end,
			},
			config = function(_, opts)
				local notify = require("notify")
				notify.setup(opts)
				local C = {
					border = "#303436",
					body = "#D0C39F",
				}
				local function set_notify_highlights()
					vim.api.nvim_set_hl(0, "NotifyBorderUnified", { fg = C.border, bg = "NONE" })
					vim.api.nvim_set_hl(0, "NotifyBodyUnified", { fg = C.body, bg = "NONE" })
					for _, lvl in ipairs({ "ERROR", "WARN", "INFO", "DEBUG", "TRACE" }) do
						vim.api.nvim_set_hl(0, "Notify"..lvl.."Border", { link = "NotifyBorderUnified" })
						vim.api.nvim_set_hl(0, "Notify"..lvl.."Body", { link = "NotifyBodyUnified" })
						-- vim.api.nvim_set_hl(0, "Notify"..lvl.."Title", { link = "NotifyBodyUnified" })
					end
				end
				set_notify_highlights()
				vim.api.nvim_create_autocmd("ColorScheme", {
					group = vim.api.nvim_create_augroup("NotifyHighlightsFix", { clear = true }),
					callback = set_notify_highlights,
				})
			end,
		},
		opts = {
			cmdline = {
				enable = true,
				view = "cmdline_popup",
				opts =  {
					position = { row = "50%", col = "50%" },
					size = { width = "80%", height = "auto" },
				},
			},
			views = {
				popup = {
					backend = "popup",
					win_options = {
						winhighlight = {
							Normal = "Normal",
							FloatBorder = "Normal"
						}
					}

				}
			},
			messages = {
				enable = true,
				view = "notify",
				view_error = "notify",
				view_warn = "notify",
				view_history = "popup",
				view_search = "virtualtext",
			},
			commands = {
				history = { view = "popup" },
				last = { view = "popup" },
				errors = { view = "popup" },
			},
			popupmenu =  {
				enable = true,
				-- backend = "popup",
			},
			presets =  {
				bottom_search = false,
				command_palette = false,
				long_message_to_split = false,
				inc_rename = false,
				lsp_doc_border = false,
			}
		},
		keys = {
			{
				"<leader>cmd", mode = "n", silent = true,
				function()
					if vim.g._noice_enabled == false then
						require("noice").cmd("enable")
						vim.g._noice_enabled = true
					else
						require("noice").cmd("disable")
						vim.g._noice_enabled = false
					end
				end,
			},
			{ "<leader>nd", function() require("noice").cmd("dismiss") end, mode = "n", desc = "Dismiss All Notifications", silent = true },
			{ "<leader>nh", function() require("noice").cmd("history") end, mode = "n", silent = true },
			{ "<leader>nl", function() require("noice").cmd("last") end, mode = "n", silent = true },
			{ "<leader>ne", function() require("noice").cmd("errors") end, mode = "n", silent = true },
		},
	},
}
