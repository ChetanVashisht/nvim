return {
    'wincent/command-t',
    lazy = false,
    build = 'make -C lua/wincent/commandt/lib',
    init = function()
        vim.g.CommandTPreferredImplementation = 'lua'
    end,
    config = function(_, opts)
        require('wincent.commandt').setup({
            ignore_case = true,
            smart_case = true,
            order = 'forward',
            position = 'bottom',
        })
    end
}
