local M = {}

-- 📘 Vim Commands
local commands = {
  { name = ":w        → Save file", cmd = "w" },
  { name = ":wa       → Save all files", cmd = "wa" },
  { name = ":wq       → Save and quit", cmd = "wq" },
  { name = ":q        → Quit", cmd = "q" },
  { name = ":q!       → Force quit", cmd = "q!" },
  { name = ":e file   → Open file", cmd = "e file" },
  { name = ":Ex       → File explorer", cmd = "Ex" },
  { name = ":noh      → Clear search highlights", cmd = "noh" },
  { name = ":%s/old/new/g → Replace text", cmd = "%s/old/new/g" },
  { name = ":tabnew   → New tab", cmd = "tabnew" },
  { name = ":bn       → Next buffer", cmd = "bn" },
  { name = ":bp       → Previous buffer", cmd = "bp" },
  { name = ":bd       → Delete buffer", cmd = "bd" },
  { name = ":sp file  → Horizontal split", cmd = "sp file" },
  { name = ":vs file  → Vertical split", cmd = "vs file" },
  { name = ":only     → Close other splits", cmd = "only" },
  { name = ":set number  → Show line numbers", cmd = "set number" },
  { name = ":set relativenumber → Relative line numbers", cmd = "set relativenumber" },
  { name = ":colorscheme desert → Change colorscheme", cmd = "colorscheme desert" },
  { name = ":w!       → Force save file", cmd = "w!" },
  { name = ":e!       → Reload file", cmd = "e!" },
  { name = ":qa       → Quit all", cmd = "qa" },
  { name = ":wqa      → Save all and quit", cmd = "wqa" },
  { name = ":tabnext  → Next tab", cmd = "tabnext" },
  { name = ":tabprev  → Previous tab", cmd = "tabprev" },
  { name = ":tabclose → Close current tab", cmd = "tabclose" },
  { name = ":b #      → Switch to previous buffer", cmd = "b #" },
  { name = ":set wrap  → Enable line wrapping", cmd = "set wrap" },
  { name = ":set nowrap → Disable line wrapping", cmd = "set nowrap" },
  { name = ":set ignorecase → Ignore case in search", cmd = "set ignorecase" },
  { name = ":set noignorecase → Case-sensitive search", cmd = "set noignorecase" },
  { name = ":set hlsearch → Highlight search results", cmd = "set hlsearch" },
  { name = ":set nohlsearch → Disable search highlight", cmd = "set nohlsearch" },
  { name = ":set incsearch → Incremental search", cmd = "set incsearch" },
  { name = ":set spell → Enable spell checking", cmd = "set spell" },
  { name = ":set nospell → Disable spell checking", cmd = "set nospell" },
  { name = ":bufdo cmd → Execute cmd in all buffers", cmd = "bufdo cmd" },
  { name = ":mksession → Save session", cmd = "mksession" },
  { name = ":source file → Source a Vim script", cmd = "source file" },
  { name = ":set cursorline → Highlight current line", cmd = "set cursorline" },
  { name = ":set nocursorline → Disable line highlight", cmd = "set nocursorline" },
  { name = ":set list → Show hidden characters", cmd = "set list" },
  { name = ":set nolist → Hide hidden characters", cmd = "set nolist" },
}

