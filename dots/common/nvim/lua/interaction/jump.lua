return{
	{
		url = "https://codeberg.org/andyg/leap.nvim",
		event = "VeryLazy",
		config = function()
			-- require("leap").add_default_mappings()
			local function as_ft(key_args)
				local common = {
					inputlen = 1,
					inclusive = true,
					opts = {
						labels = "",
						safe_labels = vim.fn.mode(1):match("[no]") and "" or nil,
						case_sensitive = true,
					},
				}
				return vim.tbl_deep_extend("keep", common, key_args)
			end

			local clever   = require("leap.user").with_traversal_keys
			local clever_f = clever("f", "F")
			local clever_t = clever("t", "T")

			for key, args in pairs({
				f = { opts = clever_f },
				F = { backward = true, opts = clever_f },
				t = { offset = -1, opts = clever_t },
				T = { backward = true, offset = 1, opts = clever_t },
			}) do
				vim.keymap.set({ "n", "x", "o" }, key, function ()
					require("leap").leap(as_ft(args))
				end, { silent = true })
			end
		end
	},
}
