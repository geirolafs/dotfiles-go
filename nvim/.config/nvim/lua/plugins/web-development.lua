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
				-- Biome LSP for real-time linting and diagnostics
				biome = {},

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
					-- Help LSP find Tailwind v4 CSS-based config
					root_dir = require("lspconfig.util").root_pattern(
						"tailwind.config.js",
						"tailwind.config.ts",
						"postcss.config.js",
						"package.json"
					),
					settings = {
						tailwindCSS = {
							experimental = {
								-- Point to CSS file with @theme configuration (Tailwind v4)
								configFile = "src/styles/globals.css",
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
	-- Note: biome-check runs "biome check --write" which:
	--   - Formats code according to biome.jsonc rules
	--   - Fixes linting errors (safe fixes by default)
	--   - Organizes and sorts imports
	--   - Sorts JSX attributes (per ultracite config)
	{
		"stevearc/conform.nvim",
		optional = true,
		opts = {
			formatters_by_ft = {
				-- Use Biome for JS/TS/JSON (ultra-fast, with linting + import sorting)
				javascript = { "biome-check" },
				typescript = { "biome-check" },
				javascriptreact = { "biome-check" },
				typescriptreact = { "biome-check" },
				json = { "biome-check" },
				jsonc = { "biome-check" },

				-- Use Prettier for other formats
				css = { "prettier" },
				scss = { "prettier" },
				html = { "prettier" },
				markdown = { "prettier" },
				yaml = { "prettier" },

				-- Lua formatting
				lua = { "stylua" },
			},
			-- No custom formatters needed - conform.nvim has built-in biome-check support
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
