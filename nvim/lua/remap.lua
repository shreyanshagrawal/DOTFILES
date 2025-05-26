-- this helps copying stuff to clipboard
vim.keymap.set("n", "<leader>y", '"+y')
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>Y", '"+Y')

vim.keymap.set("i", "<leader>gf", "<Esc>")--exit insert mode

vim.keymap.set("v","J", ":m '>+1<CR>gv=gv")-- move selected line down
vim.keymap.set("v","K", ":m '<-2<CR>gv=gv")-- move selected line up

vim.keymap.set("n", "N", "Nzzzv")-- search to next line when search not found, it will move cursor to the middle of the screen
vim.keymap.set("n", "n", "nzzzv")-- search to next line when search not found, it will move cursor to the middle of the screen

vim.keymap.set("n", "<leader>sv", "<C-w>v")-- split window vertically
vim.keymap.set("n", "<leader>sh", "<C-w>s")-- split window horizontally
vim.keymap.set("n", "<leader>se", "<C-w>=")-- make all windows equal size
vim.keymap.set("n", "<leader>sx", ":close<CR>")-- close current window

vim.keymap.set("v", "<" , "<gv" )--indenting
vim.keymap.set("v", ">" , ">gv" )--indenting

vim.keymap.set("n" , "<leader>s" , [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<left><left><left>]])-- search and replace in the whole file
--vim.keymap.set("n" , "<leader>x", ":!chmod +x %<CR>")-- make the current file executable

vim.keymap.set("n", "<leader>e" , "@" )--execute the macro in register 
--plugins--

--lsp
vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')
vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')
vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')
vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')
vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>')
vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>')
vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>')
vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>')
vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>')
vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>')
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {}, { desc = "coding action in lsp" })

--neotree
vim.keymap.set("n", "<leader>nn", ":Neotree filesystem reveal left<CR>", { desc = "Neotree open" })
vim.keymap.set("n", "<leader>nc", ":Neotree close<CR>", { desc = "Neotree close" })

--none-ls
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, {}, { desc = "difination in lsp" })

--telescope
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
