return {
  -- Inline ghost-text completion. `vim.g.ai_cmp = false` (set in config/lazy.lua)
  -- makes this render the way Cursor's tab-complete does, rather than as items
  -- inside the completion menu. <Tab> accepts, Option+Right accepts one word.
  {
    "zbirenbaum/copilot.lua",
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = false, -- <Tab> handles this via LazyVim's ai_accept action
          accept_word = false, -- bound to Option+Right in config/keymaps.lua
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
        gitcommit = true,
        yaml = true,
        ["*"] = true,
      },
    },
  },

  -- Chat pane docked on the right, like Cursor's AI sidebar.
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    opts = {
      window = {
        layout = "vertical",
        width = 0.35,
        border = "rounded",
      },
      auto_insert_mode = true,
      show_help = false,
    },
  },
}
