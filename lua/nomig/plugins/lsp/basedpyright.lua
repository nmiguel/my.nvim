return {
	basedpyright = {
		disableOrganizeImports = true,
		disableTaggedHints = false,
		analysis = {
			autoImportCompletions = true,
			diagnosticMode = "openFilesOnly",
			autoSearchPaths = true,
			useLibraryCodeForTypes = true,
			typeCheckingMode = "basic",
			inlayHints = {
				variableTypes = true,
				callArgumentNames = true,
				functionReturnTypes = true,
				genericTypes = false,
			},
			diagnosticSeverityOverrides = {
				reportIgnoreCommentWithoutRule = true,
			},
			ignore = { "*" },
			exclude = { "**/venv", "**/__pycache__" },
		},
	},
}
