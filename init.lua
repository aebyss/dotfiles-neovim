-- Leader key
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

-- Plugins
require("lazy").setup("plugins")
require("config.lsp")

-- === Base Settings ===
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- === LSP: clangd (modern API) ===
local capabilities = require("cmp_nvim_lsp").default_capabilities()
vim.lsp.config("clangd", { cmd = { "clangd" }, capabilities = capabilities })
vim.lsp.enable("clangd")

-- === nvim-cmp ===
local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
  snippet = {
    expand = function(args) luasnip.lsp_expand(args.body) end,
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

-- === cmp-vimtex (only in .tex files) ===
cmp.setup.filetype("tex", {
  sources = cmp.config.sources({
    { name = "vimtex" },
    { name = "buffer" },
  }),
})

-- === Colors ===
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    vim.cmd("colorscheme darkblue")
    vim.cmd("highlight Normal guibg=NONE ctermbg=NONE")
  end,
})

-- === Terminal ===
-- Open terminal below current window
vim.keymap.set("n", "<leader>tt", function()
  vim.cmd("belowright split | terminal")
  vim.cmd("resize 15")     -- optional: fixed height
  vim.cmd("startinsert")
end, { desc = "Open terminal below" })

-- Or open vertical terminal
vim.keymap.set("n", "<leader>tv", function()
  vim.cmd("vsplit | terminal")
  vim.cmd("startinsert")
end, { desc = "Open terminal on right" })

-- Exit terminal mode quickly
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })

-- === Window Navigation ===
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- === Telescope (project-aware search) ===
local telescope = require('telescope.builtin')

-- Grep inside the Git project (not entire FS)
vim.keymap.set("n", "<leader>pg", function()
  local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
  if git_root and #git_root > 0 then
    telescope.live_grep({ cwd = git_root })
  else
    telescope.live_grep()
  end
end, { desc = "Telescope: Grep in project" })

-- Find files in project root
vim.keymap.set("n", "<leader>pf", function()
  local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
  if git_root and #git_root > 0 then
    telescope.find_files({ cwd = git_root })
  else
    telescope.find_files()
  end
end, { desc = "Telescope: Find files in project" })

-- Fuzzy find only current buffer
vim.keymap.set("n", "<leader>pb", telescope.current_buffer_fuzzy_find, { desc = "Telescope: Search current buffer" })

-- === nvim-tree integration ===
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { noremap = true, silent = true, desc = "Toggle file explorer" })
vim.keymap.set("n", "<leader>r", ":NvimTreeFocus<CR>",  { noremap = true, silent = true, desc = "Focus file explorer" })

