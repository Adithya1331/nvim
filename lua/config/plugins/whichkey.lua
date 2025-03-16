return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		triggers = { "<leader>", "<space>" }, -- Auto-triggers for `<leader>` and `<space>` mappings
	},
	config = function()
		local wk = require("which-key")

		wk.setup()

		wk.add({
			{ "<space>",  group = "Custom Mappings" },
			{ "<space>x", "<cmd>source %<CR>",      desc = "Source current file" },
			{ "<space>v", "<C-v>",                  desc = "Visual Block Mode" },
			{
				"<space>to",
				function()
					vim.cmd.vnew()
					vim.cmd.term()
					vim.cmd.wincmd("J")
					vim.api.nvim_win_set_height(0, 5)
				end,
				desc = "Open terminal in split"
			},
			{
				"<space>te",
				function()
					current_command = vim.fn.input("Command: ")
				end,
				desc = "Set terminal command"
			},
			{
				"<space>tr",
				function()
					if current_command == "" then
						current_command = vim.fn.input("Command: ")
					end
					vim.fn.chansend(job_id, { current_command .. "/r/n" })
				end,
				desc = "Run terminal command"
			},
			{ "<space>fh", require("telescope.builtin").help_tags,  desc = "Find Help Tags" },
			{ "<space>fd", require("telescope.builtin").find_files, desc = "Find Files" },
			{
				"<space>en",
				function()
					require("telescope.builtin").find_files { cwd = vim.fn.stdpath("config") }
				end,
				desc = "Edit Neovim Config"
			},
			{
				"<space>ep",
				function()
					require("telescope.builtin").find_files { cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy") }
				end,
				desc = "Edit Plugins"
			},
			{ "<M-j>", "<cmd>cnext<CR>", desc = "Next Quickfix Item" },
			{ "<M-k>", "<cmd>cprev<CR>", desc = "Previous Quickfix Item" },
			{ "-",     "<cmd>Oil<CR>",   desc = "Open Oil File Manager" },
		})
	end,
}
