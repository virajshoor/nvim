return {
  -- Disabled only because it could not be downloaded on the network this
  -- config was built on, and it is the one plugin with no local copy to
  -- restore from. Everything else in `dap.core` works without it; this just
  -- adds inline variable values next to your code while debugging.
  --
  -- Once you are back on a network that can reach github.com, delete this
  -- file and run `:Lazy sync`.
  { "theHamsta/nvim-dap-virtual-text", enabled = false },
}
