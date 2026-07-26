-- require("leela.core")
-- require("leela.lazy")
-- require("vim._core.ui2").enable()

vim.loader.enable()

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

vim.opt.guicursor = ""
vim.cmd.syntax("enable")

vim.wo.number = true
vim.o.relativenumber = true

vim.o.background = "dark"
vim.o.showmode = true

vim.o.undofile = true

vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.shiftround = true
vim.o.expandtab = true
vim.o.autoindent = true

vim.o.backup = false
vim.o.writebackup = false

vim.o.incsearch = true
vim.o.hlsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "qf", "help" },
  callback = function()
    vim.keymap.set("n", "<Esc>", ":q<CR>", { buffer = true, silent = true })
  end,
})
-- vim.o.linebreak = true
-- vim.o.ignorecase = true
-- vim.o.smartcase = true
-- vim.o.shiftwidth = 4
-- vim.o.tabstop = 4
-- vim.o.softtabstop = 4
-- vim.o.expandtab = true
-- vim.o.scrolloff = 4
-- vim.o.sidescrolloff = 8
-- vim.o.cursorline = false
-- vim.o.splitbelow = true
-- vim.o.splitright = true
-- vim.o.hlsearch = false
-- vim.opt.termguicolors = true
-- vim.o.whichwrap = "bs<>[]hl"
-- vim.o.numberwidth = 2
-- vim.o.swapfile = false
-- vim.o.smartindent = true
-- vim.o.conceallevel = 0
-- vim.o.fileencoding = "utf-8"
-- vim.o.breakindent = true
-- vim.o.updatetime = 250
-- vim.o.timeoutlen = 300
-- vim.o.backup = false
-- vim.o.writebackup = false
-- vim.o.undofile = true
-- vim.o.completeopt = "menuone,noselect"
-- vim.opt.formatoptions:remove({ "c", "r", "o" })
--
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name = ev.data.spec.name
    local kind = ev.data.kind

    if name == "fff.nvim" and (kind == "install" or kind == "update") then
      if not ev.data.active then
        vim.cmd.packadd("fff.nvim")
      end

      require("fff.download").download_or_build_binary()
    elseif name == "nvim-treesitter" and (kind == "install" or kind == "update") then
      if not ev.data.active then
        vim.cmd.packadd("nvim-treesitter")
      end

      vim.cmd.TSUpdate()
    end
  end,
})

vim.pack.add({
  { src = "https://github.com/rose-pine/neovim", name = "rose-pine" },
  { src = "https://github.com/dmtrKovalenko/fff.nvim", name = "fff.nvim" },
  "https://github.com/stevearc/oil.nvim",
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/saghen/blink.lib",
  "https://github.com/saghen/blink.cmp",
  "https://github.com/numToStr/Comment.nvim",
  "https://github.com/stevearc/conform.nvim",
  "https://github.com/folke/lazydev.nvim",
})

require("rose-pine").setup({
  variant = "main", -- auto, main, moon, or dawn
  dark_variant = "main", -- main, moon, or dawn
  styles = {
    italic = false,
  },
  palette = {
    main = {
      base = "none",
    },
  },
})

vim.cmd("colorscheme rose-pine")

require("oil").setup()
vim.keymap.set("n", "-", ":Oil<CR>")

local opts = { noremap = true, silent = true }

-- Disable the spacebar key's default behavior in Normal and Visual modes
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set({ "n", "v", "x" }, "<leader>y", '"+y', opts)
vim.keymap.set({ "n", "v", "x" }, "<leader>p", '"+p', opts)

vim.keymap.set("n", "<leader>g", "v$%", opts)

-- Vertical scroll and center
vim.keymap.set("n", "<C-d>", "<C-d>zz", opts)
vim.keymap.set("n", "<C-u>", "<C-u>zz", opts)

-- Find and center
vim.keymap.set("n", "n", "nzzzv", opts)
vim.keymap.set("n", "N", "Nzzzv", opts)

-- Buffers
vim.keymap.set("n", "<leader>d", ":bdelete!<CR>", opts)

-- Stay in indent mode
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

-- Keep last yanked when pasting
vim.keymap.set("v", "p", '"_dP', opts)

vim.keymap.set(
  "n",
  "<leader>v",
  vim.diagnostic.open_float,
  { desc = "Open floating diagnostic message", silent = true, noremap = true }
)
vim.keymap.set("n", "<leader>t", vim.diagnostic.setqflist, opts)

