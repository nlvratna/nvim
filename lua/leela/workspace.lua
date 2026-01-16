--[[
A Neovim implementation of ThePrimeagen's tmux-sessionizer
Inspired by:
- tmux-sessionizer: https://github.com/ThePrimeagen/tmux-sessionizer
- The picker code pattern is borrowed from telescope.nvim: https://github.com/nvim-telescope/telescope.nvim/blob/master/lua/telescope/builtin/__files.lua#L269

Session management patterns borrowed from:
These are similar projects to this:
- persistence.nvim: https://github.com/folke/persistence.nvim
- auto-session: https://github.com/rmagatti/auto-session
]]

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local conf = require("telescope.config").values
local uv = vim.loop or vim.uv

-- local M = {}

local config = {}

local setup = function(opts)
  local home = assert(uv.os_homedir())
  local defaults = {
    dir = vim.fn.stdpath("run") .. "/sessions/",
    search_dirs = { home },
    max_depth = 3,
    home = home,
    ignore_dirs = { "node_modules", ".git", "venv", "__pycache__", "target" },
    hidden = false,
  }
  config = vim.tbl_deep_extend("force", {}, defaults, opts or {})

  vim.api.nvim_create_user_command("WorkspaceSwitch", function()
    switch_workspace()
  end, {})
end

--https://github.com/folke/persistence.nvim/blob/main/lua/persistence/init.lua
---@return string
local function file_name()
  vim.fn.mkdir(config.dir, "p")
  local name = vim.fn.getcwd():gsub("[\\/:]+", "%%")
  return config.dir .. name .. ".vim"
end

local function cleanup()
  --https://github.com/rmagatti/auto-session/blob/main/lua/auto-session/lib.lua#L917
  vim.cmd("silent %bw!")

  --https://github.com/rmagatti/auto-session/blob/main/lua/auto-session/init.lua#L819
  --TODO : manually clean lua_ls and start it based on ft type maybe using auto_cmd
  local clients = vim.lsp.get_clients()
  if #clients > 0 then
    vim.lsp.stop_client(clients)
  end
end

local function save()
  local file = file_name()
  vim.cmd("mks! " .. vim.fn.fnameescape(file))
  cleanup()
end

local function restore()
  local file = file_name()
  if file and vim.fn.filereadable(file) ~= 0 then
    vim.cmd("silent! source " .. vim.fn.fnameescape(file))
  end
end

local switch_workspace = function(opts)
  opts = opts or {}
  opts = vim.tbl_deep_extend("force", config, opts)

  -- Expand directories
  local expanded_dirs = {}
  for _, dir in ipairs(opts.search_dirs) do
    table.insert(expanded_dirs, vim.fn.expand(dir))
  end

  -- Build find command with ignore patterns
  local cmd
  if vim.fn.executable("fd") == 1 then
    cmd = {
      "fd",
      ".",
      "--type",
      "d",
      "--max-depth",
      tostring(opts.max_depth),
    }
    -- Add ignore patterns for fd
    for _, pattern in ipairs(opts.ignore_dirs) do
      vim.list_extend(cmd, { "--exclude", pattern })
    end
    if opts.hidden then
      table.insert(cmd, "--hidden")
    end
    vim.list_extend(cmd, expanded_dirs)
  elseif vim.fn.executable("find") == 1 then
    cmd = { "find" }
    vim.list_extend(cmd, expanded_dirs)

    if not opts.hidden then
      table.insert(cmd, { "-not", "-path", "*/.*" })
    end

    vim.list_extend(cmd, { "-maxdepth", tostring(opts.max_depth), "-type", "d" })
    for i, pattern in ipairs(opts.ignore_dirs) do
      if i == 1 then
        vim.list_extend(cmd, { "!", "(", "-name", pattern })
      else
        vim.list_extend(cmd, { "-o", "-name", pattern })
      end
    end
    if #opts.ignore_dirs > 0 then
      vim.list_extend(cmd, { ")", "-prune", "-o", "-type", "d", "-print" })
    end
  else
    vim.notify("fd or find is required", vim.log.levels.ERROR)
    return
  end

  pickers
    .new(opts, {
      prompt_title = "Switch Workspace",
      finder = finders.new_oneshot_job(cmd, {
        entry_maker = function(entry)
          if not entry or entry == "" then
            return nil
          end

          -- Remove home directory prefix for cleaner display
          local display = entry
          if entry:sub(1, #opts.home) == opts.home then
            display = "~" .. entry:sub(#opts.home + 1)
          end

          return {
            value = entry,
            display = display,
            ordinal = display,
          }
        end,
      }),
      sorter = conf.file_sorter(opts),
      attach_mappings = function(prompt_bufnr, _)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          if not selection then
            return
          end

          local path = selection.value
          save()
          vim.fn.chdir(path)
          restore()
        end)
        return true
      end,
    })
    :find()
end

vim.api.nvim_create_user_command("WorkspaceSwitch", function()
  setup()
  switch_workspace()
end, {})
vim.keymap.set("n", "<leader>w", ":WorkspaceSwitch<CR>", { silent = true })
--if I create a global scratch buffer create a autocmd that grabs the buffer number of that scratch and doesn't delete it contents
