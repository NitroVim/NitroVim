local ls = require("luasnip")

require("luasnip.loaders.from_vscode").lazy_load()

ls.filetype_extend("scss", { "css" })
ls.filetype_extend("sass", { "css" })
ls.filetype_extend("javascript", { "html", "css" })
ls.filetype_extend("python", { "django" })
ls.filetype_extend("razor", { "html", "cs" })
ls.filetype_extend("c", { "cpp" })
ls.filetype_extend("cpp", { "c" })

vim.keymap.set({ "i" }, "<C-k>", function()
	if ls.expand_or_jumpable() then
		ls.expand_or_jump()
	end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<C-j>", function()
	if ls.jumpable(-1) then
		ls.jump(-1)
	end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<C-l>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end, { silent = true })
