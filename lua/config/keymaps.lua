-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
--
-- Cursor-for-macOS parity layer - Option only, no Cmd anywhere.
--
-- Cmd used to be primary here, with Option as a fallback for the chords Termy's
-- terminal chrome swallowed. That's gone: every chord below is Option-based.
-- Three tiers, used in order of preference:
--   1. Option+<key>       - the default, used everywhere it's free.
--   2. Option+Shift+<key> - when a second action wants the same letter.
--   3. Ctrl+Option+<key>  - when tiers 1 and 2 are BOTH already taken by
--      something else (e.g. plain Option+F is Find and Option+Shift+F is
--      Search, so Format is Ctrl+Option+F; see CONFIGURATION.md's "Design
--      decisions" for the full list of what forced tier 3).
-- None of these are in Termy's default reserved-chord table (checked via
-- `strings` on the app binary - see CONFIGURATION.md), so nothing here
-- depends on ~/.config/termy/config.txt having anything unbound.
--
-- LazyVim's own <leader> keymaps are all still present and unchanged.

local map = vim.keymap.set

--- Bind one action to several chords at once.
---@param modes string|string[]
---@param keys string|string[]
local function bind(modes, keys, rhs, desc, opts)
  opts = vim.tbl_extend("force", { desc = desc, silent = true }, opts or {})
  for _, key in ipairs(type(keys) == "table" and keys or { keys }) do
    map(modes, key, rhs, opts)
  end
end

-- ---------------------------------------------------------------------------
-- Pickers and panels
-- ---------------------------------------------------------------------------

-- Option+P - Quick Open file
bind({ "n", "i", "v" }, { "<M-p>", "<C-p>" }, function()
  LazyVim.pick("files")()
end, "Go to File (Option+P)")

-- Option+Shift+P - Command Palette
bind({ "n", "i", "v" }, "<M-S-p>", function()
  Snacks.picker.commands()
end, "Command Palette (Option+Shift+P)")

-- Option+Shift+F - Search across files
bind({ "n", "i", "v" }, "<M-S-f>", function()
  LazyVim.pick("grep")()
end, "Search in Files (Option+Shift+F)")

-- Option+Shift+H - Replace across files
bind({ "n", "i", "v" }, "<M-S-h>", function()
  require("grug-far").open({ transient = true })
end, "Replace in Files (Option+Shift+H)")

-- Option+Shift+O - Go to Symbol in file
bind({ "n", "i", "v" }, "<M-S-o>", function()
  Snacks.picker.lsp_symbols()
end, "Go to Symbol in File (Option+Shift+O)")

-- Option+T - Go to Symbol in workspace
bind({ "n", "i", "v" }, "<M-t>", function()
  Snacks.picker.lsp_workspace_symbols()
end, "Go to Symbol in Workspace (Option+T)")

-- Option+Shift+M - Problems panel
bind({ "n", "i", "v" }, "<M-S-m>", "<Cmd>Trouble diagnostics toggle<CR>", "Problems (Option+Shift+M)")

-- Option+Shift+G - Source control
bind({ "n", "i", "v" }, "<M-S-g>", function()
  Snacks.lazygit({ cwd = LazyVim.root.git() })
end, "Lazygit (Option+Shift+G)")

-- Ctrl+` / Option+J - Toggle terminal panel. LazyVim also keeps <C-/>.
bind({ "n", "i", "v", "t" }, { "<C-`>", "<M-j>" }, function()
  Snacks.terminal.toggle(nil, { cwd = LazyVim.root() })
end, "Toggle Terminal (Ctrl+` / Option+J)")

-- ---------------------------------------------------------------------------
-- File tree
-- ---------------------------------------------------------------------------

-- Option+B - Toggle the explorer sidebar
bind({ "n", "i", "v" }, "<M-b>", function()
  require("neo-tree.command").execute({ toggle = true, dir = LazyVim.root() })
end, "Toggle Explorer (Option+B)")

-- Option+Shift+E - Focus the explorer and reveal the current file
bind({ "n", "i", "v" }, "<M-S-e>", function()
  require("neo-tree.command").execute({ action = "focus", reveal = true, dir = LazyVim.root() })
end, "Reveal in Explorer (Option+Shift+E)")

-- ---------------------------------------------------------------------------
-- Files and buffers (Cursor calls these "editors")
-- ---------------------------------------------------------------------------

-- Option+S - Save
bind({ "n", "i", "v" }, "<M-s>", "<Cmd>w<CR>", "Save File (Option+S)")

