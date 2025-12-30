return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "mason-org/mason.nvim",
    },
    config =function ()
        local dap = require('dap')
        local mason = require('mason')
        dap.defaults.php.exception_breakpoints = {"Warning", "Error", "Exception"}
        -- PHP https://github.com/xdebug/vscode-php-debug
        dap.adapters.php ={
            type = 'executable',
            command = 'node',
            args = {vim.fn.stdpath('data').."/mason/packages/php-debug-adapter/extension/out/phpDebug.js"}
        }
        dap.configurations.php = {
            {
                type = 'php',
                request = 'launch',
                name = 'Listen for Xdebug',
                port = 9003
            },
        }
    end
}
