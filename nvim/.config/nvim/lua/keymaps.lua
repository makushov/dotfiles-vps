-- Langmap for Russian and Ukrainian keyboard layouts
-- Allows vim normal-mode commands (hjkl, dd, ciw, /, etc.) to work
-- without switching the system layout to English first.
-- Only affects normal/visual/operator-pending modes — insert mode types normally.
--
-- Note: commas and semicolons in source/target must be escaped with \
-- because they are langmap's own separators.
local langmap_pairs = {
  -- Russian lowercase
  { "йцукенгшщзхъфывапролджэячсмитьбю", "qwertyuiop[]asdfghjkl\\;'zxcvbnm\\,." },
  -- Russian uppercase
  { "ЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ", 'QWERTYUIOP{}ASDFGHJKL:"ZXCVBNM<>' },
  -- Ukrainian-specific letters (lowercase), where layout differs from Russian:
  -- и→s (Russian ы position), і→b (Russian и position),
  -- ї→] (Russian ъ position), є→' (Russian э position)
  { "иіїє", "sb]'" },
  -- Ukrainian-specific letters (uppercase)
  { 'ИІЇЄ', 'SB]"' },
}

local langmap_parts = {}
for _, pair in ipairs(langmap_pairs) do
  table.insert(langmap_parts, pair[1] .. ";" .. pair[2])
end
vim.opt.langmap = table.concat(langmap_parts, ",")

-- ESC to dismiss search highlight
vim.keymap.set("n", "<ESC>", "<cmd>nohlsearch<cr>")
