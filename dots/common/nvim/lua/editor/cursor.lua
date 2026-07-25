-- ==================== Cursor Movement ====================
local map = vim.keymap.set
local ns  = { noremap = true, silent = true }

map("n", "v$", "v$h", ns)
map("n", "W",  "5w",  ns)
map("n", "B",  "5b",  ns)

-- Move up/down without moving the cursor
map("n", "<C-U>", "5<C-y>", ns)
map("n", "<C-E>", "5<C-e>", ns)

-- Jump to last edit location
map("n", "<leader>ye", "`>zz", ns)
map("n", "<leader>yb", "`<zz", ns)
map("n", "<leader>je", "g;zz", ns)

-- Insert Smart (); -> inoremap <expr> <C-9> '();' . "\<Left>\<Left>"
map("i", "<C-9>", function()
  return "();" .. vim.api.nvim_replace_termcodes("<Left><Left>", true, false, true)
end, { expr = true })
