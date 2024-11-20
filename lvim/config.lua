lvim.transparent_window = true
vim.opt.relativenumber = true

lvim.builtin.treesitter.ensure_installed = {
  "php",
}

-------------------
---  Formtting  ---
-------------------
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  {
    command = "phpcsfixer",
    filetypes = { "php" },
    args = {
      "--rules=@Symfony",
      "--using-cache=no",
      "--no-interaction",
      "fix",
    },
    stdin = false,
  },
}
lvim.format_on_save = {
  pattern = { "*.php" },
}


-------------------
---   Linters   ---
-------------------
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  {
    command = "phpcs",
    filetypes = { "php" },
  },
}

-------------------
---     LSP     ---
-------------------
local lsp_manager = require("lvim.lsp.manager")
lsp_manager.setup("phpactor")
local dap = require("dap")
local mason_path = vim.fn.glob(vim.fn.stdpath("data") .. "/mason/")
dap.adapters.php = {
  type = "executable",
  command = "node",
  args = { mason_path .. "packages/php-debug-adapter/extension/out/phpDebug.js" },
}
dap.configurations.php = {
  {
    name = "Listen for Xdebug",
    type = "php",
    request = "launch",
    port = 9003,
  },
  {
    name = "Debug currently open script",
    type = "php",
    request = "launch",
    port = 9003,
    cwd = "${fileDirname}",
    program = "${file}",
    runtimeExecutable = "php",
  },
}

-------------------
---   Plugins   ---
-------------------
lvim.plugins = {
  {
    "rcarriga/nvim-notify",
    config = function()
      local notify = require "notify"
      require("notify").setup({
        background_colour = "#123456",
        fps = 165,
        render = "compact",
      })
    end,
  },
  {
    'projekt0n/github-nvim-theme',
    name = 'github-theme',
    lazy = false,
    priority = 1000,
    config = function()
      require('github-theme').setup()
      lvim.colorscheme = "github_dark_colorblind"
    end,
  },
  {
    "ggandor/leap.nvim",
    name = "leap",
    config = function()
      require("leap").add_default_mappings()
    end,
  },
  {
    "wfxr/minimap.vim",
    build = "cargo install --locked code-minimap",
    config = function()
      vim.cmd("let g:minimap_width = 10")
      vim.cmd("let g:minimap_auto_start = 1")
      vim.cmd("let g:minimap_auto_start_win_enter = 1")
      vim.api.nvim_set_keymap("n", "<Tab>", ":MinimapToggle<cr>", { silent = true })
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    ---@module "ibl"
    ---@type ibl.config
    opts = {},
  },
  {
    "f-person/git-blame.nvim",
    event = "VeryLazy",
    opts = {
        enabled = true,
        message_template = " <summary> • <date> • <author> • <<sha>>",
        virtual_text_column = 1,
    },
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "InsertEnter",
    opts = {
      bind = true,
      handler_opts = {
        border = "rounded"
      },
    },
    config = function(_, opts) require'lsp_signature'.setup(opts) end
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {

    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup({
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
          }
        },
        presets = {
          command_palette = true,
          lsp_doc_border = true,
        }
      })
    end,
  },
}
