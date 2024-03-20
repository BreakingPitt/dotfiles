require('packer').startup(function()
    use {'wbthomason/packer.nvim'}
    use {'Mofiqul/dracula.nvim'}
    use {'nvim-tree/nvim-tree.lua',
        requires = {
           'nvim-tree/nvim-web-devicons', -- optional
        },
    }
    end)
