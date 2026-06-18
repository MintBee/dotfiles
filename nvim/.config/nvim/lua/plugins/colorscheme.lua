local function macos_is_dark_mode()
  vim.fn.system({ "defaults", "read", "-g", "AppleInterfaceStyle" })
  return vim.v.shell_error == 0
end

local function load_colorscheme()
  local dark = macos_is_dark_mode()

  vim.opt.background = dark and "dark" or "light"
  vim.cmd.colorscheme(dark and "tokyonight-night" or "solarized-osaka")
end

return {
  {
    "craftzdog/solarized-osaka.nvim",
    priority = 1000,
    opts = {},
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = load_colorscheme,
    },
  },
}
