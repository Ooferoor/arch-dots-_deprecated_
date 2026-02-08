return {
    -- The "New Standard" Completion Engine (Faster than nvim-cmp)
    {
        'saghen/blink.cmp',
        dependencies = 'rafamadriz/friendly-snippets',
        version = 'v0.*',
        opts = {
            keymap = { preset = 'super-tab' }, -- Works like VS Code
            appearance = { use_nvim_cmp_as_default = true, nerd_font_variant = 'mono' },
            sources = { default = { 'lsp', 'path', 'snippets', 'buffer' } },
        },
    },

    -- Tabs
    {
        "akinsho/bufferline.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            options = {
                separator_style = "slant",
                show_buffer_close_icons = true,
                diagnostics = "nvim_lsp",
                offsets = { { filetype = "NvimTree", text = "", padding = 1 } },
            },
        },
    },

    -- Git
    {
        "wsdjeg/git.nvim",
        dependencies = {
            "wsdjeg/job.nvim",
            "wsdjeg/notify.nvim",
        },
        -- optionally load on the Git command
        cmd = { "Git" },
    },
    -- Oil
    {
        'stevearc/oil.nvim',
        ---@module 'oil'
        ---@type oil.SetupOpts
        opts = {},
        -- Optional dependencies
        dependencies = { { "nvim-mini/mini.icons", opts = {} } },
        -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
        -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
        lazy = false,
    },
    -- LSP & Syntax
    { "neovim/nvim-lspconfig" },
    { "williamboman/mason.nvim",           config = true }, -- UI to install LSPs
    { "williamboman/mason-lspconfig.nvim", config = true },
    { "nvim-treesitter/nvim-treesitter",   build = ":TSUpdate" },

    -- Code formatting
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        opts = {
            format_on_save = { timeout_ms = 500, lsp_fallback = true },
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "black", "isort" },
                javascript = { "prettier" },
                typescript = { "prettier" },
                html = { "prettier" },
                css = { "prettier" },
                json = { "prettier" },
                sh = { "shfmt" },
                markdown = { "prettier" },
            },
        },
    },

    -- UI Polish
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = { lsp = { override = { ["vim.lsp.util.convert_input_to_markdown_lines"] = true } } },
        dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" }
    },

    -- Productivity
    { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
    { "lewis6991/gitsigns.nvim",       config = true },
    { "windwp/nvim-autopairs",         config = true },
    { "nvim-tree/nvim-tree.lua",       dependencies = "nvim-tree/nvim-web-devicons", config = true },
    { "tpope/vim-fugitive" },

    -- Colorscheme
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            vim.cmd.colorscheme "catppuccin"
        end
    },

    -- Statusline
    {
        "nvim-lualine/lualine.nvim",
        dependencies = "nvim-tree/nvim-web-devicons",
        config = true,
    },

    -- Dashboard / UI extras
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {
            -- IMPORTANT: You must enable the picker for dashboard search actions to work
            picker = { enabled = true },
            dashboard = {
                enabled = true,
                sections = {
                    { section = "header" },
                    { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },

                    -- FIXED: Added colon so it runs as a command
                    { icon = " ", key = "n", desc = "New File (Oil)", action = ":Oil" },

                    { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },

                    { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('recent')" },

                    { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },

                    { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy" },

                    { icon = " ", key = "q", desc = "Quit", action = ":qa" },
                    { section = "startup" },
                },
            },
            notifier = { enabled = true },
            input = { enabled = true },
        },
    },
}
