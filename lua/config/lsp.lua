-- lua/config/lsp.lua
-- ===============================================
-- Modern LSP configuration (Neovim ≥ 0.11)
-- ===============================================

-- Capabilities: shared between all servers
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Helper: create a common on_attach function
local function on_attach(client, bufnr)
  local opts = { buffer = bufnr, silent = true }

  -- Standard LSP mappings
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
  vim.keymap.set("n", "<leader>f", function()
    vim.lsp.buf.format({ async = true })
  end, opts)
end

-- === C / C++ (clangd) ===
vim.lsp.config("clangd", {
  cmd = { "clangd" },
  capabilities = capabilities,
  on_attach = on_attach,
})

-- === Lua (for Neovim config editing) ===
vim.lsp.config("lua_ls", {
  cmd = { "lua-language-server" },
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
    },
  },
})

-- === Java (jdtls) ===
vim.lsp.config("jdtls", {
  cmd = { "jdtls" },
  capabilities = capabilities,
  on_attach = on_attach,
  root_dir = vim.fs.root(0, { ".git", "mvnw", "gradlew" }),
})

-- === Python (pyright) ===
vim.lsp.config("pyright", {
  cmd = { "pyright-langserver", "--stdio" },
  capabilities = capabilities,
  on_attach = on_attach,
})

-- Enable all servers
vim.lsp.enable("clangd")
vim.lsp.enable("lua_ls")
vim.lsp.enable("jdtls")
vim.lsp.enable("pyright")

-- Optional diagnostics configuration
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

