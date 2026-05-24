return {
  name = "ols",
  cmd = { "ols" },
  filetypes = { "odin" },
  root_dir = vim.fs.root(0, { "*.odin", "ols.json", ".git" }),
}
