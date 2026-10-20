return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night", -- "night" | "storm" | "moon" | "day"
      -- Your terminal runs at 65% opacity with blur, so let that show through
      -- instead of painting a second background on top of it.
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
        comments = { italic = true },
        keywords = { italic = true },
      },
      lualine_bold = true,
      on_highlights = function(hl, c)
        -- Current line number pops in the accent colour.
        hl.CursorLineNr = { fg = c.orange, bold = true }
        -- Matching bracket gets an underline instead of a heavy block.
        hl.MatchParen = { fg = c.orange, bold = true, underline = true }
        -- Cursor draws a soft border between the editor and the sidebar.
        hl.WinSeparator = { fg = c.bg_highlight }
        -- Keep the floating-window borders readable against a transparent bg.
        hl.NormalFloat = { bg = "NONE" }
        hl.FloatBorder = { fg = c.blue0, bg = "NONE" }
        hl.FloatTitle = { fg = c.blue, bg = "NONE" }
      end,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight-night",
    },
  },
}