local treesitter_languages = {
  "c",
  "css",
  "go",
  "html",
  "javascript",
  "json",
  "lua",
  "markdown",
  "markdown_inline",
  "python",
  "rust",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "odin",
}
require("nvim-treesitter").setup()

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local installed = {}
    for _, language in ipairs(require("nvim-treesitter").get_installed()) do
      installed[language] = true
    end

    local missing = {}
    for _, language in ipairs(treesitter_languages) do
      if not installed[language] then
        table.insert(missing, language)
      end
    end

    if #missing > 0 then
      require("nvim-treesitter").install(missing)
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = treesitter_languages,
  callback = function()
    pcall(vim.treesitter.start)
    vim.bo.indentexpr = [[v:lua.require'nvim-treesitter'.indentexpr()]]
  end,
})

vim.diagnostic.config({
  severity_sort = true,
  float = { border = "rounded", source = "if_many" },
  -- float = false,
  underline = { severity = vim.diagnostic.severity.ERROR },
  signs = vim.g.have_nerd_font and {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅚 ",
      [vim.diagnostic.severity.WARN] = "󰀪 ",
      [vim.diagnostic.severity.INFO] = "󰋽 ",
      [vim.diagnostic.severity.HINT] = "󰌶 ",
    },
  } or {},
  virtual_text = false,
  update_in_insert = false,
  jump = {
    on_jump = function(_, bufnr)
      vim.diagnostic.open_float({
        bufnr = bufnr,
        scope = "cursor",
        focus = false,
      })
    end,
  },
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.opt_local.wrap = true
    vim.cmd(math.max(math.min(vim.fn.line("$"), 10), 3) .. "wincmd _")
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("lsp-start", { clear = true }),
  callback = function()
    vim.cmd("silent! lsp enable")
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc, mode)
      mode = mode or "n"
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
    end

    map("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
    map("gr", vim.lsp.buf.references, "Show References")
    map("sd", vim.lsp.buf.document_symbol, "")
    map("<leader>o", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
    map("<C-l>", vim.lsp.buf.signature_help, "show help", "i")
  end,
})

vim.api.nvim_create_autocmd("LspDetach", {
  group = lsp_detach_group,
  callback = function()
    vim.lsp.buf.clear_references()
  end,
})

local cmp = require("blink-cmp")
cmp.build():pwait()

require("lazydev").setup({
  library = {
    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
  },
})

cmp.setup({
  keymap = {
    preset = "default",
  },

  appearance = {
    use_nvim_cmp_as_default = true,
    nerd_font_variant = "mono",
  },
  completion = {
    accept = {
      auto_brackets = {
        enabled = false,
      },
    },
    ghost_text = {
      enabled = false,
      show_with_selection = false,
      show_without_menu = false,
    },
    documentation = {
      auto_show = true,
      treesitter_highlighting = true,
    },

    menu = {
      auto_show = true,
      draw = {
        columns = {
          { "label", "label_description", gap = 1 },
          { "kind_icon", "kind" },
        },
        treesitter = { "lsp" },
      },
    },
  },

  cmdline = {
    enabled = true,
    completion = {
      menu = {
        auto_show = true,
      },
    },
  },
  sources = {
    -- add lazydev to your completion providers
    default = { "lazydev", "lsp", "path", "buffer" },
    providers = {
      lazydev = {
        name = "LazyDev",
        module = "lazydev.integrations.blink",
        score_offset = 100,
      },
    },
  },
})

vim.keymap.set("n", "<C-_>", require("Comment.api").toggle.linewise.current, opts)
vim.keymap.set("n", "<C-/>", require("Comment.api").toggle.linewise.current, opts)
vim.keymap.set(
  "v",
  "<C-_>",
  "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
  opts
)

vim.keymap.set(
  "v",
  "<C-/>",
  "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
  opts
)

require("conform").setup({
  formatters_by_ft = {
    -- go = { "gofumpt" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    javascriptreact = { "prettier" },
    typescriptreact = { "prettier" },
    css = { "prettier" },
    html = { "prettier" },
    json = { "prettier" },
    yaml = { "prettier" },
    liquid = { "prettier" },
    lua = { "stylua" },
    python = { "black" },
    java = { "google-java-format" },
    odin = { "odinfmt" },
  },
  format_on_save = {
    lsp_fallback = true,
    async = false,
    timeout_ms = 1000,
  },
})

vim.keymap.set("n", "<leader>f", function()
  require("fff").find_files()
end, { desc = "FFFind files" })
