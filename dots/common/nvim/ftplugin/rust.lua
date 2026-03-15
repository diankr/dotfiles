-- 禁用内置的 rust 缩进脚本
vim.g.did_indent_rollback = 1
vim.g.loaded_indent_rust = 1

-- 禁用内置的 rust 语法高亮（如果你完全依赖 Treesitter）
vim.g.loaded_syntax_rust = 1

-- 禁用内置的 rust 推荐风格设置（最关键的一行）
vim.g.rust_recommended_style = 0
