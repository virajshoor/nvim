return {
  -- Option+D multi-cursor, the single biggest thing missing from vanilla Neovim.
  {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    -- stylua: ignore
    keys = {
      -- Option+D / Ctrl+N: add a cursor at the next occurrence of the word or selection
      { "<M-d>", function() require("multicursor-nvim").matchAddCursor(1) end, mode = { "n", "v" }, desc = "Add Cursor at Next Match (Option+D)" },
      { "<C-n>", function() require("multicursor-nvim").matchAddCursor(1) end, mode = { "n", "v" }, desc = "Add Cursor at Next Match" },
      -- Skip this occurrence and take the one after it.
      -- (No separate Ctrl fallback here: <C-S-n> and <C-n> collapse to the same
      -- terminal byte, so a second Ctrl chord would silently shadow the one above.)
      { "<M-S-d>", function() require("multicursor-nvim").matchSkipCursor(1) end, mode = { "n", "v" }, desc = "Skip Match (Option+Shift+D)" },
      -- Option+Shift+L: a cursor on every occurrence at once
      { "<M-S-l>", function() require("multicursor-nvim").matchAllAddCursors() end, mode = { "n", "v" }, desc = "Select All Occurrences (Option+Shift+L)" },
      { "<leader>ma", function() require("multicursor-nvim").matchAllAddCursors() end, mode = { "n", "v" }, desc = "Select All Occurrences" },
      -- Stack a cursor on the line above/below - leader-only. Option+Up/Down is
      -- mini.move (below) and Ctrl+Option+Up/Down is top/bottom-of-file
      -- (keymaps.lua), so there's no free arrow chord left for this one.
      { "<leader>mk", function() require("multicursor-nvim").lineAddCursor(-1) end, mode = { "n", "v" }, desc = "Add Cursor Above" },
      { "<leader>mj", function() require("multicursor-nvim").lineAddCursor(1) end, mode = { "n", "v" }, desc = "Add Cursor Below" },
    },
    config = function()
      local mc = require("multicursor-nvim")
      mc.setup()

      -- These mappings only exist while more than one cursor is alive, so they
      -- never shadow the single-cursor bindings above.
      mc.addKeymapLayer(function(layer)
        layer({ "n", "v" }, "<left>", mc.prevCursor)
        layer({ "n", "v" }, "<right>", mc.nextCursor)
        layer("n", "<esc>", function()
          if not mc.cursorsEnabled() then
            mc.enableCursors()
          else
            mc.clearCursors()
          end
        end)
      end)

      local hl = vim.api.nvim_set_hl
      hl(0, "MultiCursorCursor", { link = "Cursor" })
      hl(0, "MultiCursorVisual", { link = "Visual" })
      hl(0, "MultiCursorSign", { link = "SignColumn" })
      hl(0, "MultiCursorMatchPreview", { link = "Search" })
      hl(0, "MultiCursorDisabledCursor", { reverse = true })
      hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
      hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
    end,
  },

  -- Option+Up / Option+Down to move the current line or selection.
  -- Left/right are left unbound so Option+arrow keeps moving by word.
  {
    "nvim-mini/mini.move",
    opts = {
      mappings = {
        left = "",
        right = "",
        down = "<M-Down>",
        up = "<M-Up>",
        line_left = "",
        line_right = "",
        line_down = "<M-Down>",
        line_up = "<M-Up>",
      },
    },
  },

  -- File tree tuned to behave like Cursor's Explorer.
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      close_if_last_window = true,
      popup_border_style = "rounded",
      window = {
        width = 32,
        mappings = {
          -- Cursor opens files on a single click / Enter, and previews with space.
          ["<space>"] = "none",
          ["<2-LeftMouse>"] = "open",
          ["<cr>"] = "open",
        },
      },
      filesystem = {
        follow_current_file = { enabled = true, leave_dirs_open = true },
        hijack_netrw_behavior = "open_default",
        use_libuv_file_watcher = true,
        filtered_items = {
          visible = true, -- show dotfiles, dimmed, like Cursor does
          hide_dotfiles = false,
          hide_gitignored = true,
        },
      },
      default_component_configs = {
        indent = { with_expanders = true, expander_collapsed = "", expander_expanded = "" },
        git_status = {
          symbols = {
            added = "",
            modified = "",
            deleted = "✖",
            renamed = "󰁕",
            untracked = "",
            ignored = "",
            unstaged = "󰄱",
            staged = "",
            conflict = "",
          },
        },
      },
    },
  },

  -- flash.nvim: jump anywhere on screen with a two-key label.
  -- LazyVim already binds `s`, `S` and `r`; this just widens where labels show up.
  {
    "folke/flash.nvim",
    opts = {
      labels = "asdfghjklqwertyuiopzxcvbnm",
      search = { multi_window = true },
      jump = { autojump = false },
      label = { rainbow = { enabled = true, shade = 5 } },
      modes = {
        -- Label f/t/F/T motions too, not just `s`.
        char = { jump_labels = true },
        search = { enabled = true },
      },
    },
  },
}
