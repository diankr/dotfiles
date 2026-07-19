vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*.gd",
	callback = function ()
		local prefix_map = {
			[0] = "",    -- basic
			[1] = "\\",  -- words
			[2] = ",",   -- basic ex
			[3] = "|",   -- class
		}

		local function i_map( index, key, cmdline )
			local prefix = prefix_map[index] or ""
			local cmd = prefix..key
			vim.keymap.set( "i", cmd, cmdline, { buffer = true, noremap = true, silent = true} )
		end

		i_map( 0, "\"", "\"\"<Esc>i" )

		i_map( 0, "(", "()<Esc>i" )
		i_map( 0, ")", "()" )
		i_map( 0, "[", "[]<Esc>i" )
		i_map( 0, "{", "{}<Esc>i" )

		i_map( 1, "l", "-> " )
		i_map( 1, "p", "print(\"\")<Esc>hi" )
		i_map( 1, "cl", "class_name " )
		i_map( 1, "re", "RESULT.Err." )
		-- constants.scene or dialog_node

		-- append "," to last
		i_map( 2, ",", "<Esc>A,<Esc>" )

		i_map( 2, "\"", "\"\", <++><Esc>6hi" )
		i_map( 2, "(", "(),<Esc>hi" )
		i_map( 2, "[", "[],<Esc>hi" )
		i_map( 2, "{", "{},<Esc>hi" )
		i_map( 2, ".(", "(\"\"),<Esc>hhi" )

		i_map( 3, "p", "gm.plr." )
		i_map( 3, "uc", "ut.cmn." )
		i_map( 3, "us", "ut.ch." )

	end
})
