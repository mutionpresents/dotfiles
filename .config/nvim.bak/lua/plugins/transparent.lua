return {
  -- Tokyonight example
  {
    "folke/tokyonight.nvim",
    opts = {
      transparent = true,
    },
  },

  -- (Optional) If you want to force other UI elements transparent
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
    config = function()
      vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
      vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
      vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
      vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })
      vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
    end,
  },
}
