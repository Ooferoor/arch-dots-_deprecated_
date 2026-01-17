-- ~/.config/nvim/lua/config/plugins.lua
return {
    -- Syntax highlighting
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        run = ":TSUpdate",
    },

    -- Lua helper library
    { "nvim-lua/plenary.nvim", lazy = false },

    -- Fuzzy finder
    { "nvim-telescope/telescope.nvim", lazy = false },

    -- LSP support
    { "neovim/nvim-lspconfig", lazy = false },

    -- Sidebar for files
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        lazy = false,
        config = function()
            require("nvim-tree").setup {
                view = { width = 30, side = "left" },
                renderer = { group_empty = true },
            }
        end,
    },

    -- Status line
    { "nvim-lualine/lualine.nvim", lazy = false },

    -- Auto close quotes & brackets
    { "windwp/nvim-autopairs", lazy = false },

    -- Git integration
    { "tpope/vim-fugitive", lazy = false },
}