-- 🎹 Vim Keymaps
local keymaps = {
  -- Normal mode
  { name = "i       → Insert mode", cmd = "normal! i" },
  { name = "a       → Append after cursor", cmd = "normal! a" },
  { name = "A       → Append end of line", cmd = "normal! A" },
  { name = "o       → New line below", cmd = "normal! o" },
  { name = "O       → New line above", cmd = "normal! O" },
  { name = "x       → Delete char under cursor", cmd = "normal! x" },
  { name = "X       → Delete char before cursor", cmd = "normal! X" },
  { name = "u       → Undo", cmd = "normal! u" },
  { name = "Ctrl-r  → Redo", cmd = "normal! <C-r>" },
  { name = "yy      → Yank line", cmd = "normal! yy" },
  { name = "p       → Paste after", cmd = "normal! p" },
  { name = "P       → Paste before", cmd = "normal! P" },
  { name = "dd      → Delete line", cmd = "normal! dd" },
  { name = "D       → Delete to EOL", cmd = "normal! D" },
  { name = ">>      → Indent line", cmd = "normal! >>" },
  { name = "<<      → Outdent line", cmd = "normal! <<" },
  { name = "J       → Join lines", cmd = "normal! J" },
  { name = ":       → Command mode", cmd = ":" },
  { name = "ciw     → Change inner word", cmd = "normal! ciw" },
  { name = "diw     → Delete inner word", cmd = "normal! diw" },
  { name = "yiw     → Yank inner word", cmd = "normal! yiw" },
  { name = "cc      → Change line", cmd = "normal! cc" },
  { name = "S       → Substitute line", cmd = "normal! S" },
  { name = "C       → Change to EOL", cmd = "normal! C" },
  { name = "r       → Replace char", cmd = "normal! r" },
  { name = "~       → Toggle case", cmd = "normal! ~" },
  { name = "guw     → Lowercase word", cmd = "normal! guw" },
  { name = "gUw     → Uppercase word", cmd = "normal! gUw" },
  { name = "g~~     → Toggle case line", cmd = "normal! g~~" },
  { name = "==      → Auto-indent line", cmd = "normal! ==" },

  -- Movement
  { name = "0       → Start of line", cmd = "normal! 0" },
  { name = "$       → End of line", cmd = "normal! $" },
  { name = "^       → First non-blank char", cmd = "normal! ^" },
  { name = "gg      → Top of file", cmd = "normal! gg" },
  { name = "G       → Bottom of file", cmd = "normal! G" },
  { name = "w       → Next word", cmd = "normal! w" },
  { name = "e       → End of word", cmd = "normal! e" },
  { name = "b       → Beginning of word", cmd = "normal! b" },
  { name = "Ctrl-d  → Half-page down", cmd = "normal! <C-d>" },
  { name = "Ctrl-u  → Half-page up", cmd = "normal! <C-u>" },
  { name = "Ctrl-f  → Page down", cmd = "normal! <C-f>" },
  { name = "Ctrl-b  → Page up", cmd = "normal! <C-b>" },
  { name = "H       → Top of screen", cmd = "normal! H" },
  { name = "M       → Middle of screen", cmd = "normal! M" },
  { name = "L       → Bottom of screen", cmd = "normal! L" },
  { name = "%       → Jump to matching bracket", cmd = "normal! %" },
  { name = "{       → Previous paragraph", cmd = "normal! {" },
  { name = "}       → Next paragraph", cmd = "normal! }" },
  { name = "[[      → Previous section", cmd = "normal! [[" },
  { name = "]]      → Next section", cmd = "normal! ]]" },
  { name = "f{char} → Find char forward", cmd = "normal! f" },
  { name = "F{char} → Find char backward", cmd = "normal! F" },
  { name = "t{char} → Till char forward", cmd = "normal! t" },
  { name = "T{char} → Till char backward", cmd = "normal! T" },
  { name = ";       → Repeat last f/t", cmd = "normal! ;" },
  { name = ",       → Repeat last f/t backward", cmd = "normal! ," },

  -- Visual mode
  { name = "v       → Visual mode", cmd = "normal! v" },
  { name = "V       → Visual line", cmd = "normal! V" },
  { name = "Ctrl-v  → Visual block", cmd = "normal! <C-v>" },
  { name = "y       → Yank selection", cmd = "normal! y" },
  { name = "d       → Delete selection", cmd = "normal! d" },
  { name = ">       → Indent selection", cmd = "normal! >" },
  { name = "<       → Outdent selection", cmd = "normal! <" },
  { name = "o       → Toggle cursor in visual", cmd = "normal! o" },
  { name = "~       → Toggle case selection", cmd = "normal! ~" },
  { name = "gU      → Uppercase selection", cmd = "normal! gU" },
  { name = "gu      → Lowercase selection", cmd = "normal! gu" },

  -- Search
  { name = "/word   → Search word", cmd = "/word" },
  { name = "?word   → Search backward", cmd = "?word" },
  { name = "n       → Next match", cmd = "normal! n" },
  { name = "N       → Previous match", cmd = "normal! N" },
  { name = "*       → Search word under cursor", cmd = "normal! *" },
  { name = "#       → Search word backward", cmd = "normal! #" },

  -- Window management
  { name = "Ctrl-w s → Split horizontally", cmd = "wincmd s" },
  { name = "Ctrl-w v → Split vertically", cmd = "wincmd v" },
  { name = "Ctrl-w q → Close split", cmd = "wincmd q" },
  { name = "Ctrl-w o → Close others", cmd = "wincmd o" },
  { name = "Ctrl-w h → Move left", cmd = "wincmd h" },
  { name = "Ctrl-w l → Move right", cmd = "wincmd l" },
  { name = "Ctrl-w j → Move down", cmd = "wincmd j" },
  { name = "Ctrl-w k → Move up", cmd = "wincmd k" },
  { name = "Ctrl-w = → Equalize splits", cmd = "wincmd =" },
  { name = "Ctrl-w _ → Maximize split vertically", cmd = "wincmd _" },
  { name = "Ctrl-w | → Maximize split horizontally", cmd = "wincmd |" },
  { name = "Ctrl-w r → Rotate splits", cmd = "wincmd r" },

  -- Insert mode
  { name = "Ctrl-a  → Insert last inserted text", cmd = "normal! <C-a>" },
  { name = "Ctrl-e  → Insert end of line", cmd = "normal! <C-e>" },
  { name = "Ctrl-h  → Backspace", cmd = "normal! <BS>" },
  { name = "Ctrl-w  → Delete previous word", cmd = "normal! <C-w>" },
  { name = "Ctrl-u  → Delete to line start", cmd = "normal! <C-u>" },
  { name = "Ctrl-k  → Delete to line end", cmd = "normal! <C-k>" },
  { name = "Ctrl-n  → Next completion", cmd = "normal! <C-n>" },
  { name = "Ctrl-p  → Previous completion", cmd = "normal! <C-p>" },
}

M.learn_items = vim.list_extend(commands, keymaps)

M.open = function()
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  pickers.new({}, {
    prompt_title = "NitroLearn (Vim Commands + Keymaps)",
    finder = finders.new_table {
      results = M.learn_items,
      entry_maker = function(entry)
        local cmd_part, desc_part = entry.name:match("^(.-)%s*→%s*(.+)$")
        cmd_part = cmd_part or entry.name
        desc_part = desc_part or ""
        return {
          value = entry,
          display = function()
            return cmd_part .. " → " .. desc_part, {
              { { 0, #cmd_part }, "NitroLearnCmdHighlight" }
            }
          end,
          ordinal = entry.name,
        }
      end,
    },
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      local run_cmd = function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        vim.cmd("echo 'Learn: " .. selection.value.name .. "'")
      end
      map("i", "<CR>", run_cmd)
      map("n", "<CR>", run_cmd)
      return true
    end,
  }):find()
end

vim.api.nvim_set_hl(0, "NitroLearnCmdHighlight", { fg = "#00FF00" })

vim.api.nvim_create_user_command("NitroLearn", function()
  M.open()
end, {})

return M
