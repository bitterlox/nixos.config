-- leader mappings
vim.keymap.set("n", "<leader>wq", vim.cmd.wq)
vim.keymap.set("n", "<leader>cc", vim.cmd.close)

vim.keymap.set("n", "<leader>nrw", vim.cmd.Ex)

-- Lazy quick open
vim.keymap.set("n", "<leader>lzy", vim.cmd.Lazy)

-- move visually highlighted text
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
-- todo: should add the equivalent for H & L mapping to < and >

-- when using J keep the cursor at the start of the line
vim.keymap.set("n", "J", "mzJ`z")

-- C_d and C_u (half page jumps) keep the cursor in the middle
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- when jumping to search matches, keep cursor in the middle
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- paste without losing paste buffer
vim.keymap.set("x", "<leader>p", '"_dP')
vim.keymap.set("n", "<leader>y", '"+y')

-- yank to system clipboard | not sure that i like it or that i works as intended
--vim.keymap.set("n", "<leader>y", "\"+y")
--vim.keymap.set("v", "<leader>y", "\"+y")
--vim.keymap.set("n", "<leader>Y", "\"+Y")

-- never press capital Q?
vim.keymap.set("n", "Q", "<nop>")

-- tmux switch project
-- vim.keymap.set("n", "<C-f>", "<cmd> silent !tmux neww tmux-sessionizer<CR>")

-- quickfix list mappings
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")

-- location list mappings
vim.keymap.set("n", "<leader>k", "<cmd>lprev<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>cprev<CR>zz")

-- search & replace for file under cursor
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
-- make file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "<leader>cfg", [[:e ~/.config/nvim/<CR>]])

-- gl - > $
-- gh - > 0
-- leader f - b = C_O , C_P
