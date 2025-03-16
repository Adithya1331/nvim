return {
	-- nvim-cmp and Snippets configuration
	{
		'hrsh7th/nvim-cmp',
		dependencies = {
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			'saadparwaiz1/cmp_luasnip',
			'L3MON4D3/LuaSnip',
			'rafamadriz/friendly-snippets', -- Snippets for Lua and Python
		},

		config = function()
			local cmp = require('cmp')
			local luasnip = require('luasnip')

			-- Set up nvim-cmp.
			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body) -- Use LuaSnip for snippets expansion
					end,
				},
				mapping = cmp.mapping.preset.insert({
					['<C-b>'] = cmp.mapping.scroll_docs(-4),
					['<C-f>'] = cmp.mapping.scroll_docs(4),
					['<C-Space>'] = cmp.mapping.complete(),
					['<C-e>'] = cmp.mapping.abort(),
					['<Tab>'] = cmp.mapping.select_next_item(),
					['<S-Tab>'] = cmp.mapping.select_prev_item(),
					['<CR>'] = cmp.mapping.confirm({ select = true }),
				}),
				sources = {
					{ name = 'nvim_lsp' },
					{ name = 'luasnip' },
					{ name = 'buffer' },
					{ name = 'path' },
				},
				formatting = {
					format = function(entry, vim_item)
						vim_item.menu = ({
							nvim_lsp = '[LSP]',
							luasnip = '[Snip]',
							buffer = '[Buffer]',
							path = '[Path]',
						})[entry.source.name]
						return vim_item
					end,
				},
			})

			-- Setup LuaSnip
			require('luasnip.loaders.from_vscode').lazy_load()

			-- Optional: Auto-completion for Python and Lua
			-- Set up nvim-cmp completion for LSP
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			require('lspconfig').pyright.setup({ capabilities = capabilities })
		end,
	},
}
