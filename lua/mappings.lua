require "nvchad.mappings"

-- add yours here
local map = vim.keymap.set

-- Copy to clipboard
map("v", "<C-c>", '"+y', { desc = "Copy to yanked" })
