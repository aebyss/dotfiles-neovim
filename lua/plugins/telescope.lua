return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
    },
    {
      'jmbuhr/telescope-zotero.nvim',
      dependencies = {
        { 'kkharji/sqlite.lua' },
      },
      config = function()
        require('zotero').setup({})
        require('telescope').load_extension('zotero')
      end
    },
  },
  config = function()
    require('telescope').setup({})
    require('telescope').load_extension('fzf')
    -- zotero gets loaded inside its own config
  end,
}

