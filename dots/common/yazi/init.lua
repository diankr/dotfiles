require("full-border"):setup()
require("jump-to-char")
require("toggle-pane")
require("relative-motions"):setup({
	show_numbers = "relative",
	show_motion = true,
	only_motions = false,
	enter_mode = "first",
})
require("bunny"):setup({
  hops = {
    { key = "/",          path = "/",                                    },
		{ key = "h",          path = "~/.hammerspoon",                        desc = "Hammerspoon" },
		{ key = "l",          path = "~/Library/Application Support/lazygit", desc = "Lazygit" },
		{ key = "p",          path = "~/Pictures",                            desc = "Pictures" },
		{ key = "r",          path = "~/CodeWork/Rust",                       desc = "Rust Projects" },
		{ key = "y",          path = "~/.config/yazi",                        desc = "yazi"         },
		{ key = { "d", "c" }, path = "~/Documents",                           desc = "Documents"    },
		{ key = { "d", "l" }, path = "~/Downloads",                           desc = "Downloads"    },
		{ key = { "g", "c" }, path = "~/Google Drive/我的云端硬盘",           desc = "Cloud Drive" },
		{ key = { "i", "i" }, path = "~/Godot/iruka",                         desc = "iruka" },
		{ key = { "i", "a" }, path = "~/Godot/iruka/assets",                  desc = "iruka_assets" },
		{ key = { "i", "s" }, path = "~/Godot/iruka/scripts",                 desc = "iruka_scripts" },
		{ key = { "i", "r" }, path = "~/Godot/iruka/src",                     desc = "iruka_resources" },
  },
  desc_strategy = "path", -- If desc isn't present, use "path" or "filename", default is "path"
  ephemeral = true, -- Enable ephemeral hops, default is true
  tabs = true, -- Enable tab hops, default is true
  notify = false, -- Notify after hopping, default is false
  fuzzy_cmd = "fzf", -- Fuzzy searching command, default is "fzf"
})
