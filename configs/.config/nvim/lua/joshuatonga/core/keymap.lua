# Ref: https://github.com/ThePrimeagen/.dotfiles/blob/38b91cbc4bc9de108c2356139717e52f12ea5d94/nvim/.config/nvim/lua/theprimeagen/keymap.lua
local M = {}

local function bind(mode, outer_opts)
  outer_opts = outer_opts or { noremap = true }
  return function(lhs, rhs, opts)
    opts = vim.tbl_extend("force",
      outer_opts,
      opts or {}
    )
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

M.nmap = bind("n", { noremap = false })
M.nnoremap = bind("n")
M.vnoremap = bind("v")
M.xnoremap = bind("x")
M.inoremap = bind("i")

return M
