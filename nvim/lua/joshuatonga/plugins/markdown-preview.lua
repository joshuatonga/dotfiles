return {
	"iamcco/markdown-preview.nvim",
	build = function()
		vim.fn["mkdp#util#install"]()
	end,

	ft = { "markdown" },

	cmd = { "MP", "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },

	config = function()
		vim.api.nvim_create_user_command("MP", "MarkdownPreview", {})
	end,
}
