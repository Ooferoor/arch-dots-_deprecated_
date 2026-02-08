require("config.lazy")
require("oil").setup()

-- Basic Options
vim.opt.number = true         -- Show line numbers
vim.opt.relativenumber = true -- Better for jumping lines
vim.opt.shiftwidth = 4        -- Tab size
vim.opt.expandtab = true      -- Spaces instead of tabs
vim.opt.cursorline = true     -- Highlight current line
vim.opt.termguicolors = true  -- Better colors

-- Keymaps
local map = vim.keymap.set

-- Bufferline

map("n", "<A-h>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Prev buffer" })
map("n", "<A-l>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })

-- Navigation
map("n", "<A-e>", ":NvimTreeToggle<CR>", { desc = "Toggle File Tree" })
map("n", "<leader>ff", ":Telescope find_files<CR>", { desc = "Find Files" })
map("n", "<leader>fg", ":Telescope live_grep<CR>", { desc = "Search Text" })

-- Better Window Jumps (Ctrl + hjkl)
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- LSP Shortcuts (Only work when an LSP is active)
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
        map('n', 'gd', vim.lsp.buf.definition, { buffer = ev.buf, desc = "Go to Definition" })
        map('n', 'K', vim.lsp.buf.hover, { buffer = ev.buf, desc = "Show Docs" })
        map('n', '<leader>rn', vim.lsp.buf.rename, { buffer = ev.buf, desc = "Rename variable" })
    end,
})
