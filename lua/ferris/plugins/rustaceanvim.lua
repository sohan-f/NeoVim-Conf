return {
    {
        "mrcjkb/rustaceanvim",
        version = "^7",
        dependencies = {
            "mfussenegger/nvim-dap",
        },
        config = function()
            local codelldb = vim.fn.exepath("codelldb")
            local liblldb = nil

            -- Termux detection
            if vim.uv.os_uname().sysname == "Linux" and vim.fn.has("android") == 1 then
                liblldb = "/data/data/com.termux/files/usr/lib/liblldb.so"
            end

            vim.g.rustaceanvim = {
                server = {
                    settings = {
                        ["rust-analyzer"] = {
                            check = {
                                command = "clippy",
                            },
                            imports = {
                                granularity = {
                                    group = "module",
                                },
                                prefix = "self",
                            },
                            cargo = {
                                buildScripts = {
                                    enable = true,
                                },
                            },
                            procMacro = {
                                enable = true,
                            },
                        },
                    },
                },

                dap = {
                    adapter = require("rustaceanvim.config")
                        .get_codelldb_adapter(
                            codelldb ~= "" and codelldb or "codelldb",
                            liblldb
                        ),
                },
            }
        end,
    },
}