-- Option+W - Close the current buffer, keeping the window layout
bind({ "n", "i", "v" }, "<M-w>", function()
  Snacks.bufdelete()
end, "Close Editor (Option+W)")

-- Option+\ - Split editor to the side
bind({ "n", "i", "v" }, "<M-\\>", "<Cmd>vsplit<CR>", "Split Editor (Option+\\)")

-- Option+Left / Option+Right - Previous / next editor (normal/visual only -
-- insert mode keeps word motion, see "macOS text motions" below).
-- LazyVim also keeps H and L.
bind({ "n", "v" }, "<M-Left>", "<Cmd>bprevious<CR>", "Previous Editor (Option+Left)")
bind({ "n", "v" }, "<M-Right>", "<Cmd>bnext<CR>", "Next Editor (Option+Right)")

-- Option+1..9 - Jump straight to the Nth open editor
for i = 1, 9 do
  bind({ "n", "i", "v" }, "<M-" .. i .. ">", function()
    require("bufferline").go_to(i, true)
  end, "Go to Editor " .. i)
end

-- ---------------------------------------------------------------------------
-- Editing
-- ---------------------------------------------------------------------------

-- Option+A - Select all
bind("n", "<M-a>", "ggVG", "Select All (Option+A)")
bind("i", "<M-a>", "<Esc>ggVG", "Select All (Option+A)")
bind("v", "<M-a>", "<Esc>ggVG", "Select All (Option+A)")

-- Option+Z / Option+Shift+Z - Undo and redo
bind("n", "<M-z>", "u", "Undo (Option+Z)")
bind("i", "<M-z>", "<Cmd>undo<CR>", "Undo (Option+Z)")
bind({ "n", "i" }, "<M-S-z>", "<Cmd>redo<CR>", "Redo (Option+Shift+Z)")

-- Option+F - Find in the current file
bind("n", "<M-f>", "/", "Find (Option+F)", { silent = false })
bind("i", "<M-f>", "<Esc>/", "Find (Option+F)", { silent = false })

-- Option+/ - Toggle line comment
bind("n", "<M-/>", "gcc", "Toggle Comment (Option+/)", { remap = true })
bind("v", "<M-/>", "gc", "Toggle Comment (Option+/)", { remap = true })
bind("i", "<M-/>", "<Esc>gcca", "Toggle Comment (Option+/)", { remap = true })

