return {
  {
    "mason-org/mason.nvim",
    build = ":MasonUpdate",
    dependencies = {
      "mason-org/mason-lspconfig.nvim",
      -- "ttytm/mason-lspconfig.nvim", branch = "ts-ls",
    },
    lazy = false,
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✔︎",
            package_pending = "➔",
            package_uninstalled = "✗"
          }
        }
      })

      require("mason-lspconfig").setup{
        -- list of servers for mason to install
        automatic_enable = {
          -- "ts-ls",
          "html",
          "cssls",
          "tailwindcss",
          "svelte",
          "lua_ls",
          "graphql",
          "emmet_ls",
          "prismals",
          -- "pyright",
          "eslint",
          "jedi_language_server"
        },
        -- auto-install configured servers (with lspconfig)
        -- automatic_enable = true, -- not the same as ensure_installed
      }
      -- require("mason-lspconfig").setup()
      --
      -- require("mason-lspconfig").setup_handlers({
	     --  function(server_name)
      --     if server_name == "tsserver" then
      --       server_name = "ts-ls"
      --     end
		    --   local capabilities = require("cmp_nvim_lsp").default_capabilities()
		    --   require("lspconfig")[server_name].setup({
			   --    capabilities = capabilities,
		    --   })
	     --  end,
      -- })
    end
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      { "antosha417/nvim-lsp-file-operations", config = true },
    },
    config = function()
      -- import cmp-nvim-lsp plugin
      local cmp_nvim_lsp = require('cmp_nvim_lsp')

      -- import lspconfig plugin
      local lspconfig = require("lspconfig")

      local keymap = vim.keymap -- for conciseness

      local opts = { noremap = true, silent = true }
      local on_attach = function(_, bufnr)
        opts.buffer = bufnr

        -- set keybinds
        opts.desc = "Show LSP references"
        keymap.set('n', '<leader>gR', "<cmd>Telescope lsp_references<CR>", opts)

        opts.desc = "Go to declaration"
        keymap.set('n', '<leader>gD', vim.lsp.buf.declaration, opts)

        opts.desc = "Show LSP definitions"
        keymap.set("n", "<leader>gd", "<cmd>Telescope lsp_definitions<CR>", opts)

        opts.desc = "Show LSP implementations"
        keymap.set("n", "<leader>gi", "<cmd>Telescope lsp_implementations<CR>", opts)

        opts.desc = "Show LSP type definitions"
        keymap.set("n", "<leader>gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

        opts.desc = "See available code actions"
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

        opts.desc = "Smart rename"
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

        opts.desc = "Show buffer diagnostics"
        keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

        opts.desc = "Show line diagnostics"
        keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

        opts.desc = "Go to previous diagnostic"
        keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

        opts.desc = "Go to next diagnostic"
        keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

        opts.desc = "Show documentation for what is under cursor"
        keymap.set("n", "K", vim.lsp.buf.hover, opts)

        opts.desc = "Restart LSP"
        keymap.set('n', '<leader>rs', "<cmd>LspRestart<CR>", opts)
      end

      -- used to enable autocompletion (assign to every lsp server config)
      local capabilities = cmp_nvim_lsp.default_capabilities()

      -- Change the Diagnostic symbols in the sign column (gutter)
      -- (not in youtube nvim video)
      local signs = { Error = "", Warn = "", Hint = "󰠠 ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end

      -- configure html server
      lspconfig["html"].setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      -- configure typescript server with plugin
      -- lspconfig["tsserver"].setup({
      --   capabilities = capabilities,
      --   on_attach = on_attach,
      -- })

      lspconfig["ts_ls"].setup({
        require("plugins.servers.ts_ls"),
        on_attach = on_attach,
      })

      -- configure css server
      lspconfig["cssls"].setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      -- configure tailwindcss server
      lspconfig["tailwindcss"].setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      -- configure svelte server
      lspconfig["svelte"].setup({
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          on_attach(client, bufnr)

          vim.api.nvim_create_autocmd("BufWritePost", {
            pattern = { "*.js", "*.ts" },
            callback = function(ctx)
              if client.name == "svelte" then
                client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.file })
              end
            end,
          })
        end,
      })

      -- configure prisma orm server
      lspconfig["prismals"].setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      -- configure graphql language server
      lspconfig["graphql"].setup({
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
      })

      -- configure emmet language server
      lspconfig["emmet_ls"].setup({
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
      })

      lspconfig["jedi_language_server"].setup({
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { "python" },
      })

      -- configure python server
      --[[ lspconfig["pylsp"].setup({
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { "python" },
      }) ]]

      -- configure python server
      --[[ lspconfig["pyright"].setup({
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { "python" },
      }) ]]

      -- configure lua server (with special settings)
      lspconfig["lua_ls"].setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = { -- custom settings for lua
          Lua = {
            -- make the language server recognize "vim" global
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              -- make language server aware of runtime files
              library = {
                [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                [vim.fn.stdpath("config") .. "/lua"] = true,
              },
            },
          },
        },
      })

      lspconfig["sourcekit"].setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })
    end
  },
}
