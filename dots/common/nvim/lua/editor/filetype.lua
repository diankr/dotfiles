-- ==================== Filetype Detection ====================

vim.filetype.add({
  extension = {
    gdshader    = "gdshader",
    gdshaderinc = "gdshader",
    shader      = "gdshader",
    glsl        = "glsl",
    vert        = "glsl",
    frag        = "glsl",
    geom        = "glsl",
    comp        = "glsl",
    tesc        = "glsl",
    tese        = "glsl",
  },
})

-- Set commentstring for Shader filetypes (gdshader / gsl / glsl)
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "gdshader", "gsl", "glsl" },
  callback = function()
    vim.bo.commentstring = "// %s"
  end,
})
