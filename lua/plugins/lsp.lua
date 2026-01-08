-- Adapted from a combo of
-- https://lsp-zero.netlify.app/v3.x/blog/theprimeagens-config-from-2022.html
-- https://github.com/ThePrimeagen/init.lua/blob/master/lua/theprimeagen/lazy/lsp.lua

return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "mason-org/mason.nvim",
        "mason-org/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
    },
    config = function()
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities()
        )

        require("fidget").setup({})
        require("mason").setup()

        require('mason-lspconfig').setup({
            ensure_installed = {
                "lua_ls",
                "phpactor",
                "intelephense",
                "psalm",
                "ts_ls"
            },
            automatic_enable = {
                exclude = {
                    "phpactor",
                },
            },
        })

        vim.lsp.config('intelephense', {
            settings = {
                intelephense = {
                    stubs = {
                        "apache",
                        "bcmath",
                        "bz2",
                        "calendar",
                        "com_dotnet",
                        "Core",
                        "ctype",
                        "curl",
                        "date",
                        "dba",
                        "dom",
                        "enchant",
                        "exif",
                        "FFI",
                        "fileinfo",
                        "filter",
                        "fpm",
                        "ftp",
                        "gd",
                        "gettext",
                        "gmp",
                        "hash",
                        "iconv",
                        "imap",
                        "intl",
                        "json",
                        "ldap",
                        "libxml",
                        "mbstring",
                        "meta",
                        "mysqli",
                        "oci8",
                        "odbc",
                        "openssl",
                        "pcntl",
                        "pcre",
                        "PDO",
                        "pdo_ibm",
                        "pdo_mysql",
                        "pdo_pgsql",
                        "pdo_sqlite",
                        "pgsql",
                        "Phar",
                        "posix",
                        "pspell",
                        "random",
                        "readline",
                        "Reflection",
                        "session",
                        "shmop",
                        "SimpleXML",
                        "snmp",
                        "soap",
                        "sockets",
                        "sodium",
                        "SPL",
                        "sqlite3",
                        "standard",
                        "superglobals",
                        "sysvmsg",
                        "sysvsem",
                        "sysvshm",
                        "tidy",
                        "tokenizer",
                        "xml",
                        "xmlreader",
                        "xmlrpc",
                        "xmlwriter",
                        "xsl",
                        "Zend OPcache",
                        "zip",
                        "zlib",
                        "ssh2",
                        "sqlsrv"
                    }
                }
            }
        })

        vim.lsp.config('ts-ls', {})
        vim.lsp.config('psalm', {
            -- cmd = { "podman","compose","exec","php","/usr/share/php/psalm/psalm-language-server","-r=/app","--map-folder=/app:$PWD" },
        })
        vim.lsp.config('phpactor', {
            init_options = {
                ['logging.enabled'] = true,
                ['logging.level'] = 'debug',
                ['logging.path'] = 'phpactor.log',
        }
        })
        vim.lsp.enable('hls')
        vim.lsp.config('lua_ls', {
            on_init = function(client)
                if client.workspace_folders then
                    local path = client.workspace_folders[1].name
                    if
                        path ~= vim.fn.stdpath('config')
                        and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
                    then
                        return
                    end
                end

                client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                    runtime = {
                        -- Tell the language server which version of Lua you're using (most
                        -- likely LuaJIT in the case of Neovim)
                        version = 'LuaJIT',
                        -- Tell the language server how to find Lua modules same way as Neovim
                        -- (see `:h lua-module-load`)
                        path = {
                            'lua/?.lua',
                            'lua/?/init.lua',
                        },
                    },
                    -- Make the server aware of Neovim runtime files
                    workspace = {
                        checkThirdParty = false,
                        library = {
                            vim.env.VIMRUNTIME
                            -- Depending on the usage, you might want to add additional paths
                            -- here.
                            , '${3rd}/luv/library'
                            -- '${3rd}/busted/library'
                        }
                        -- Or pull in all of 'runtimepath'.
                        -- NOTE: this is a lot slower and will cause issues when working on
                        -- your own configuration.
                        -- See https://github.com/neovim/nvim-lspconfig/issues/3189
                        -- library = {
                        --   vim.api.nvim_get_runtime_file('', true),
                        -- }
                    }
                })
            end,
            settings = {
                Lua = {}
            }
        })
        local cmp = require('cmp')
        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        -- this is the function that loads the extra snippets to luasnip
        -- from rafamadriz/friendly-snippets
        require('luasnip.loaders.from_vscode').lazy_load()

        cmp.setup({
            sources = {
                { name = 'path' },
                { name = 'nvim_lsp' },
                { name = 'luasnip', keyword_length = 2 },
                { name = 'buffer',  keyword_length = 3 },
            },
            mapping = cmp.mapping.preset.insert({
                -- ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                -- ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<CR>'] = cmp.mapping.confirm({ select = true }),
                -- ['<C-Space>'] = cmp.mapping.complete(),
            }),
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body)
                end,
            },
        })
    end
}
