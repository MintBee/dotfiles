local LIGHT_PROFILE = "iTerm2 Solarized Light"
local DARK_PROFILE = "iTerm2 Solarized Dark"

local function macos_is_dark_mode()
  vim.fn.system({ "defaults", "read", "-g", "AppleInterfaceStyle" })
  return vim.v.shell_error == 0
end

local function is_iterm2()
  return vim.env.TERM_PROGRAM == "iTerm.app" or vim.env.ITERM_SESSION_ID ~= nil
end

local function tmux_wrap(sequence)
  return "\027Ptmux;" .. sequence:gsub("\027", "\027\027") .. "\027\\"
end

local function set_iterm2_profile(profile)
  local sequence = ("\027]1337;SetProfile=%s\007"):format(profile)

  if vim.env.TMUX then
    sequence = tmux_wrap(sequence)
  end

  io.stdout:write(sequence)
  io.stdout:flush()
end

local function apply_iterm2_solarized()
  if not is_iterm2() then
    return false, false
  end

  local dark = macos_is_dark_mode()
  local profile = dark and DARK_PROFILE or LIGHT_PROFILE
  local changed = vim.g.iterm2_solarized_profile ~= profile

  vim.opt.termguicolors = false
  vim.opt.background = dark and "dark" or "light"

  if changed then
    set_iterm2_profile(profile)
    vim.g.iterm2_solarized_profile = profile
  end

  return true, changed
end

local function load_colorscheme()
  local applied = apply_iterm2_solarized()

  if applied then
    vim.cmd.colorscheme("default")
    vim.cmd("highlight Normal ctermbg=NONE guibg=NONE")
    vim.cmd("highlight NormalNC ctermbg=NONE guibg=NONE")
    vim.cmd("highlight SignColumn ctermbg=NONE guibg=NONE")
    vim.cmd("highlight EndOfBuffer ctermbg=NONE guibg=NONE")
  else
    require("tokyonight").load()
  end
end

return {
  {
    "LazyVim/LazyVim",
    init = function()
      vim.api.nvim_create_autocmd("FocusGained", {
        group = vim.api.nvim_create_augroup("iterm2_solarized_profile", { clear = true }),
        callback = function()
          local applied, changed = apply_iterm2_solarized()

          if applied and changed then
            load_colorscheme()
          end
        end,
      })
    end,
    opts = {
      colorscheme = load_colorscheme,
    },
  },
}
