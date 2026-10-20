return {
  -- Editor tabs across the top, the way Cursor shows open files.
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        always_show_bufferline = true,
        show_buffer_close_icons = true,
        separator_style = "thin",
        hover = { enabled = true, delay = 120, reveal = { "close" } }, -- needs mousemoveevent
        offsets = {
          {
            filetype = "neo-tree",
            text = "Explorer",
            highlight = "Directory",
            text_align = "left",
          },
        },
      },
    },
  },

  -- Status line: keep LazyVim's layout, drop the noisy encoding/format block.
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.options = opts.options or {}
      opts.options.globalstatus = true
      opts.options.section_separators = { left = "", right = "" }
      opts.options.component_separators = { left = "", right = "" }
      opts.sections.lualine_y = { { "progress", separator = " ", padding = { left = 1, right = 0 } } }
      opts.sections.lualine_z = { { "location", padding = { left = 0, right = 1 } } }
      return opts
    end,
  },

  {
    "folke/snacks.nvim",
    opts = {
      -- Command line and notifications rendered as floats, not a bottom bar.
      input = { enabled = true },
      notifier = { enabled = true, timeout = 2500, style = "compact" },
      -- Files you open often float to the top of the pickers.
      picker = { matcher = { frecency = true } },
      -- Smooth scrolling that eases out instead of moving linearly.
      scroll = {
        enabled = true,
        animate = { duration = { step = 10, total = 200 }, easing = "outQuad" },
      },
      -- Sole indent-guide renderer (indent-blankline extra removed); the scope line animates in.
      indent = {
        enabled = true,
        animate = { easing = "outQuad", duration = { step = 15, total = 300 } },
      },
      dashboard = {
        preset = {
          header = table.concat({
            "                                                   ",
            "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
            "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
            "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
            "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
            "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
            "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
          }, "\n"),
        },
      },
    },
  },

  -- Snappier, springier cursor smear with a light particle trail.
  {
    "sphamba/smear-cursor.nvim",
    opts = {
      stiffness = 0.8,
      trailing_stiffness = 0.5,
      damping = 0.8,
      anticipation = 0.15,
      stiffness_insert_mode = 0.7,
      trailing_stiffness_insert_mode = 0.7,
      -- Don't smear on tiny hops (h/l, typing); keeps big jumps feeling special.
      min_horizontal_distance_smear = 2,
      min_vertical_distance_smear = 2,
      particles_enabled = true,
      never_draw_over_target = true, -- required with particles / hide_target_hack
      particle_max_num = 40,
      particles_per_second = 120,
      particle_max_lifetime = 250,
      particle_gravity = -10, -- drift up like embers rather than fall
      filetypes_disabled = { "snacks_dashboard", "neo-tree", "lazy", "mason" },
    },
  },

  -- Animate window open/close/resize. Cursor and scroll stay with smear-cursor and snacks.
  {
    "nvim-mini/mini.animate",
    event = "VeryLazy",
    opts = function()
      local animate = require("mini.animate")
      local timing = animate.gen_timing.cubic({ easing = "out", duration = 120, unit = "total" })
      return {
        cursor = { enable = false },
        scroll = { enable = false },
        resize = { timing = timing },
        open = { timing = timing },
        close = { timing = timing },
      }
    end,
  },

  -- Rounded completion menu, docs and signature help to match the other floats.
  {
    "saghen/blink.cmp",
    optional = true,
    opts = {
      completion = {
        menu = { border = "rounded" },
        documentation = { window = { border = "rounded" } },
      },
      signature = { window = { border = "rounded" } },
    },
  },

  {
    "folke/noice.nvim",
    opts = function(_, opts)
      opts.presets = vim.tbl_extend("force", opts.presets or {}, { lsp_doc_border = true })
      -- Hovering over nothing shouldn't pop a "No information available" toast.
      table.insert(opts.routes, { filter = { event = "notify", find = "No information available" }, opts = { skip = true } })
    end,
  },

  -- Quiet GitLens-style blame at the end of the current line.
  {
    "lewis6991/gitsigns.nvim",
    keys = {
      { "<leader>uB", "<Cmd>Gitsigns toggle_current_line_blame<CR>", desc = "Toggle Line Blame" },
    },
    opts = {
      current_line_blame = true,
      current_line_blame_opts = { delay = 600, virt_text_pos = "eol" },
      current_line_blame_formatter = "   <author>, <author_time:%R> · <summary>",
    },
  },

  -- Sticky scope header, capped so it never eats the screen.
  {
    "nvim-treesitter/nvim-treesitter-context",
    opts = { max_lines = 3, multiline_threshold = 1 },
  },

  -- Softer, less shouty diagnostics in the gutter and virtual text.
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        virtual_text = { spacing = 4, prefix = "●" },
        float = { border = "rounded", source = "if_many" },
        severity_sort = true,
      },
      inlay_hints = { enabled = true },
    },
  },
}
