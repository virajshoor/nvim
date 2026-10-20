# Neovim configuration — reference

LazyVim, configured as a Cursor/VS Code parity layer: same panels, same
editing muscle memory, running in the terminal via [Termy](https://termy.app).
**No Cmd anywhere** — every chord uses Option, promoted to a second or third
tier (Option+Shift, Ctrl+Option) only when two actions genuinely want the
same letter. This file is the single source of truth for what's bound, why,
and how to change it without re-breaking things already fixed once.

1. [Repo layout](#repo-layout)
2. [Keybinds](#keybinds)
3. [Look and feel](#look-and-feel)
4. [Design decisions](#design-decisions)
5. [Adding or changing a keybind](#adding-or-changing-a-keybind)

## Repo layout

| Path | Purpose |
| --- | --- |
| `init.lua` | One line: `require("config.lazy")`. |
| `lua/config/lazy.lua` | lazy.nvim bootstrap, plugin spec roots, and global settings that must exist before plugins load (`vim.g.ai_cmp = false`, `git.timeout`, daily update `checker.frequency`, disabled rtp plugins incl. `netrwPlugin`, which neo-tree replaces). |
| `lua/config/options.lua` | Editor feel (clipboard, tabs, scrolloff, `ttimeoutlen`/`timeoutlen`, cursor blink, terminal title, jumplist, diffs, `:s` preview split, wrapped-line display) — see [comments there](lua/config/options.lua) for why each deviates from LazyVim defaults. |
| `lua/config/keymaps.lua` | **The Cursor/VS Code parity layer.** Every chord in the [keybinds table](#keybinds) below is defined here via the local `bind()` helper. |
| `lua/config/autocmds.lua` | Cursorline only in the focused window, longer yank flash, search highlights that clear themselves. See [Look and feel](#look-and-feel). |
| `lua/plugins/ai.lua` | Copilot ghost-text + CopilotChat sidebar (Cursor's inline AI and chat pane). |
| `lua/plugins/editor.lua` | multicursor.nvim (Option+D), mini.move (Option+Up/Down line move), neo-tree window/behavior tuning, flash.nvim jump labels. |
| `lua/plugins/ui.lua` | bufferline (the tab strip, hover-reveal close buttons), lualine, snacks (dashboard/notifier/input floats, eased scroll + indent animations, picker frecency), smear-cursor tuning, mini.animate (window open/close/resize), rounded blink.cmp/noice/diagnostic floats, gitsigns inline blame, treesitter-context cap, softer LSP diagnostics. |
| `lua/plugins/dap.lua` | Disables `nvim-dap-virtual-text` — the one plugin with no local mirror when this config was built offline. Delete this file once `nvim-dap-virtual-text` is reachable again and run `:Lazy sync`. |
| `lua/plugins/colorscheme.lua` | tokyonight-night, transparent (the terminal runs at 65% opacity + blur, so this lets that show through instead of double-painting a background). Bold lualine, orange current line number, underlined matching bracket. |
| `lazy-lock.json` | lazy.nvim's pinned-commit lockfile. Auto-managed — never hand-edit; it's rewritten on `:Lazy sync`/`:Lazy update`. |
| `lazyvim.json` | Which `LazyVim.plugins.extras.*` modules are enabled (langs, formatters, pickers, etc.) — edit via `:LazyExtras`, not by hand. |
| `stylua.toml` | 2-space indent, 120 column width. Run `stylua .` before committing Lua changes. |
| `.neoconf.json` | Points `lua_ls` at `neodev` so it type-checks against the real Neovim/plugin API instead of guessing. |

## Keybinds

Every entry is defined with `keymaps.lua`'s `bind(modes, keys, rhs, desc)`
helper. Three modifier tiers, used in order of preference — see
[Design decisions](#design-decisions) for exactly which collisions forced
tier 3 on a given action:

1. **Option+`<key>`** — the default, used everywhere it's free.
2. **Option+Shift+`<key>`** — when a second action wants the same letter.
3. **Ctrl+Option+`<key>`** — when tiers 1 and 2 are *both* already taken.

`<leader>` is the space bar; LazyVim's own `<leader>` keymaps are all still
present and unchanged underneath this layer. A few bindings additionally
keep a plain `Ctrl+<key>` chord alongside their Option chord where one
already existed and still works (e.g. `Ctrl+P`, `Ctrl+N`) — harmless, not
Cmd, kept for muscle memory.

### Pickers and panels

| Chord | Action |
| --- | --- |
| `Option+P` (also `Ctrl+P`) | Go to file |
| `Option+Shift+P` | Command palette |
| `Option+Shift+F` | Search across files |
| `Option+Shift+H` | Replace across files |
| `Option+Shift+O` | Go to symbol in file |
| `Option+T` | Go to symbol in workspace |
| `Option+Shift+M` | Problems / diagnostics (Trouble) |
| `Option+Shift+G` | Lazygit (also `<leader>gg`) |
| `Ctrl+\`` / `Option+J` | Toggle terminal panel (LazyVim also keeps `Ctrl+/`) |

### File tree

| Chord | Action |
| --- | --- |
| `Option+B` | Toggle explorer sidebar |
| `Option+Shift+E` | Focus explorer, reveal current file |

### Files and buffers ("editors")

| Chord | Action |
| --- | --- |
| `Option+S` | Save |
| `Option+W` | Close editor (keeps window layout) |
| `Option+\` | Split editor to the side |
| `Option+Left` / `Right` (normal/visual only) | Previous / next editor — LazyVim also keeps `Shift+H`/`Shift+L` |
| `Option+1`…`Option+9` | Jump straight to editor N |

### Editing

| Chord | Action |
| --- | --- |
| `Option+A` | Select all |
| `Option+Z` / `Option+Shift+Z` | Undo / redo |
| `Option+F` | Find in current file |
| `Option+D` (also `Ctrl+N`) | Add cursor at next match |
| `Option+Shift+D` | Skip this match |
| `Option+Shift+L` | Cursor on every match (also `<leader>ma`) |
| — | Add cursor above/below: `<leader>mk` / `<leader>mj` only, see [note](#design-decisions) |
| `Option+/` | Toggle line comment |
| `Option+]` / `[` (normal/visual) | Indent / outdent |
| `Ctrl+Option+]` / `[` (insert) | Indent / outdent — insert mode only, see [why](#design-decisions) |
| `Option+Shift+K` | Delete line |
| `Option+Enter` / `Option+Shift+Enter` | Insert line below / above |
| `Option+Up` / `Down` | Move current line/selection (mini.move) |
| `Option+Shift+Up` / `Down` | Duplicate line/selection |
| `Ctrl+Option+F` | Format document |

With multiple cursors alive: `Left`/`Right` cycle which cursor is primary, `Esc` collapses back to one.

### Language intelligence

| Chord | Action |
| --- | --- |
| `F12` | Go to definition (also `gd`) |
| `Shift+F12` | Find all references (also `gr`) |
| `Option+F12` | Peek definition |
| `F2` | Rename symbol (also `<leader>cr`) |
| `Option+.` | Quick fix / code action (also `<leader>ca`) |
| `F8` / `Shift+F8` | Next / previous problem (also `]d` / `[d`) |
| — | Hover docs: `K` |

macOS may need **System Settings → Keyboard → "Use F1, F2, etc. as standard
function keys"** for the F-key row, or hold `fn`.

### AI (Copilot)

| Chord | Action |
| --- | --- |
| `Option+I` / `Option+L` | Toggle chat pane (also `<leader>aa`) |
| `Option+K` | Inline edit / quick question (also `<leader>aq`) |
| `Tab` | Accept inline suggestion |
| `Option+Right` (insert) | Accept one word of the suggestion — or move word right if none showing, see [why](#design-decisions) |
| `Option+]` / `Option+[` (insert) | Next / previous suggestion |
| `Ctrl+]` | Dismiss suggestion |

### macOS text motions

`Ctrl+Option+Left`/`Right` line start/end · `Ctrl+Option+Up`/`Down` file
start/end · `Option+Left` word left (insert) · `Option+Right` word right,
merged into the suggestion-accept binding above (insert) ·
`Ctrl+Option+Backspace` delete to line start (insert) · `Option+Backspace`
delete word before (insert).

### UI toggles

LazyVim's `<leader>u` toggles, plus one added here. The ones relevant to the
[Look and feel](#look-and-feel) changes:

| Chord | Action |
| --- | --- |
| `<leader>uB` | Toggle inline git blame (added in `ui.lua`) |
| `<leader>ua` | Toggle snacks animations (scroll + indent scope) |
| `<leader>uS` | Toggle smooth scroll |
| `<leader>ug` | Toggle indent guides (snacks.indent) |
| `<leader>ut` | Toggle sticky scope header (treesitter-context) |
| `<leader>ub` | Toggle dark/light background (**not** blame) |
| `<leader>ghb` | Full blame for the current line in a popup |

### Navigation behaviour

| Keys | Behaviour |
| --- | --- |
| `Ctrl+O` / `Ctrl+I` | Back / forward through jumps like a browser (`jumpoptions=stack,view`): jumping somewhere new drops the forward history, and the viewport is restored, not just the cursor. |
| `/`, `?`, `n`, `N`, `*`, `#` | Search highlights show while searching and clear on the next non-search key, so `:noh` is rarely needed. |
| `:s/foo/bar` | Live preview of every match, including off-screen ones, in a split (`inccommand=split`). |

### Jump anywhere: flash.nvim

`s` then two characters labels every match on screen — press the label to jump.
`S` does the same for treesitter nodes; `f`/`t`/`F`/`T` also show labels now.

## Look and feel

Everything below is cosmetic or behavioural. None of it adds keybinds
except `<leader>uB` above.

| Area | What it does | Where |
| --- | --- | --- |
| Cursor smear | smear-cursor (LazyVim extra) tuned to be snappier and springier, with a small upward particle trail. Skips moves under 2 cells, and is off in dashboard, neo-tree, Lazy and Mason. | `ui.lua` |
| Cursor blink | Gentle blink in all modes via `guicursor` (only if the terminal allows blinking). | `options.lua` |
| Window animation | mini.animate eases window open/close/resize (120ms). Its cursor and scroll animation are off so they don't fight smear-cursor and snacks.scroll. | `ui.lua` |
| Scrolling | snacks.scroll eases out (`outQuad`, 200ms). | `ui.lua` |
| Indent guides | snacks.indent is the only renderer; the current-scope line animates in. | `ui.lua` |
| Focus | Cursorline only shows in the focused window. | `autocmds.lua` |
| Yank | Yanked text flashes in `IncSearch` for 250ms (replaces LazyVim's `lazyvim_highlight_yank`). | `autocmds.lua` |
| Colours | Bold lualine sections, bold orange `CursorLineNr`, underlined orange `MatchParen`. | `colorscheme.lua` |
| Floats | Rounded borders on the completion menu, its docs, signature help, LSP hover (noice `lsp_doc_border`) and diagnostic floats (which also name the source when several tools report). | `ui.lua` |
| Noise | Empty hovers no longer toast "No information available". | `ui.lua` |
| Tabs | Bufferline close buttons appear on hover (needs `mousemoveevent`). | `ui.lua`, `options.lua` |
| Git | Inline blame at end of line after 600ms: `author, 3 days ago · summary`. | `ui.lua` |
| Sticky header | treesitter-context capped at 3 lines. | `ui.lua` |
| Pickers | Frecency ranking: files you open often float up. | `ui.lua` |
| Wrapped lines | `smoothscroll`, `breakindent`, `linebreak`, `↪` marker. Matters where LazyVim turns wrap on (markdown, gitcommit). | `options.lua` |
| Diffs | `histogram` algorithm + `linematch:60`. | `options.lua` |
| Terminal title | `file — project` instead of `nvim`. | `options.lua` |

## Design decisions

### Performance trims

- **One indent renderer.** The `indent-blankline` extra was removed from
  `lazyvim.json` because `snacks.indent` was already on, so indent guides
  were being drawn twice on every redraw.
- **`netrwPlugin` disabled** in `lazy.lua`; neo-tree's
  `hijack_netrw_behavior` covers opening directories, and `gx` is native in
  Neovim 0.10+.
- **Update checker runs daily** (`checker.frequency = 86400`) instead of
  hourly background `git fetch`es.
- **Smear skips tiny moves** (`min_*_distance_smear = 2`), so typing and
  `h`/`l` don't start an animation each keystroke.

### No global `winborder`

Neovim 0.11's `winborder = "rounded"` would round every float in one line,
but several plugins (flash's prompt, which-key, gitsigns, neotest, grug-far)
open floats without an explicit border and would suddenly get one. Borders
are set per plugin instead. Don't add `winborder` without checking those.

### Auto-clearing search highlight

Done in `autocmds.lua` with `vim.on_key`: `hlsearch` stays on only while
the last normal-mode key was one of `<CR> n N * # ? /`. If you ever map
another key to a search action, add it to `search_keys` there, or its
highlights will clear immediately.

### No Cmd, anywhere — why

Termy (the terminal app in use — **not** Ghostty, despite what shell env vars
may suggest) owns a fixed table of Cmd/Cmd+Option/Cmd+Shift chords for its own
tab and pane management, claimed **globally** before Neovim ever sees the
keystroke, and — per Termy's own current-version bug — `Cmd+Shift+*` chords
can't even be released back with an `unbind` line. A Cmd-based layer means
some fraction of chords are permanently a coin flip depending on Termy's
defaults and bugs. Rather than keep patching individual chords as each one
turned up broken (`Cmd+W`, `Cmd+T`, `Cmd+1`-`9`, `Cmd+Option+Left/Right`, all
found dead this way), the whole layer moved off Cmd entirely. Plain
`Option+<key>` is confirmed **not** in Termy's reserved-chord table for any
letter/number/arrow (verified by extracting the compiled default-keybind
table straight from the app binary — see the command below), so nothing in
this file depends on Termy's config, its bugs, or its future defaults.

```
strings -n 4 /Applications/Termy.app/Contents/MacOS/termy \
  | grep -oE "secondary-[A-Za-z0-9,=+.-]+" | sort -u
```

(`secondary` is Termy's internal name for Cmd/⌘; its config also accepts
`cmd-` as a friendly alias for the same thing.) The two Option-only
exceptions Termy does reserve — `alt-backspace` and `alt-delete` — are scoped
to Termy's own text-input widgets (rename tab, search box), not the terminal
pane content, so they don't affect anything bound here.

### Why three tiers instead of just Option everywhere

Stripping Cmd off the old layer mechanically would have produced real
collisions, because several pairs of actions used to be distinguished
*only* by Cmd vs. Cmd+Option — remove Cmd from both and they land on the same
bare Option chord:

| Old chords | Both collapse to | Resolution |
| --- | --- | --- |
| `Cmd+F` (Find) / `Cmd+Option+F` (Format) | `Option+F` | Find keeps it; Format → `Ctrl+Option+F` (Search already lives at `Option+Shift+F`, pinned by an earlier explicit decision — don't move it again without checking `<M-S-f>`/`<C-M-f>` usage first) |
| `Cmd+Left/Right` (line start/end) / `Cmd+Option+Left/Right` (prev/next editor) / bare `Option+Left/Right` (word motion, insert) | `Option+Left/Right` | Word motion (insert) and prev/next editor (normal/visual) keep it — different modes, no real clash. Line start/end → `Ctrl+Option+Left/Right` |
| `Cmd+Up/Down` (top/bottom of file) / `Cmd+Option+Up/Down` (multicursor: stack cursor) / bare `Option+Up/Down` (mini.move: move line) | `Option+Up/Down` | mini.move keeps it (most frequently used). Top/bottom of file → `Ctrl+Option+Up/Down`. Stack-cursor has no arrow chord left — it already had `<leader>mk`/`<leader>mj`, so that's now its only trigger |
| `Cmd+Right` (accept Copilot suggestion word, insert) / bare `Option+Right` (word right, insert) | `Option+Right` | **Merged**, not resolved by relocation: `Option+Right` now accepts a word of the suggestion when one is showing, and falls through to the exact same word-right motion (`<C-o>w`) it always did otherwise. Conceptually the same gesture either way — move right by a word, optionally consuming ghost text while doing it |
| `Cmd+Backspace` (delete to line start) / bare `Option+Backspace` (delete word before) | `Option+Backspace` | Delete-word-before keeps it (matches macOS system-wide Option+Backspace). Delete-to-line-start → `Ctrl+Option+Backspace` |
| `Cmd+]`/`[` (indent, all modes) vs. copilot.lua's own `Option+]`/`[` (next/prev suggestion, insert-only) | `Option+]`/`[` in insert mode | Normal/visual indent keeps bare `Option+]`/`[` (no copilot conflict there). Insert-mode indent → `Ctrl+Option+]`/`[` |

None of these needed a fourth tier — Ctrl+Option was free in every case
above, and Neovim's `<C-M-x>` notation (stored canonically as `<M-C-x>`)
preserves letter case, so it doesn't have the collapse problem described
next.

### `Ctrl+Shift+<letter>` is not a usable fallback (learned the hard way)

An earlier attempt used `Ctrl+Shift+F` as a fallback for Search. It silently
clobbered the built-in `Ctrl+F` "scroll forward a page" mapping instead of
adding a working one. Reason: terminals send the identical control byte for
`Ctrl+f` and `Ctrl+Shift+f` (Shift doesn't survive the 5-bit control-code
strip), and Neovim's `<C-x>` key notation has no separate slot for
"Ctrl+Shift+letter" — `<C-S-f>` and `<C-f>` collapse to the exact same
canonical keymap entry, and whichever `bind()` call registers last silently
wins. The same bug independently existed in multicursor's original
`Ctrl+N`/`Ctrl+Shift+N` pair (`editor.lua`) — `Add Cursor at Next Match`'s
`Ctrl+N` fallback was being shadowed by `Skip Match`'s `Ctrl+Shift+N`, so the
former had no working trigger at all. Fixed as part of this same pass by
dropping `Ctrl+Shift+N` in favor of `Option+Shift+D` — plain Option preserves
Shift state (Meta+letter sends a genuinely different byte for upper vs. lower
case), so it doesn't have this problem. **Never use `Ctrl+Shift+<letter>` as
a fallback for a letter chord** — use `Option+Shift+<letter>` instead.

### `lazy.nvim` git clone timeout

`lua/config/lazy.lua` sets `git.timeout = 600` (lazy.nvim's default is 120s).
`copilot.lua` (3368 objects) intermittently clones at 150-300 KiB/s on this
network, which pushed past the 120s default mid-checkout. lazy.nvim SIGKILLs
the git process on timeout, which left `copilot.lua`'s working tree half
populated (`git status` showed the whole repo as deleted) and `:Lazy check`
retried the same losing race every time it ran. Bumping the timeout to 10
minutes gives it headroom instead of a near-guaranteed failure on a slow run.

## Adding or changing a keybind

1. **Pick the chord**, starting from tier 1 (`Option+<key>`). Only move to
   tier 2 (`Option+Shift`) or tier 3 (`Ctrl+Option`) if something else
   already legitimately owns the lower tier — check the table in
   [Why three tiers](#why-three-tiers-instead-of-just-option-everywhere) and
   the collision list there before reusing a letter.
2. **Never use `Ctrl+Shift+<letter>`** as a distinguishing chord — see the
   pitfall above. `Option+Shift+<letter>` is the correct equivalent.
3. **Check for collisions** before wiring it up:
   ```
   grep -n '"<M-yourkey>"' lua/config/keymaps.lua lua/plugins/*.lua
   ```
4. **Verify it actually registered**, headless (autocmds that load
   `keymaps.lua` fire on `VeryLazy`, which headless Neovim never triggers on
   its own — force it):
   ```bash
   nvim --headless -c "lua vim.defer_fn(function()
     vim.cmd('doautocmd User VeryLazy')
     local seen = {}
     for _, m in ipairs(vim.api.nvim_get_keymap('n')) do seen[m.lhs] = m.desc end
     print(vim.inspect(seen['<M-yourkey>']))
     vim.cmd('qa')
   end, 2000)"
   ```
   Note Neovim normalizes shifted letter chords to the uppercase form —
   `<M-S-o>` is stored and looked up as `<M-O>` — and reorders combined
   modifiers alphabetically — `<C-M-f>` is stored as `<M-C-F>` (Ctrl also
   canonicalizes to uppercase there, independent of whether Shift was
   involved). Check the normalized spelling if a lookup comes back `nil`
   unexpectedly.
5. **Update the table** in this file to match.
