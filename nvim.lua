local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- set leader key to space
vim.g.mapleader = " "
-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

---
-- General Keymaps --
local keymap = vim.keymap

-- set ; to :
keymap.set({ "n", "v" }, ";", ":", { desc = "Remap ; to :" })

-- editor
keymap.set("n", "<leader>wf", "<cmd>w!<CR>", { desc = "Write file" })
keymap.set("n", "<C-a>", "<ESC>ggVG", { desc = "Selecting all text" })
keymap.set("v", "<C-r>", '"hy:%s,<C-r>h,,g<left><left>', { desc = "Replace selected text" })
keymap.set("v", "<", "<gv", { desc = "Move selected text" })
keymap.set("v", ">", ">gv", { desc = "Move selected text" })

-- use jk to exit insert mode
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- clear search highlights
keymap.set("n", "<leader>nh", vim.cmd.nohl, { desc = "Clear search highlights" })

-- delete single character without copying into register
keymap.set("n", "x", '"_x', { desc = "Delete single character without copying into register" })

keymap.set("n", "n", "nzzzv", { desc = "Keep it centered" })
keymap.set("n", "N", "Nzzzv", { desc = "Keep it centered" })
keymap.set("v", "p", '"_dP', { desc = "Paste without copying into register" })

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", vim.cmd.close, { desc = "Close current split" }) -- close current split window
keymap.set("n", "<leader>j", "<C-w>j", { desc = "Move down" })
keymap.set("n", "<leader>k", "<C-w>k", { desc = "Move up" })
keymap.set("n", "<leader>h", "<C-w>h", { desc = "Move left" })
keymap.set("n", "<leader>l", "<C-w>l", { desc = "Move right" })
keymap.set("n", "<S-l>", vim.cmd.bnext, { desc = "Go to next buffer" })
keymap.set("n", "<S-h>", vim.cmd.bprevious, { desc = "Go to previous buffer" })
keymap.set("n", "<leader>q", vim.cmd.bdelete, { desc = "Close current buffer" }) -- close current split window
keymap.set("n", "<leader>Q", "<cmd>qa!<CR>", { desc = "Close all" }) -- close all window

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

---
-- General Options --
local opt = vim.opt

-- line numbers
opt.relativenumber = true -- show relative line numbers
opt.number = true -- shows absolute line number on cursor line (when relative number is on)

-- tabs & indentation
opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one
opt.scrolloff = 8 -- keep 8 lines below and above the cursor

-- line wrapping
opt.wrap = false -- disable line wrapping

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

-- cursor line
opt.cursorline = true -- highlight the current cursor line

-- appearance
opt.cmdheight = 0

-- turn on termguicolors for nightfly colorscheme to work
-- (have to use iterm2 or any other true color terminal)
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- turn off swapfile
opt.swapfile = false

vim.filetype.add({
  extension = {
    tpp = "cpp",
  },
})

