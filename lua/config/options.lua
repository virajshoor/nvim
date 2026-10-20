-- Options are automatically loaded before lazy.nvim startup
-- Default options: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

local opt = vim.opt

-- Cursor shows plain line numbers, so drop the relative column.
-- Flip this back to `true` if you miss `5j` / `12k` motions.
opt.relativenumber = false

-- Share the macOS clipboard, so Cmd+C in the terminal and `y` in Neovim
-- reach for the same buffer.
opt.clipboard = "unnamedplus"

-- Editor feel closer to Cursor's defaults.
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.cursorline = true
opt.splitkeep = "screen"
opt.confirm = true

-- Cursor's tab defaults.
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2

-- Let Option+arrow reach Neovim as <M-...> rather than composing characters.
opt.ttimeoutlen = 10

-- Snappier which-key / mapped-sequence timeout.
opt.timeoutlen = 300

-- Gentle cursor blink (terminal must allow blinking); keeps the default shapes.
opt.guicursor = "n-v-c-sm:block-blinkwait700-blinkoff400-blinkon250,i-ci-ve:ver25-blinkwait700-blinkoff400-blinkon250,r-cr-o:hor20"

-- Terminal tab shows the file and project instead of "nvim".
opt.title = true
opt.titlestring = "%t — %{fnamemodify(getcwd(), ':t')}"

-- <C-o>/<C-i> behave like a browser's back/forward and restore the viewport.
opt.jumpoptions = "stack,view"

-- Cleaner diffs: histogram algorithm plus line-level matching inside hunks.
opt.diffopt:append({ "algorithm:histogram", "linematch:60" })

-- :s/foo/bar shows every match, including off-screen ones, in a live preview split.
opt.inccommand = "split"

-- Wrapped lines (markdown, etc.) scroll by screen line and keep their indent.
opt.smoothscroll = true
opt.breakindent = true
opt.linebreak = true
opt.showbreak = "↪ "

-- Lets bufferline reveal close buttons on hover.
opt.mousemoveevent = true
