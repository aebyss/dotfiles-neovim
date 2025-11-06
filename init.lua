-- init.lua
-- Leader setzen
vim.g.mapleader = " "

vim.g.vimtex_complete_enabled = 1

-- lazy.nvim bootstrap (lädt sich selbst, wenn nicht vorhanden)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugins laden
require("lazy").setup("plugins")


-- Basis-Settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- init.lua
-- Leader setzen
vim.g.mapleader = " "

-- lazy.nvim bootstrap (lädt sich selbst, wenn nicht vorhanden)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugins laden
require("lazy").setup("plugins")

-- Basis-Settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- ==== clangd + Autocompletion Setup ====
-- LSP
require("lspconfig").clangd.setup {
  capabilities = require("cmp_nvim_lsp").default_capabilities()
}

-- nvim-cmp
local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
})

-- Enable cmp-vimtex only in .tex files
cmp.setup.filetype("tex", {
  sources = cmp.config.sources({
    { name = "vimtex" },
    { name = "buffer" }, -- optional for general word completion
  }),
})


vim.keymap.set('n', '<leader><Tab>', ':Ex<CR>', { silent = true, desc = "Open netrw (file explorer)" })

-- Farben erst setzen, wenn Neovim komplett geladen ist
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    vim.cmd("colorscheme darkblue")
    vim.cmd("highlight Normal guibg=NONE ctermbg=NONE")
  end,
})

-- Netrw: open horizontal terminal split and auto-enter Insert mode
vim.api.nvim_create_autocmd("filetype", {
  pattern = "netrw",
  callback = function()
    vim.keymap.set("n", "t", function()
      vim.cmd("split | terminal")  -- open terminal in horizontal split
      vim.cmd("startinsert")       -- force insert mode after
    end, { buffer = true, desc = "Open terminal below and start typing" })
  end
})

-- Terminal mode escape to Normal with <Esc>
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })

-- Navigate between splits with Ctrl + h/j/k/l
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- Telescope grep commands
local telescope = require('telescope.builtin')

vim.keymap.set('n', '<leader>pg', telescope.live_grep, { desc = "Telescope: Grep in project" })
vim.keymap.set('n', '<leader>pb', telescope.current_buffer_fuzzy_find, { desc = "Telescope: Search in current file" })
vim.keymap.set('n', '<leader>pf', telescope.find_files, { desc = "Telescope: Find Files" })


