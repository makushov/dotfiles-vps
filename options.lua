vim.o.laststatus = 3
local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Indention
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

-- UI
opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8
opt.wrap = false

-- Search
opt.ignorecase = true
opt.smartcase = true

-- System clipboard
opt.clipboard = "unnamedplus"

-- Split behavior
opt.splitright = true
opt.splitbelow = true

-- Misc
opt.updatetime = 250
opt.timeoutlen = 300
opt.undofile = true
opt.autoread = true

-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- autoread
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
	command = "checktime",
})

vim.diagnostic.config({
	virtual_text = true,
	float = { border = "rounded" },
})
