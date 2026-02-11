return {
	"chrisgrieser/nvim-various-textobjs",
	event = "VeryLazy",
	opts = { useDefaultKeymaps = false }, -- Set to true if you want everything, but manual is cleaner
	keys = {
		{ "iu", '<cmd>lua require("various-textobjs").url()<cr>', mode = { "o", "x" }, desc = "Inner URL" },

		-- indent: 'ai' / 'ii' (like 'it' for tags, but for indentation levels)
		{
			"ii",
			'<cmd>lua require("various-textobjs").indentation("inner", "inner")<cr>',
			mode = { "o", "x" },
			desc = "Inner Indent",
		},
		{
			"ai",
			'<cmd>lua require("various-textobjs").indentation("outer", "inner")<cr>',
			mode = { "o", "x" },
			desc = "Outer Indent",
		},

		--  Near-cursor word (handy when you're slightly off a word)
		{ "n", '<cmd>lua require("various-textobjs").nearEOW()<cr>', mode = { "o", "x" }, desc = "Near End of Word" },

		--  Value: in 'key = value' or 'key: value', targets the value
		{ "iv", '<cmd>lua require("various-textobjs").value("inner")<cr>', mode = { "o", "x" }, desc = "Inner Value" },
		{ "av", '<cmd>lua require("various-textobjs").value("outer")<cr>', mode = { "o", "x" }, desc = "Outer Value" },

		--  Chain: targets parts of a shell pipe or method chain
		{
			"ic",
			'<cmd>lua require("various-textobjs").chainMember("inner")<cr>',
			mode = { "o", "x" },
			desc = "Inner Chain Member",
		},
	},
}
