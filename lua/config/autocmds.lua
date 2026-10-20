-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local autocmd = vim.api.nvim_create_autocmd
local group = vim.api.nvim_create_augroup("user_feel", { clear = true })

-- Cursorline follows focus, so the active split is obvious at a glance.
autocmd({ "WinEnter", "BufEnter", "FocusGained" }, {
  group = group,
  callback = function()
    if vim.bo.buftype == "" then vim.wo.cursorline = true end
  end,
})
autocmd({ "WinLeave", "FocusLost" }, {
  group = group,
  callback = function()
    if vim.bo.buftype == "" then vim.wo.cursorline = false end
  end,
})

-- Longer, warmer yank flash than LazyVim's default.
pcall(vim.api.nvim_del_augroup_by_name, "lazyvim_highlight_yank")
autocmd("TextYankPost", {
  group = group,
  callback = function() vim.hl.on_yank({ higroup = "IncSearch", timeout = 250 }) end,
})

-- Search highlights appear while searching and vanish once you move on.
local search_keys = { "<CR>", "n", "N", "*", "#", "?", "/" }
vim.on_key(function(key)
  if vim.fn.mode() ~= "n" or key == "" then return end
  local searching = vim.tbl_contains(search_keys, vim.fn.keytrans(key))
  if vim.o.hlsearch ~= searching then vim.o.hlsearch = searching end
end, vim.api.nvim_create_namespace("user_auto_hlsearch"))
