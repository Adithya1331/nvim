return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"saghen/blink.cmp",
			{
				"folke/lazydev.nvim",
				opts = {
					library = {
						{ path = "${3rd}/luv/library", words = { "vim%.uv" } }
					}
				}
			}
		},
		config = function()
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			-- Lua configuration
			require("lspconfig").lua_ls.setup {
				capabilities = capabilities
			}

			-- Python LSP configuration (Pyright)
			require("lspconfig").pyright.setup(
				{
					capabilities = capabilities,
					settings = {
						python = {
							analysis = {
								-- Disable organization of imports to use Ruff's organizer
								autoSearchPaths = true,
								useLibraryCodeForTypes = true,
								disableOrganizeImports = true,
								-- Ignore all files for analysis to exclusively use Ruff for linting
								ignore = { "*" }
							}
						}
					}
				}
			)

			-- Ruff LSP configuration
			require("lspconfig").ruff.setup(
				{
					capabilities = capabilities,
					init_options = {
						settings = {
							-- Ruff language server settings go here
							logLevel = "debug"               -- Enable logging in debug mode
						}
					},
					-- Optionally disable hover feature of Ruff in favor of Pyright
					on_attach = function(client, bufnr)
						if client.name == "ruff" then
							-- Disable hover in favor of Pyright
							client.server_capabilities.hoverProvider = false
						end
					end
				}
			)

			-- Auto-formatting for Python and Lua
			vim.api.nvim_create_autocmd(
				"LspAttach",
				{
					callback = function(args)
						local c = vim.lsp.get_client_by_id(args.data.client_id)
						if not c then
							return
						end

						-- Format on save for Python and Lua
						if vim.bo.filetype == "python" or vim.bo.filetype == "lua" then
							vim.api.nvim_create_autocmd(
								"BufWritePre",
								{
									buffer = args.buf,
									callback = function()
										vim.lsp.buf.format({ bufnr = args.buf, id = c.id })
									end
								}
							)
						end
					end
				}
			)
		end
	}
}