-- Option+] / Option+[ - Indent and outdent (normal/visual). Insert mode uses
-- Ctrl+Option instead: copilot.lua already owns plain Option+]/Option+[ in
-- insert mode for next/previous suggestion (see plugins/ai.lua).
bind("n", "<M-]>", ">>", "Indent (Option+])")
bind("n", "<M-[>", "<<", "Outdent (Option+[)")
bind("v", "<M-]>", ">gv", "Indent (Option+])")
bind("v", "<M-[>", "<gv", "Outdent (Option+[)")
bind("i", "<C-M-]>", "<C-t>", "Indent (Ctrl+Option+])")
bind("i", "<C-M-[>", "<C-d>", "Outdent (Ctrl+Option+[)")

-- Option+Shift+K - Delete line
bind("n", "<M-S-k>", "dd", "Delete Line (Option+Shift+K)")
bind("i", "<M-S-k>", "<Cmd>normal! dd<CR>", "Delete Line (Option+Shift+K)")
bind("v", "<M-S-k>", "d", "Delete Lines (Option+Shift+K)")

-- Option+Enter / Option+Shift+Enter - Open a line below / above
bind({ "n", "i" }, "<M-CR>", "<Esc>o", "Insert Line Below (Option+Enter)")
bind({ "n", "i" }, "<M-S-CR>", "<Esc>O", "Insert Line Above (Option+Shift+Enter)")

-- Option+Shift+Up / Down - Duplicate the line or selection
bind("n", "<M-S-Up>", "<Cmd>t .-1<CR>", "Copy Line Up")
bind("n", "<M-S-Down>", "<Cmd>t .<CR>", "Copy Line Down")
bind("v", "<M-S-Up>", ":t '<-1<CR>gv", "Copy Selection Up", { silent = true })
bind("v", "<M-S-Down>", ":t '><CR>gv", "Copy Selection Down", { silent = true })
-- (Option+Up / Option+Down move lines - configured on mini.move in lua/plugins/editor.lua)

-- Ctrl+Option+F - Format document.
-- Plain Option+F is already Find and Option+Shift+F is already Search, so
-- Format gets the third tier.
bind({ "n", "v" }, "<C-M-f>", function()
  LazyVim.format({ force = true })
end, "Format Document (Ctrl+Option+F)")

-- ---------------------------------------------------------------------------
-- Language intelligence
-- ---------------------------------------------------------------------------

-- F12 - Go to definition
bind("n", "<F12>", function()
  Snacks.picker.lsp_definitions()
end, "Go to Definition (F12)")

-- Shift+F12 - Find all references
bind("n", "<S-F12>", function()
  Snacks.picker.lsp_references()
end, "Go to References (Shift+F12)")

-- Option+F12 - Peek definition
bind("n", "<M-F12>", "<Cmd>Trouble lsp_definitions toggle<CR>", "Peek Definition (Option+F12)")

-- F2 - Rename symbol
bind("n", "<F2>", "<leader>cr", "Rename Symbol (F2)", { remap = true })

-- Option+. - Quick fix / code action
bind({ "n", "v" }, "<M-.>", vim.lsp.buf.code_action, "Quick Fix (Option+.)")

-- F8 / Shift+F8 - Next and previous problem
bind("n", "<F8>", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, "Next Problem (F8)")
bind("n", "<S-F8>", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, "Previous Problem (Shift+F8)")

-- ---------------------------------------------------------------------------
-- AI (Cursor's chat and inline edit chords, driven by Copilot)
-- ---------------------------------------------------------------------------

-- Option+I / Option+L - Toggle the AI chat pane
bind({ "n", "i", "v" }, { "<M-i>", "<M-l>" }, function()
  require("CopilotChat").toggle()
end, "Toggle AI Chat (Option+I / Option+L)")

-- Option+K - Inline edit: ask about the buffer or the selection
bind({ "n", "v" }, "<M-k>", function()
  vim.ui.input({ prompt = "Inline Edit: " }, function(input)
    if input ~= nil and input ~= "" then
      require("CopilotChat").ask(input)
    end
  end)
end, "AI Inline Edit (Option+K)")

-- Option+Right - Accept the next word of the inline suggestion.
-- Falls through to "move word right" (the same thing bare Option+Right does
-- everywhere else on macOS) when there is no suggestion showing - see the
-- "macOS text motions" section below for why Word Right lives here instead
-- of its own binding.
bind("i", "<M-Right>", function()
  local ok, suggestion = pcall(require, "copilot.suggestion")
  if ok and suggestion.is_visible() then
    suggestion.accept_word()
  else
    vim.api.nvim_feedkeys(vim.keycode("<C-o>w"), "n", false)
  end
end, "Accept Suggestion Word / Word Right (Option+Right)")

-- ---------------------------------------------------------------------------
-- macOS text motions (what Cmd and Option do everywhere else on the system,
-- approximated here with Option and Ctrl+Option since Cmd is off the table)
-- ---------------------------------------------------------------------------

-- Ctrl+Option+Left / Ctrl+Option+Right - start and end of line.
-- Plain Option+Left/Right is already spoken for: word motion in insert mode,
-- previous/next editor in normal/visual mode (both above).
bind({ "n", "v" }, "<C-M-Left>", "^", "Start of Line (Ctrl+Option+Left)")
bind({ "n", "v" }, "<C-M-Right>", "$", "End of Line (Ctrl+Option+Right)")
bind("i", "<C-M-Left>", "<C-o>^", "Start of Line (Ctrl+Option+Left)")

-- Ctrl+Option+Up / Ctrl+Option+Down - top and bottom of file.
-- Plain Option+Up/Down is already mini.move (move the current line), see
-- lua/plugins/editor.lua.
bind({ "n", "v" }, "<C-M-Up>", "gg", "Top of File (Ctrl+Option+Up)")
bind({ "n", "v" }, "<C-M-Down>", "G", "End of File (Ctrl+Option+Down)")

-- Option+Left - move by word (insert mode only). Option+Right's word-motion
-- is merged into the suggestion-accept binding above (same chord, same
-- fallback behavior when no suggestion is showing).
bind("i", "<M-Left>", "<C-o>b", "Word Left (Option+Left)")

-- Ctrl+Option+Backspace / Option+Backspace - delete to line start / delete word.
-- Plain Option+Backspace is already "delete word before", matching what
-- Option+Backspace does system-wide on macOS, so line-start delete moved up
-- a tier instead of displacing it.
bind("i", "<C-M-BS>", "<C-u>", "Delete to Line Start (Ctrl+Option+Backspace)")
bind("i", "<M-BS>", "<C-w>", "Delete Word Before (Option+Backspace)")
