local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({

		trig = "test",
		snippetType = "snippet",
	}, {
		t("test"),
		i(1),
		t("wtest"),
		i(2),
	}),
}
