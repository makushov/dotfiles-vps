return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "catppuccin/nvim",
    },
    config = function()
      require("lualine").setup({
        options = {
          theme = require("catppuccin.utils.lualine")("mocha"),
          component_separators = "|",
          section_separators = "",
        },
      })
    end,
  },
}
