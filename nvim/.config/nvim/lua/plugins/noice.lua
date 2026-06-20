return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
    "catppuccin/nvim",
  },
  config = function()
    require("noice").setup({
      presets = {
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = true,
      },
      routes = {
        {
          view = "notify",
          filter = { event = "msg_showmode" },
        },
      },
      views = {
        cmdline_popup = {
          position = { row = 5, col = "50%" },
          size = { width = 60, height = "auto" },
        },
        popupmenu = {
          relative = "editor",
          position = { row = 8, col = "50%" },
          size = { width = 60, height = 10 },
          border = {
            style = "rounded",
            padding = { 0, 1 },
          },
          win_options = {
            winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
          },
        },
      },
    })

    require("notify").setup({
      background_colour = "#1e1e2e",
      render = "default",
      stages = "slide",
      timeout = 3000,
    })
  end,
}
