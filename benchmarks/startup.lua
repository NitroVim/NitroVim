local uv = vim.uv
local iterations = 10
local times = {}

for i = 1, iterations do
  local start = uv.hrtime()

  require("nitro.core.options")

  local elapsed = (uv.hrtime() - start) / 1e6
  times[#times + 1] = elapsed
end

table.sort(times)

local total = 0
for _, time in ipairs(times) do
  total = total + time
end

print(string.format("Iterations: %d", iterations))
print(string.format("Average: %.3f ms", total / iterations))
print(string.format("Min: %.3f ms", times[1]))
print(string.format("Max: %.3f ms", times[#times]))
