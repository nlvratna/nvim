require("leela.core")
require("leela.lazy")

if vim.fn.has("wsl") == 1 then
	vim.g.clipboard = {
		name = "win32yank-wsl",
		copy = {
			["+"] = "win32yank.exe -i --crlf",
			["*"] = "win32yank.exe -i --crlf",
		},
		paste = {
			["+"] = "win32yank.exe -o --lf",
			["*"] = "win32yank.exe -o --lf",
		},
		cache_enabled = 0,
	}
else
	vim.g.clipboard = {
		name = "wl-clipboard",
		copy = {
			["+"] = "wl-copy --foreground --type text/plain",
			["*"] = "wl-copy --foreground --type text/plain",
		},
		paste = {
			["+"] = "wl-paste --no-newline",
			["*"] = "wl-paste --no-newline",
		},
		cache_enabled = 1,
	}
end
