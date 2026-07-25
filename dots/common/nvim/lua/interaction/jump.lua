return {
	{
		url = "https://codeberg.org/andyg/leap.nvim",
		event = "VeryLazy",
		config = function()
			local leap = require("leap")

			leap.opts.preview = false

			local function as_ft(key_args)
				local common = {
					inputlen = 1,
					inclusive = true,
					opts = {
						labels = "",
						safe_labels = vim.fn.mode(1):match("[no]") and "" or nil,
						vim_opts = { ["go.ignorecase"] = false },
					},
				}
				return vim.tbl_deep_extend("keep", common, key_args)
			end

			local clever   = require("leap.user").with_traversal_keys
			local clever_f = clever("f", "F")
			local clever_t = clever("t", "T")

			-- 配置 1 字符增强跳转 (f / F / t / T)
			for key, args in pairs({
				f = { opts = clever_f },
				F = { backward = true, opts = clever_f },
				t = { offset = -1, opts = clever_t },
				T = { backward = true, offset = 1, opts = clever_t },
			}) do
				vim.keymap.set({ "n", "x", "o" }, key, function()
					leap.leap(as_ft(args))
				end, { silent = true })
			end

			-- 3. 2 字符精准跳转：使用 s (向后/向下) 与 S (向前/向上) 替换默认的 s/S
			vim.keymap.set({ "n", "x", "o" }, "s", function()
				leap.leap({})
			end, { silent = true, desc = "Leap forward (2-char)" })

			vim.keymap.set({ "n", "x", "o" }, "S", function()
				leap.leap({ backward = true })
			end, { silent = true, desc = "Leap backward (2-char)" })
		end,
	},
}
