return {
  'Grazfather/sexp.nvim',
  ft = { 'clojure', 'clojurescript', 'fennel' },
  config = function()
    require('sexp').setup({})
  end,
}
