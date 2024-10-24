vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

-- Disable line numbers for .txt files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.txt",
  callback = function()
    vim.wo.number = false -- Disable absolute line numbers
    vim.wo.relativenumber = false -- Disable relative line numbers
  end,
})

-- For neovide users in a Windows enviroment using pwsh
if vim.fn.has "win32" == 1 then
  vim.opt.shell = "pwsh"
  vim.opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
  vim.opt.shellxquote = ""
  vim.opt.shellquote = ""
  vim.opt.shellpipe = "| Out-File -Encoding UTF8 %s"
  vim.opt.shellredir = "| Out-File -Encoding UTF8 %s"
end

if vim.g.neovide then
  vim.opt.guifont = "JetBrainsMono Nerd Font:h12"
  vim.g.remember_window_size = true
  vim.g.remember_window_position = true

  local function toggle_transparency()
    if vim.g.neovide_transparency == 1.0 then
      vim.cmd "let g:neovide_transparency=0.9"
    else
      vim.cmd "let g:neovide_transparency=1.0"
    end
  end

  local function toggle_fullscreen()
    if vim.g.neovide_fullscreen == false then
      vim.cmd "let g:neovide_fullscreen=v:true"
    else
      vim.cmd "let g:neovide_fullscreen=v:false"
    end
  end

  vim.keymap.set("n", "<F11>", toggle_fullscreen, { silent = true })
  vim.keymap.set("n", "<F10>", toggle_transparency, { silent = true })
end

local lazy_config = require "configs.lazy"

require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },
  { import = "plugins" },
}, lazy_config)

dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)
