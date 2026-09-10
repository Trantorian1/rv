if vim.g.did_load_rustaceanvim then
	return
end
vim.g.did_load_rustaceanvim = true

---@type rustaceanvim.Opts
vim.g.rustaceanvim = {
	tools = {
		enable_clippy = false,
		float_win_config = {
			auto_focus = true,
			open_split = "vertical",
			border = "rounded",
		},
	},
	server = {
		on_attach = function(_, _)
			vim.keymap.set("n", "<leader>rme", function()
				vim.cmd.RustLsp("expandMacro")
			end, { desc = "[R]ust [M]acro [E]xpand" })

			vim.keymap.set("n", "<leader>rmr", function()
				vim.cmd.RustLsp("rebuildProcMacros")
			end, { desc = "[R]ust [M]acro [R]ebuild" })

			vim.keymap.set("n", "<leader>e", function()
				vim.cmd.RustLsp("renderDiagnostic", "current")
			end, { desc = "hover diagnostic" })

			vim.keymap.set("n", "gtt", function()
				vim.cmd.RustLsp("relatedTests")
			end, { desc = "[G]oto related [T]ests" })

			vim.keymap.set("n", "<leader>roc", function()
				vim.cmd.RustLsp("openCargo")
			end, { desc = "[R]ust [O]pen [C]argo" })

			vim.keymap.set("n", "<leader>rod", function()
				vim.cmd.RustLsp("openDocs")
			end, { desc = "[R]ust [O]pen [D]ocs" })

			vim.keymap.set("n", "<leader>rpm", function()
				vim.cmd.RustLsp("parentModule")
			end, { desc = "[R]ust [P]arent [M]odule" })

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "qf",
				callback = function()
					if vim.fn.getqflist({ title = 0 }).title ~= "related tests" then
						return
					end
					vim.schedule(function()
						vim.cmd.cclose()
						require("telescope.builtin").quickfix({ prompt_title = "Related Tests" })
					end)
				end,
			})
		end,

		default_settings = {
			-- rust-analyzer language server configuration
			["rust-analyzer"] = {
				rust = {
					-- Use a separate target dir for Rust Analyzer. Helpful if you want to use Rust
					-- Analyzer and cargo on the command line at the same time.
					analyzerTargetDir = "target/nvim-rust-analyzer",
				},
				server = {
					--  Improve stability
					extraEnv = {
						["CHALK_OVERFLOW_DEPTH"] = "100000000",
						["CHALK_SOLVER_MAX_SIZE"] = "100000000",
					},
				},
				files = {
					excludeDirs = { "target" },
				},
				cargo = {
					-- Check feature-gated code
					features = "all",
					extraEnv = {
						-- Skip building WASM, there is never need for it here
						["SKIP_WASM_BUILD"] = "1",
					},
				},
				procMacro = {
					-- Don't expand some problematic proc_macros
					ignored = {
						["napi-derive"] = { "napi" },
						["async-recursion"] = { "async_recursion" },
						["async-std"] = { "async_std" },
					},
				},
				rustfmt = {
					-- Use nightly formatting.
					-- See the polkadot-sdk CI job that checks formatting for the current version used in
					-- polkadot-sdk.
					extraArgs = { "+nightly-2024-04-10" },
				},
			},
		},
	},
}
