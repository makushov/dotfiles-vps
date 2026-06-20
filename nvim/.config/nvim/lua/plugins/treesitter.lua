return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,
    config = function()
      require("nvim-treesitter").setup({})

      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "lua", "vim", "vimdoc",
          "javascript", "typescript", "tsx",
          "html", "css",
          "markdown",
          "xml",
          "json",
          "yaml", "toml",
          "bash", "sh",
          "python",
          "regex",
        },
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })
    end,
  },
}
