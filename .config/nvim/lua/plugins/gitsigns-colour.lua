return {
	"lewis6991/gitsigns.nvim",
	opts = {
		current_line_blame = true,
		current_line_blame_opts = {
			delay = 300,
			virt_text_pos = "eol",
		},
	},
	config = function(_, opts)
		require("gitsigns").setup(opts)

		local function set_blame_colour()
			vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", {
				fg = "#c0c0c0",
				italic = true,
			})
		end

		set_blame_colour()

		vim.api.nvim_create_autocmd("ColorScheme", {
			callback = function()
				vim.schedule(set_blame_colour)
			end,
		})
	end,
}
