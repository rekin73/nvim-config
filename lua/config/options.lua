vim.opt.number = true
vim.opt.colorcolumn = "80"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.fileencodings = 'fileencodings=ucs-bom,utf-8,default,latin2,latin1'
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('highlight_yank', {}),
  desc = 'Hightlight selection on yank',
  pattern = '*',
  callback = function()
    vim.highlight.on_yank { higroup = 'IncSearch', timeout = 100 }
  end,
})
