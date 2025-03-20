return {
    'nvim-telescope/telescope-project.nvim',
    dependencies = {
        'nvim-telescope/telescope.nvim',
    },
    after = 'telescope.nvim',
    config =function ()
        local project_actions = require("telescope._extensions.project.actions");
        require('telescope').setup {
            extensions = {
                project = {
                    base_dirs = {
                        {'~/Quizizz/', max_depth = 1},
                        {'~/Desktop/projects', max_depth = 1},
                    },
                    ignore_missing_dirs = true, -- default: false
                    hidden_files = true, -- default: false
                    theme = "dropdown",
                    order_by = "asc",
                    search_by = "title",
                    sync_with_nvim_tree = true, -- default false
                    mappings = {
                        n = {
                            ['d'] = project_actions.delete_project,
                            ['r'] = project_actions.rename_project,
                            ['c'] = project_actions.add_project,
                            ['C'] = project_actions.add_project_cwd,
                            ['f'] = project_actions.find_project_files,
                            ['b'] = project_actions.browse_project_files,
                            ['s'] = project_actions.search_in_project_files,
                            ['R'] = project_actions.recent_project_files,
                            ['w'] = project_actions.change_working_directory,
                            ['o'] = project_actions.next_cd_scope,
                        }
                    }
                }
            }
        }
    end
}
