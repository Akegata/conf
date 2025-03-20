return {
  -- add symbols-outline
  -- lazy.nvim
  {
    "ggandor/leap.nvim",
     keys = {
       { "s", mode = { "n", "x", "o" }, "<Plug>(leap-forward)", desc = "Leap  orward" },
       { "S", mode = { "n", "x", "o" }, "<Plug>(leap-backward)", desc = "Leap backward" },
    },
  },
}
