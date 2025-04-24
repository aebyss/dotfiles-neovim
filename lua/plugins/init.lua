-- lua/plugins/init.lua

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

  -- Doom One (inkl. Miramar Vibes)
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
    end,
  },

-- Telescope
    {
        'nvim-telescope/telescope.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        version = '0.1.4',
    },
-- Treesitter für Syntaxhighlighting
{
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = { "lua", "c"},
      highlight = { enable = true },
      indent = { enable = true },
    })
  end,
},

}
