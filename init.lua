vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.o.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.startup_cwd = vim.fn.getcwd()

-- require("core.options") later?
require("core.keymaps")
require("config.startbuffer")
-- require("core.autocmds") later?

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup("plugins")
