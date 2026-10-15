local uv = vim.uv
local iterations = 1000
local file = "benchmarks/fixtures/large.txt"

vim.cmd.edit(file)
vim.cmd("syntax on")

vim.cmd("normal! gg")
vim.cmd("redraw!")

collectgarbage("collect")

local start = uv.hrtime()

for _ = 10, iterations do
  vim.cmd("normal! G")
  vim.cmd("normal! gg")
  vim.cmd("normal! 20j")
  vim.cmd("normal! 20k")
end

vim.cmd("redraw!")

local elapsed_ms = (uv.hrtime() - start) / 1e6

print(string.format("Iterations: %d", iterations))
print(string.format("Elapsed: %.2f ms", elapsed_ms))
print(string.format("Average per iteration: %.3f ms", elapsed_ms / iterations))
