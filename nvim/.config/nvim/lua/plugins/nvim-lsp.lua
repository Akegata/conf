return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    local keys = require("lazyvim.plugins.lsp.keymaps").get()
    -- Disable ONLY the problematic LSP mapping
    keys[#keys + 1] = { "<C-k>", false, mode = "i" } -- Explicitly target insert mode
    opts.keys = keys
    return opts
  end,
}
