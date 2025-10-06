-- Web Development Setup for Next.js + Tailwind v4 + Biome + Prettier
return {
	-- ========================================
	-- Language Support & TypeScript
	-- ========================================

	-- Enhanced TypeScript support
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				-- TypeScript Language Server with Next.js optimizations
				tsserver = {
					settings = {
						typescript = {
							inlayHints = {
								includeInlayParameterNameHints = "all",
								includeInlayParameterNameHintsWhenArgumentMatchesName = false,
								includeInlayFunctionParameterTypeHints = true,
								includeInlayVariableTypeHints = true,
								includeInlayPropertyDeclarationTypeHints = true,
								includeInlayFunctionLikeReturnTypeHints = true,
								includeInlayEnumMemberValueHints = true,
							},
						},
						javascript = {
							inlayHints = {
								includeInlayParameterNameHints = "all",
								includeInlayParameterNameHintsWhenArgumentMatchesName = false,
								includeInlayFunctionParameterTypeHints = true,
								includeInlayVariableTypeHints = true,
								includeInlayPropertyDeclarationTypeHints = true,
								includeInlayFunctionLikeReturnTypeHints = true,
								includeInlayEnumMemberValueHints = true,
							},
						},
					},
				},

				-- Tailwind CSS Language Server with v4 support
				tailwindcss = {
					settings = {
						tailwindCSS = {
							experimental = {
								classRegex = {
									-- Enable for various string patterns
									"class[Nn]ame[s]?\\s*[:=]\\s*['\"`]([^'\"`]*)['\"`]",
									"cn\\(([^)]*)\\)",
									"clsx\\(([^)]*)\\)",
									"cva\\(([^)]*)\\)",
									"tw\\`([^`]*)",
								},
							},
							includeLanguages = {
								typescript = "javascript",
								typescriptreact = "javascript",
							},
						},
					},
				},

				-- CSS Language Server
				cssls = {
					settings = {
						css = {
							validate = true,
							lint = {
								unknownAtRules = "ignore", -- For Tailwind directives
							},
						},
						scss = {
							validate = true,
							lint = {
								unknownAtRules = "ignore",
							},
						},
					},
				},

				-- JSON Language Server
				jsonls = {},

				-- Emmet for HTML/JSX
				emmet_ls = {
					filetypes = {
						"html",
						"css",
						"scss",
						"javascript",
						"typescript",
						"javascriptreact",
						"typescriptreact",
					},
				},
			},
		},
	},

	-- ========================================
	-- Formatting with Biome + Prettier
	-- ========================================

	-- conform.nvim for intelligent formatting
	{
		"stevearc/conform.nvim",
		optional = true,
		opts = {
			formatters_by_ft = {
				-- Use Biome for JS/TS (ultra-fast)
				javascript = { "biome" },
				typescript = { "biome" },
				javascriptreact = { "biome" },
				typescriptreact = { "biome" },
				json = { "biome" },
				jsonc = { "biome" },

				-- Use Prettier for other formats
				css = { "prettier" },
				scss = { "prettier" },
				html = { "prettier" },
				markdown = { "prettier" },
				yaml = { "prettier" },

				-- Lua formatting
				lua = { "stylua" },
			},
			formatters = {
				biome = {
					command = "biome",
					args = { "format", "--stdin-file-path", "$FILENAME" },
					stdin = true,
				},
			},
		},
	},

	-- ========================================
	-- Visual Enhancements
	-- ========================================

	-- Color preview for CSS and Tailwind
	{
		"NvChad/nvim-colorizer.lua",
		opts = {
			filetypes = { "*" },
			user_default_options = {
				RGB = true,
				RRGGBB = true,
				names = true,
				RRGGBBAA = true,
				AARRGGBB = true,
				rgb_fn = true,
				hsl_fn = true,
				css = true,
				css_fn = true,
				mode = "background",
				tailwind = true, -- Enable Tailwind CSS colors
				sass = { enable = true, parsers = { "css" } },
			},
		},
	},

	-- Auto tag closing for JSX
	{
		"windwp/nvim-ts-autotag",
		event = "LazyFile",
		opts = {},
	},

	-- Better indentation guides (LazyVim already includes this)
	-- Removed duplicate configuration to avoid version conflicts

	-- ========================================
	-- Enhanced Treesitter
	-- ========================================

	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, {
				"css",
				"scss",
				"html",
				"javascript",
				"typescript",
				"tsx",
				"json",
				"jsonc",
				"yaml",
				"toml",
				"prisma",
			})
		end,
	},

	-- ========================================
	-- Package.json Integration
	-- ========================================

	-- Package info display
	{
		"vuki656/package-info.nvim",
		dependencies = "MunifTanjim/nui.nvim",
		opts = {},
		event = { "BufRead package.json" },
	},

	-- ========================================
	-- Mason Tool Management
	-- ========================================

	{
		"mason-org/mason.nvim",
		opts = function(_, opts)
			-- Note: Most LSP servers are auto-installed by LazyVim extras (see language-extras.lua)
			-- Only list packages here that are NOT provided by LazyVim extras to avoid race conditions
			vim.list_extend(opts.ensure_installed, {
				-- Custom formatters (not in LazyVim extras)
				"biome", -- Rust-based formatter for JS/TS (faster than Prettier)
				"stylua", -- Lua formatter

				-- Debug adapters (not in LazyVim extras)
				"js-debug-adapter",

				-- Additional linting/tools (not in LazyVim extras)
				"stylelint-lsp", -- CSS/SCSS linting
				"yaml-language-server", -- YAML support
			})
		end,
	},
}
