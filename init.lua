-- Leader setzen
vim.g.mapleader = " "
vim.g.vimtex_complete_enabled = 1

-- lazy.nvim bootstrap
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

-- ==== clangd + Autocompletion Setup (Neue API) ====
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- 1. LSP konfigurieren
vim.lsp.config("clangd", {
  cmd = { "clangd" },
  capabilities = capabilities,
})

-- 2. Server aktivieren
vim.lsp.enable("clangd")

-- ==== nvim-cmp ====
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

-- cmp-vimtex nur in .tex aktivieren
cmp.setup.filetype("tex", {
  sources = cmp.config.sources({
    { name = "vimtex" },
    { name = "buffer" },
  }),
})

-- ==== Navigation / UI ====
vim.keymap.set('n', '<leader><Tab>', ':Ex<CR>', { silent = true, desc = "Open netrw (file explorer)" })

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    vim.cmd("colorscheme darkblue")
    vim.cmd("highlight Normal guibg=NONE ctermbg=NONE")
  end,
})

-- Netrw: Terminal öffnen mit "t"
vim.api.nvim_create_autocmd("filetype", {
  pattern = "netrw",
  callback = function()
    vim.keymap.set("n", "t", function()
      vim.cmd("split | terminal")
      vim.cmd("startinsert")
    end, { buffer = true, desc = "Open terminal below and start typing" })
  end
})

-- Terminal mode escape
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })

-- Window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- Telescope
local telescope = require('telescope.builtin')
vim.keymap.set('n', '<leader>pg', telescope.live_grep, { desc = "Telescope: Grep in project" })
vim.keymap.set('n', '<leader>pb', telescope.current_buffer_fuzzy_find, { desc = "Telescope: Search in current file" })
vim.keymap.set('n', '<leader>pf', telescope.find_files, { desc = "Telescope: Find Files" })

