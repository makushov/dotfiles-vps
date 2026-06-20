return {
  {
    "mikavilpas/yazi.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>y", "<cmd>Yazi<cr>", desc = "Open Yazi" },
      { "<leader>Y", "<cmd>Yazi cwd<cr>", desc = "Open Yazi (cwd)" },
    },
    opts = {},
  },
}
