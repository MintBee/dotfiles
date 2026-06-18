return {
  {
    "mg979/vim-visual-multi",
    event = "BufReadPost",
    init = function()
      -- Optional: Configure settings before the plugin loads
      vim.g.VM_default_mappings = 1
    end,
  },
}
