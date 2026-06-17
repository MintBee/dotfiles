local HANGUL_CHOSEONG_BY_KEY = {
  r = "ㄱ가-깋",
  R = "ㄲ까-낗",
  s = "ㄴ나-닣",
  e = "ㄷ다-딯",
  E = "ㄸ따-띻",
  f = "ㄹ라-맇",
  a = "ㅁ마-밓",
  q = "ㅂ바-빟",
  Q = "ㅃ빠-삫",
  t = "ㅅ사-싷",
  T = "ㅆ싸-앃",
  d = "ㅇ아-잏",
  w = "ㅈ자-짛",
  W = "ㅉ짜-찧",
  c = "ㅊ차-칳",
  z = "ㅋ카-킿",
  x = "ㅌ타-탛",
  v = "ㅍ파-핗",
  g = "ㅎ하-힣",
}

local function qwerty_key_to_hangul_pattern(char)
  local hangul_range = HANGUL_CHOSEONG_BY_KEY[char]

  if not hangul_range then
    return char
  end

  return "[" .. char .. hangul_range .. "]"
end

local function flash_hangul_mode(input)
  local pattern = {}

  for index = 1, #input do
    local char = input:sub(index, index)
    pattern[#pattern + 1] = qwerty_key_to_hangul_pattern(char)
  end

  return "\\m" .. table.concat(pattern)
end

local flash_hangul_labelers = setmetatable({}, { __mode = "k" })

local function hangul_pattern_matches(pattern, windows)
  if not pcall(vim.regex, pattern) then
    return false
  end

  for _, window in ipairs(windows) do
    local found = vim.api.nvim_win_call(window, function()
      local ok, position = pcall(vim.fn.searchpos, pattern, "cnw")
      return ok and position[1] ~= 0
    end)

    if found then
      return true
    end
  end

  return false
end

local function hangul_search_continuation_labels(state)
  local pattern = state.pattern()
  local labels = {}

  if pattern == "" then
    return labels
  end

  for _, label in ipairs(state:labels()) do
    if HANGUL_CHOSEONG_BY_KEY[label] and hangul_pattern_matches(flash_hangul_mode(pattern .. label), state.wins) then
      labels[#labels + 1] = label
    end
  end

  return labels
end

local function flash_hangul_labeler(_, state)
  local labeler = flash_hangul_labelers[state]

  if not labeler then
    labeler = require("flash.labeler").new(state):labeler()
    flash_hangul_labelers[state] = labeler
  end

  local original_exclude = state.opts.label.exclude or ""
  state.opts.label.exclude = original_exclude .. table.concat(hangul_search_continuation_labels(state))

  local ok, err = pcall(labeler)
  state.opts.label.exclude = original_exclude

  if not ok then
    error(err)
  end
end

return {
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = function()
      return {
        search = {
          ---@type Flash.Pattern.Mode
          mode = flash_hangul_mode,
        },
        labeler = flash_hangul_labeler,
      }
    end,
  },
  { "rlue/vim-barbaric" },
}
