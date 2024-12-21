return {
	diagnostics = {
		disable = { "missing-fields", "incomplete-signature-doc" },
	},
	workspace = {
		checkThirdParty = false,
	},
	codeLens = {
		enable = true,
	},
	doc = {
		privateName = { "^_" },
	},
	hint = {
		enable = true,
		setType = false,
		paramType = true,
		paramName = "Disable",
		semicolon = "Disable",
		arrayIndex = "Disable",
	},
}
