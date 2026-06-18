return {
  {
    "folke/flash.nvim",
    opts = {
      modes = {
        char = {
          char_actions = function(motion)
            return {
              [";"] = "prev",
              [","] = "next",
              [motion:lower()] = "next",
              [motion:upper()] = "prev",
            }
          end,
        },
      },
    },
  },
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          explorer = {
            win = {
              list = {
                keys = {
                  ["<M-u>"] = "toggle_hidden",
                },
              },
            },
          },
        },
      },
    },
  },
}
