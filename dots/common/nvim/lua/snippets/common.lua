local prefix_map = {
	[0] = "",
	[1] = "\\",
	[2] = ",",
}

local function i_map( index, key, cmdline )
	local prefix = prefix_map[index] or ""
	local cmd = prefix..key
	vim.keymap.set( "i", cmd, cmdline, { buffer = true, noremap = true, silent = true} )
end

-- append "," to last
i_map( 2, ",", "<Esc>A,<Esc>" )


i_map( 0, "\"", "\"\"<Esc>i" )

i_map( 1, "(", "()<Esc>i" )
i_map( 1, "[", "[]<Esc>i" )
i_map( 1, "{", "{}<Esc>i" )

i_map( 2, "\"", "\"\", <++><Esc>6hi" )
i_map( 2, "(", "(),<Esc>hi" )
i_map( 2, "[", "[],<Esc>hi" )
i_map( 2, "{", "{},<Esc>hi" )
i_map( 2, ".(", "(\"\"),<Esc>hhi" )


-- jump to <++> placeholder
-- i_map( "f", [[<Esc>/<++><CR>:nohlsearch<CR>"_c4l]] )
