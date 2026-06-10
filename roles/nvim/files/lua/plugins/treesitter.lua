local parsers = require('nvim-treesitter.parsers')
local configs = parsers.get_parser_configs and parsers.get_parser_configs() or {}
configs.microcad = {
  install_info = {
    url = '~/git/utilities/tree-sitter-grammars/microcad',
    -- optional entries
    files = { "src/parser.c" },
    generate = true,
    generate_from_json = false,
    -- queries = 'queries/neovim', -- symlink queries from given directory
  },
  filetype = 'microcad',
}
vim.treesitter.language.register('microcad', { 'mcad', 'ucad', 'µcad' })
vim.filetype.add({
  extension = {
    mcad = 'microcad',
    ucad = 'microcad',
    ['µcad'] = 'microcad',
  },
})