require("lazy").setup({
  {
    "stevearc/aerial.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("aerial").setup({
        on_attach = function(bufnr)
          keymap.set("n", "{", "<cmd>AerialPrev<cr>", { buffer = bufnr })
          keymap.set("n", "}", "<cmd>AerialNext<cr>", { buffer = bufnr })
        end,
      })
      keymap.set("n", "<leader>a", "<cmd>AerialToggle!<cr>", { desc = "Open Aerial" })
    end,
  },
  {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local theme = require("alpha.themes.theta")
      theme.header.val = {
        "⠀⠀⠀⠀⠀⢀⣠⣴⠾⠟⠛⠛⠛⠛⠛⠷⣦⣄⡀⠀⠀⠀⠀⠀ ",
        "⠀⠀⠀⢀⣴⠟⣉⣠⣤⣤⣤⣤⣤⣄⡀⠀⠀⠉⠻⣦⡀⠀⠀⠀ ",
        "⠀⠀⣰⣿⣵⣿⣿⡿⠛⠉⠀⠀⠀⠀⠉⠑⠄⡀⠀⠈⢻⣆⠀⠀ ",
        "⠀⢰⡟⠹⣿⣿⣿⣷⣶⣦⣄⡀⢀⣠⣴⣶⣿⣿⣿⣿⣿⣿⠀⠀ ",
        "⠀⣿⠁⠀⢸⢿⣿⣿⣿⣿⠟⠉⠉⠻⣿⣿⣿⣿⡿⣿⣿⡏⣿⠀ ",
        "⠀⣿⠀⠀⢸⠀⠙⠻⣿⡇⠀⠀⠀⠀⢸⣿⠟⠉⠀⣿⣿⠀⣿⠇ ",
        "⠀⣿⡀⠀⢸⡄⠀⠀⠈⢻⣦⣀⣀⣤⣿⠁⠀⠀⢀⣿⠃⢀⣿⠀ ",
        "⠀⠸⣧⠀⠀⢿⡄⠀⠀⠸⣿⣿⣿⣿⡇⠀⠀⢀⡾⠃⠀⣼⠏⠀ ",
        "⠀⠀⠹⣷⡀⠈⢿⣶⣄⡀⢿⣿⣿⣿⢃⡠⠔⠋⠀⢀⣼⠏⠀⠀ ",
        "⠀⠀⠀⠈⠻⣦⣀⠙⢿⣿⣿⣿⣿⡏⠁⠀⠀⣀⣴⠟⠁⠀⠀⠀ ",
        "⠀⠀⠀⠀⠀⠈⠙⠻⠶⣯⣿⣿⣿⣤⣴⠶⠟⠋⠁⠀⠀⠀⠀⠀ ",
      }
      -- remove configuration button
      table.remove(theme.buttons.val, 6)
      -- do not show bufferline when alpha open
      theme.config.opts.setup = function()
        vim.api.nvim_create_autocmd("User", {
          pattern = "AlphaReady",
          desc = "disable tabline for alpha",
          callback = function()
            vim.opt.showtabline = 0
          end,
        })
        vim.api.nvim_create_autocmd("BufUnload", {
          buffer = 0,
          desc = "enable tabline after alpha",
          callback = function()
            vim.opt.showtabline = 2
          end,
        })
      end
      require("alpha").setup(theme.config)
    end,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },
  {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  {
    "folke/tokyonight.nvim",
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      vim.cmd.colorscheme("tokyonight-night")
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer", -- source for text in buffer
      "hrsh7th/cmp-path", -- source for file system paths
      {
        "L3MON4D3/LuaSnip", -- snippet engine
        version = "v2.*",
      },
      "saadparwaiz1/cmp_luasnip", -- for autocompletion
      "rafamadriz/friendly-snippets", -- useful snippets
      "onsails/lspkind.nvim", -- vs-code like pictograms
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")

      -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        completion = {
          completeopt = "menu,menuone,preview,noselect",
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-u>"] = cmp.mapping.scroll_docs(-4),
          ["<C-d>"] = cmp.mapping.scroll_docs(4),
          ["<CR>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              if luasnip.expandable() then
                luasnip.expand()
              else
                cmp.confirm({
                  select = true,
                })
              end
            else
              fallback()
            end
          end),

          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.locally_jumpable(1) then
              luasnip.jump(1)
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        -- sources for autocompletion
        sources = cmp.config.sources({
          { name = "nvim_lsp" }, -- lsp
          { name = "luasnip" }, -- snippets
          { name = "buffer" }, -- text within current buffer
          { name = "path" }, -- file system paths
        }),

        -- configure lspkind for vs-code like pictograms in completion menu
        formatting = {
          format = lspkind.cmp_format({
            maxwidth = 50,
            ellipsis_char = "...",
          }),
        },
      })
    end,
  },
  {
    "stevearc/dressing.nvim", -- for improving vim input experience
    event = "VeryLazy",
  },
  {
    "stevearc/conform.nvim",
    lazy = true,
    event = { "BufReadPre", "BufNewFile" }, -- to disable, comment this out
    config = function()
      local conform = require("conform")

      conform.setup({
        formatters_by_ft = {
          json = { "prettier" },
          -- yaml = { "yamlfix" },
          markdown = { "prettier" },
          lua = { "stylua" },
          go = { "goimports", "gofmt" },
          cpp = { "clang_format" },
          -- bzl = { "buildifier" },
        },
        formatters = {
          clang_format = {
            command = "clang-format",
          },
        },
        format_on_save = {
          lsp_fallback = true,
          async = false,
          timeout_ms = 1000,
        },
      })

      keymap.set({ "n", "v" }, "<leader>mp", function()
        conform.format({
          lsp_fallback = true,
          async = false,
          timeout_ms = 1000,
        })
      end, { desc = "Format file or range (in visual mode)" })
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      on_attach = function(bufnr)
        local gitsigns = require("gitsigns")

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map("n", "]c", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gitsigns.nav_hunk("next")
          end
        end)

        map("n", "[c", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gitsigns.nav_hunk("prev")
          end
        end)

        -- Actions
        map("n", "<leader>hs", gitsigns.stage_hunk)
        map("n", "<leader>hr", gitsigns.reset_hunk)
        map("v", "<leader>hs", function()
          gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end)
        map("v", "<leader>hr", function()
          gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end)
        map("n", "<leader>hS", gitsigns.stage_buffer)
        map("n", "<leader>hu", gitsigns.undo_stage_hunk)
        map("n", "<leader>hR", gitsigns.reset_buffer)
        map("n", "<leader>hp", gitsigns.preview_hunk)
        map("n", "<leader>hb", function()
          gitsigns.blame_line({ full = true })
        end)
        map("n", "<leader>tb", gitsigns.toggle_current_line_blame)
        map("n", "<leader>hd", gitsigns.diffthis)
        map("n", "<leader>hD", function()
          gitsigns.diffthis("~")
        end)
        map("n", "<leader>td", gitsigns.toggle_deleted)

        -- Text object
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
      end,
    },
  },
  {
    "mfussenegger/nvim-lint",
    lazy = true,
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        sh = { "shellcheck" },
        -- markdown = { "vale" },
      }

      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          lint.try_lint()
        end,
      })

      keymap.set("n", "<leader>l", function()
        lint.try_lint()
        -- lint.try_lint("cspell")
      end, { desc = "Trigger linting for current file" })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- import lspconfig plugin
      local lspconfig = require("lspconfig")

      -- import mason_lspconfig plugin
      local mason_lspconfig = require("mason-lspconfig")

      -- import cmp-nvim-lsp plugin
      local cmp_nvim_lsp = require("cmp_nvim_lsp")

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          -- Enable inlay hint.
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true)
          end

          -- Buffer local mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          local opts = { buffer = ev.buf, silent = true }

          -- set keybinds
          opts.desc = "Show LSP references"
          keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

          opts.desc = "Go to declaration"
          keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

          opts.desc = "Show LSP definitions"
          keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

          opts.desc = "Show LSP implementations"
          keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

          opts.desc = "Show LSP type definitions"
          keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

          opts.desc = "See available code actions"
          keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

          opts.desc = "Smart rename"
          keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

          opts.desc = "Show buffer diagnostics"
          keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

          opts.desc = "Show line diagnostics"
          keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

          opts.desc = "Go to previous diagnostic"
          keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

          opts.desc = "Go to next diagnostic"
          keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

          opts.desc = "Show documentation for what is under cursor"
          keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

          opts.desc = "Restart LSP"
          keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary

          opts.desc = "Toggle inlay hints"
          keymap.set("n", "<leader>dh", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ nil }))
          end, opts)

          opts.desc = "Lsp hover doc scrolling up"
          keymap.set({ "n", "i", "s" }, "<c-f>", function()
            if not require("noice.lsp").scroll(4) then
              return "<c-f>"
            end
          end, opts)

          opts.desc = "Lsp hover doc scrolling down"
          keymap.set({ "n", "i", "s" }, "<c-b>", function()
            if not require("noice.lsp").scroll(-4) then
              return "<c-b>"
            end
          end, opts)
        end,
      })

      -- used to enable autocompletion (assign to every lsp server config)
      local capabilities = cmp_nvim_lsp.default_capabilities()

      -- Change the Diagnostic symbols in the sign column (gutter)
      local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end

      mason_lspconfig.setup_handlers({
        -- default handler for installed servers
        function(server_name)
          lspconfig[server_name].setup({
            capabilities = capabilities,
          })
        end,
        ["clangd"] = function()
          lspconfig["clangd"].setup({
            capabilities = capabilities,
            cmd = { "clangd", "--offset-encoding=utf-16" },
            filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "h", "hpp" },
          })
        end,
        ["lua_ls"] = function()
          -- configure lua server (with special settings)
          lspconfig["lua_ls"].setup({
            capabilities = capabilities,
            settings = {
              Lua = {
                -- make the language server recognize "vim" global
                diagnostics = {
                  globals = { "vim" },
                },
                completion = {
                  callSnippet = "Replace",
                },
              },
            },
          })
        end,
      })
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local lualine = require("lualine")
      lualine.setup({
        options = {
          theme = "tokyonight-night",
        },
      })
    end,
  },
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
      -- import mason
      local mason = require("mason")
      local mason_lspconfig = require("mason-lspconfig")

      local mason_tool_installer = require("mason-tool-installer")

      -- enable mason and configure icons
      mason.setup({
        PATH = "append",
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })

      mason_lspconfig.setup({
        -- list of servers for mason to install
        ensure_installed = {
          "lua_ls",
          "clangd",
        },
      })

      mason_tool_installer.setup({
        ensure_installed = {
          -- "prettier", -- prettier formatter
          "stylua", -- lua formatter
          "clang-format", -- cpp formatter
          "vale", -- markdown formatter
          "shellcheck", -- shell formatter
          "clangd", -- cpp lsp
          "rust_analyzer", -- rust lsp
          -- "gopls", -- go lsp
          -- "cspell", -- code spellchecker
          -- "buildifier", -- bazel formatter
          -- "yamlfix", -- yaml formatter
        },
      })
    end,
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      local noice = require("noice")
      noice.setup({
        lsp = {
          -- override markdown rendering
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        presets = {
          bottom_search = true, -- use a classic bottom cmdline for search
          command_palette = true, -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false, -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = true, -- add a border to hover docs and signature help
        },
      })
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- change color for arrows in tree to light blue
      vim.cmd.highlight("NvimTreeFolderArrowClosed guifg=#3FC5FF")
      vim.cmd.highlight("NvimTreeFolderArrowOpen guifg=#3FC5FF")

      require("nvim-tree").setup({})

      keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" }) -- toggle file explorer
      keymap.set(
        "n",
        "<leader>ef",
        "<cmd>NvimTreeFindFileToggle<CR>",
        { desc = "Toggle file explorer on current file" }
      ) -- toggle file explorer on current file
      keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" }) -- collapse file explorer
      keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" }) -- refresh file explorer
    end,
  },
  {
    "lambdalisue/suda.vim",
    config = function()
      keymap.set("n", "<leader>sr", "<cmd>SudaRead<CR>", { desc = "Read with sudo" })
      keymap.set("n", "<leader>sw", "<cmd>SudaWrite<CR>", { desc = "Write with sudo" })
    end,
  },
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({})
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-live-grep-args.nvim",
    },
    config = function()
      local telescope = require("telescope")
      local lga_actions = require("telescope-live-grep-args.actions")

      telescope.setup({
        defaults = {
          path_display = {
            "smart",
          },
        },
        extensions = {
          live_grep_args = {
            auto_quoting = true,
            mappings = {
              i = {
                ["<C-k>"] = lga_actions.quote_prompt(),
                ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
              },
            },
          },
        },
      })
      telescope.load_extension("live_grep_args")
      keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
      keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
      keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep_args<cr>", { desc = "Find string in cwd" })
      keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
    end,
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      function _G.set_terminal_keymaps()
        local opts = { buffer = 0 }
        keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
        keymap.set("t", "kj", [[<C-\><C-n>]], opts)
        keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
        keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
        keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
        keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
        keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
      end

      vim.cmd("autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()")
      require("toggleterm").setup({
        open_mapping = [[<c-\>]],
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    dependencies = {},
    config = function()
      -- import nvim-treesitter plugin
      local treesitter = require("nvim-treesitter.configs")

      -- configure treesitter
      treesitter.setup({ -- enable syntax highlighting
        highlight = {
          enable = true,
        },
        -- enable indentation
        indent = { enable = true },
        -- ensure these language parsers are installed
        ensure_installed = {
          "json",
          "javascript",
          "typescript",
          "tsx",
          "yaml",
          "html",
          "css",
          "prisma",
          "markdown",
          "markdown_inline",
          "svelte",
          "graphql",
          "bash",
          "lua",
          "vim",
          "dockerfile",
          "gitignore",
          "query",
          "rust",
        },
      })
    end,
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", "folke/todo-comments.nvim" },
    opts = {
      focus = true,
    },
    cmd = "Trouble",
    keys = {
      { "<leader>xw", "<cmd>Trouble diagnostics toggle<CR>", desc = "Open trouble workspace diagnostics" },
      {
        "<leader>xd",
        "<cmd>Trouble diagnostics toggle filter.buf=0<CR>",
        desc = "Open trouble document diagnostics",
      },
      { "<leader>xq", "<cmd>Trouble quickfix toggle<CR>", desc = "Open trouble quickfix list" },
      { "<leader>xl", "<cmd>Trouble loclist toggle<CR>", desc = "Open trouble location list" },
      { "<leader>xt", "<cmd>Trouble todo toggle<CR>", desc = "Open todos in trouble" },
    },
  },
  {
    "mbbill/undotree",
    config = function()
      keymap.set("n", "<leader>ut", vim.cmd.UndotreeToggle, { desc = "Toggle Undotree" })
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
  {
    "epwalsh/obsidian.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    version = "*",
    lazy = true,
    ft = "markdown",
    opts = {
      workspaces = {
        {
          name = "personal",
          path = "~/notes/personal",
        },
        {
          name = "work",
          path = "~/notes/work",
        },
      },
    },
    init = function()
      vim.opt.conceallevel = 1
    end,
  },
})
