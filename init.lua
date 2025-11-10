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

-- === Terminal: Toggle und Close ===
local function term_windows()
  local wins = {}
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].buftype == "terminal" then
      table.insert(wins, win)
    end
  end
  return wins
end

local function open_term_bottom()
  vim.cmd("belowright split | terminal")
  vim.cmd("resize 15")
  vim.cmd("startinsert")
end

local function toggle_term()
  local wins = term_windows()
  if #wins > 0 then
    -- Wenn nur Terminals offen sind, sorge für ein leeres Fenster
    if #wins == #vim.api.nvim_list_wins() then
      vim.cmd("enew")
    end
    for _, win in ipairs(wins) do
      vim.api.nvim_win_close(win, true) -- schließt nur das Fenster, Job läuft weiter
      -- Falls du den Terminal-Job beenden willst:
      -- local buf = vim.api.nvim_win_get_buf(win)
      -- vim.api.nvim_buf_delete(buf, { force = true })
    end
  else
    open_term_bottom()
  end
end

local function close_terminals()
  local wins = term_windows()
  if #wins == 0 then return end
  if #wins == #vim.api.nvim_list_wins() then
    vim.cmd("enew")
  end
  for _, win in ipairs(wins) do
    vim.api.nvim_win_close(win, true)
  end
end

vim.keymap.set("n", "<leader>tt", toggle_term, { desc = "Terminal toggeln" })
vim.keymap.set("n", "<leader>q",  close_terminals, { desc = "Alle Terminals schließen" })

-- Terminal: Escape zurück in Normal-Mode
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Terminal verlassen" })
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

