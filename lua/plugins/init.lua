return {
  -- LSP Support
  { "neovim/nvim-lspconfig" },

  -- Autocompletion
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "L3MON4D3/LuaSnip" },
  { "saadparwaiz1/cmp_luasnip" },
  { "micangl/cmp-vimtex" },

  -- Lazy loading Snippets (optional)
  { "rafamadriz/friendly-snippets" },

  -- Copilot
  {
    "github/copilot.vim",
    lazy = false,
    config = function()
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true

      vim.keymap.set("i", "<C-j>", 'copilot#Accept("<CR>")', {
        expr = true,
        silent = true,
        noremap = true,
        replace_keycodes = false,
      })
    end,
  },

  -- Discord Presence
  {
    "andweeb/presence.nvim",
    lazy = false,
    config = function()
      require("presence").setup({
        auto_update = true,
        neovim_image_text = "Neovim in WSL 🧠",
        main_image = "file",
        log_level = nil,
        debounce_timeout = 10,
        enable_line_number = true,
        blacklist = {},
        buttons = true,
        show_time = true,
      })
    end,
  },

  -- Doom One Theme
  {
    "GustavoPrietoP/doom-themes.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.doom_one_terminal_colors = true
      vim.g.doom_one_italic_comments = true
      vim.g.doom_one_enable_treesitter = true
      vim.g.doom_one_transparent_background = true
    end,
  },

  -- LaTeX Support
  {
    "lervag/vimtex",
    lazy = false,
    init = function()
      vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_compiler_latexmk = {
        options = {
          "-shell-escape",
          "-interaction=nonstopmode",
          "-file-line-error",
          "-synctex=1",
        },
      }
    end,
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    version = "0.1.4",
  },

  -- Treesitter for syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "c" },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  -- File Explorer
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup({})
    end,
  },
}

