require("config.lazy")
require("nvim-autopairs").setup{}
-- Map Alt+E to toggle the file tree
vim.keymap.set("n", "<A-e>", ":NvimTreeToggle<CR>", { noremap = true, silent = true, desc = "Toggle file tree" })
vim.keymap.set("n", "<A-f>", ":Telescope find_files<CR>", { noremap = true, silent = true, desc = "Fuzzy find files" })
