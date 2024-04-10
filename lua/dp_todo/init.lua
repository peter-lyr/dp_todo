local sta, B = pcall(require, 'dp_base')

if not sta then return print('Dp_base is required!', debug.getinfo(1)['source']) end

if B.check_plugins {
      -- 'git@github.com:peter-lyr/dp_init',
      'folke/which-key.nvim',
      -- 'folke/todo-comments.nvim',
      'peter-lyr/todo-comments.nvim',
      'monaqa/dial.nvim',
    } then
  return
end

local M  = {}

M.source = B.getsource(debug.getinfo(1)['source'])
M.lua    = B.getlua(M.source)

M.todos  = {
  fix  = { 'FIX', 'FIXME', 'BUG', 'FIXIT', 'ISSUE', },
  todo = { 'TODO', },
  hack = { 'HACK', },
  warn = { 'WARN', 'WARNING', 'XXX', },
  perf = { 'PERF', 'OPTIM', 'PERFORMANCE', 'OPTIMIZE', },
  note = { 'NOTE', 'INFO', },
  test = { 'TEST', 'TESTING', 'PASSED', 'FAILED', },
}

function M.dials_do(item)
  return { string.format('[ ] %s:', item), string.format('[x] %sDONE:', item), }
end

function M.dials()
  local items = {}
  local dials = {}
  for _, item in pairs(M.todos) do
    items = B.merge_tables(items, item)
  end
  for _, item in pairs(items) do
    dials[#dials + 1] = M.dials_do(item)
  end
  return dials
end

function M.todo_done(what)
  local temp = {}
  for _, t in ipairs(M.todos[what]) do
    temp[#temp + 1] = t .. 'DONE'
  end
  return temp
end

require 'todo-comments'.setup {
  keywords = {
    FIX      = { icon = ' ', alt = M.todos.fix, color = 'error', },
    TODO     = { icon = '⍻ ', alt = M.todos.todo, color = 'info', },
    HACK     = { icon = ' ', alt = M.todos.hack, color = 'warning', },
    WARN     = { icon = ' ', alt = M.todos.warn, color = 'warning', },
    PERF     = { icon = ' ', alt = M.todos.perf, },
    NOTE     = { icon = ' ', alt = M.todos.note, color = 'hint', },
    TEST     = { icon = '⏲ ', alt = M.todos.test, color = 'test', },
    FIXDONE  = { icon = ' ', alt = M.todo_done 'fix', color = 'info', },
    TODODONE = { icon = ' ', alt = M.todo_done 'todo', color = 'info', },
    HACKDONE = { icon = ' ', alt = M.todo_done 'hack', color = 'info', },
    WARNDONE = { icon = ' ', alt = M.todo_done 'warn', color = 'info', },
    PERFDONE = { icon = ' ', alt = M.todo_done 'perf', },
    NOTEDONE = { icon = ' ', alt = M.todo_done 'note', color = 'hint', },
    TESTDONE = { icon = '⏲ ', alt = M.todo_done 'test', color = 'info', },
  },
  highlight = {
    comments_only = false,
  },
}

B.set_timeout(200, function()
  require 'todo-comments.highlight'.highlight_win(nil, 1)
end)

function M.telescope(what)
  local cwd = B.rep(vim.loop.cwd())
  B.cmd('TodoTelescope cwd=%s keywords=%s', cwd, what)
end

function M.quickfix(what)
  local cwd = B.rep(vim.loop.cwd())
  B.cmd('TodoQuickFix cwd=%s keywords=%s', cwd, what)
end

local augend = require 'dial.augend'

local default = {
  augend.constant.alias.de_weekday,
  augend.constant.alias.de_weekday_full,
  -- augend.constant.new { elements = { '&&', '||', }, word = false, },
  -- augend.constant.new { elements = { '<', '>', }, },
  -- augend.constant.new { elements = { '+', '-', }, },
  -- augend.constant.new { elements = { '*', '/', }, },
  -- augend.constant.new { elements = { '<=', '>=', }, },
  -- augend.constant.new { elements = { '==', '!=', }, word = false, },
  -- augend.constant.new { elements = { '++', '--', }, word = false, },
  augend.constant.new { elements = { 'TRUE', 'FALSE', }, },
  augend.constant.new { elements = { 'True', 'False', }, },
  augend.constant.new { elements = { 'true', 'false', }, },
  augend.constant.new { elements = { 'YES', 'NO', }, },
  augend.constant.new { elements = { 'Yes', 'No', }, },
  augend.constant.new { elements = { 'and', 'or', }, },
  augend.constant.new { elements = { 'yes', 'no', }, },
  augend.constant.new { elements = { 'on', 'off', }, },
  augend.constant.new { elements = { 'On', 'Off', }, },
  augend.constant.new { elements = { 'ON', 'OFF', }, },
  augend.constant.new { elements = { '_prev', '_next', }, word = false, },
  augend.constant.new { elements = { 'prev_', 'next_', }, word = false, },
  augend.constant.new { elements = { 'Prev', 'Next', }, word = false, },
  -- c
  -- augend.constant.new { elements = { '%d', '%s', '%x', }, word = false, },
  augend.constant.new { elements = { 'signed', 'unsigned', }, },
  augend.constant.new { elements = { 'u8', 'u16', 'u32', 'u64', }, },
  augend.constant.new { elements = { 's8', 's16', 's32', 's64', }, },
  augend.constant.new { elements = { 'char', 'short', 'int', 'long', }, },
  -- date time
  augend.date.alias['%-d.%-m.'],
  augend.date.alias['%-m/%-d'],
  augend.date.alias['%H:%M'],
  augend.date.alias['%H:%M:%S'],
  augend.date.alias['%Y-%m-%d'],
  augend.date.alias['%Y/%m/%d'],
  augend.date.alias['%Y年%-m月%-d日'],
  augend.date.alias['%d.%m.'],
  augend.date.alias['%d.%m.%Y'],
  augend.date.alias['%d.%m.%y'],
  augend.date.alias['%d/%m/%Y'],
  augend.date.alias['%d/%m/%y'],
  augend.date.alias['%m/%d'],
  augend.date.alias['%m/%d/%Y'],
  augend.date.alias['%m/%d/%y'],
  augend.date.alias['%H:%M'],
  augend.date.alias['%Y-%m-%d'],
  augend.date.alias['%Y/%m/%d'],
  augend.date.alias['%m/%d'],
  augend.integer.alias.binary,
  augend.integer.alias.decimal,
  augend.integer.alias.decimal_int,
  augend.integer.alias.hex,
  augend.integer.alias.octal,
  augend.semver.alias.semver,
}

for _, dial in ipairs(M.dials()) do
  default[#default + 1] = augend.constant.new { elements = dial, word = false, }
end

require 'dial.config'.augends:register_group {
  default = default,
}

require 'which-key'.register {
  [']t'] = { function() require 'todo-comments'.jump_next() end, 'Next todo comment', mode = { 'n', 'v', }, silent = true, },
  ['[t'] = { function() require 'todo-comments'.jump_prev() end, 'Prev todo comment', mode = { 'n', 'v', }, silent = true, },
  ['<leader>t<leader>'] = { name = 'TodoTelescope', },
  ['<leader>t<leader>f'] = { function() M.telescope 'FIX' end, 'TodoTelescope  FIX', mode = { 'n', 'v', }, silent = true, },
  ['<leader>t<leader>d'] = { function() M.telescope 'TODO' end, 'TodoTelescope TODO', mode = { 'n', 'v', }, silent = true, },
  ['<leader>t<leader>h'] = { function() M.telescope 'HACK' end, 'TodoTelescope HACK', mode = { 'n', 'v', }, silent = true, },
  ['<leader>t<leader>w'] = { function() M.telescope 'WARN' end, 'TodoTelescope WARN', mode = { 'n', 'v', }, silent = true, },
  ['<leader>t<leader>p'] = { function() M.telescope 'PERF' end, 'TodoTelescope PERF', mode = { 'n', 'v', }, silent = true, },
  ['<leader>t<leader>n'] = { function() M.telescope 'NOTE' end, 'TodoTelescope NOTE', mode = { 'n', 'v', }, silent = true, },
  ['<leader>t<leader>t'] = { function() M.telescope 'TEST' end, 'TodoTelescope TEST', mode = { 'n', 'v', }, silent = true, },
  ['<leader>t<leader><leader>'] = { name = 'TodoTelescope DONE', },
  ['<leader>t<leader><leader>f'] = { function() M.telescope 'FIXDONE' end, 'TodoTelescope  FIXDONE', mode = { 'n', 'v', }, silent = true, },
  ['<leader>t<leader><leader>d'] = { function() M.telescope 'TODODONE' end, 'TodoTelescope TODODONE', mode = { 'n', 'v', }, silent = true, },
  ['<leader>t<leader><leader>h'] = { function() M.telescope 'HACKDONE' end, 'TodoTelescope HACKDONE', mode = { 'n', 'v', }, silent = true, },
  ['<leader>t<leader><leader>w'] = { function() M.telescope 'WARNDONE' end, 'TodoTelescope WARNDONE', mode = { 'n', 'v', }, silent = true, },
  ['<leader>t<leader><leader>p'] = { function() M.telescope 'PERFDONE' end, 'TodoTelescope PERFDONE', mode = { 'n', 'v', }, silent = true, },
  ['<leader>t<leader><leader>n'] = { function() M.telescope 'NOTEDONE' end, 'TodoTelescope NOTEDONE', mode = { 'n', 'v', }, silent = true, },
  ['<leader>t<leader><leader>t'] = { function() M.telescope 'TESTDONE' end, 'TodoTelescope TESTDONE', mode = { 'n', 'v', }, silent = true, },
  ['<leader>tq'] = { name = 'TodoQuickFix', },
  ['<leader>tqf'] = { function() M.quickfix 'FIX' end, 'TodoQuickFix  FIX', mode = { 'n', 'v', }, silent = true, },
  ['<leader>tqd'] = { function() M.quickfix 'TODO' end, 'TodoQuickFix TODO', mode = { 'n', 'v', }, silent = true, },
  ['<leader>tqh'] = { function() M.quickfix 'HACK' end, 'TodoQuickFix HACK', mode = { 'n', 'v', }, silent = true, },
  ['<leader>tqw'] = { function() M.quickfix 'WARN' end, 'TodoQuickFix WARN', mode = { 'n', 'v', }, silent = true, },
  ['<leader>tqp'] = { function() M.quickfix 'PERF' end, 'TodoQuickFix PERF', mode = { 'n', 'v', }, silent = true, },
  ['<leader>tqn'] = { function() M.quickfix 'NOTE' end, 'TodoQuickFix NOTE', mode = { 'n', 'v', }, silent = true, },
  ['<leader>tqt'] = { function() M.quickfix 'TEST' end, 'TodoQuickFix TEST', mode = { 'n', 'v', }, silent = true, },
  ['<leader>tq<leader>'] = { name = 'TodoQuickfix DONE', },
  ['<leader>tq<leader>f'] = { function() M.quickfix 'FIXDONE' end, 'TodoQuickfix  FIXDONE', mode = { 'n', 'v', }, silent = true, },
  ['<leader>tq<leader>d'] = { function() M.quickfix 'TODODONE' end, 'TodoQuickfix TODODONE', mode = { 'n', 'v', }, silent = true, },
  ['<leader>tq<leader>h'] = { function() M.quickfix 'HACKDONE' end, 'TodoQuickfix HACKDONE', mode = { 'n', 'v', }, silent = true, },
  ['<leader>tq<leader>w'] = { function() M.quickfix 'WARNDONE' end, 'TodoQuickfix WARNDONE', mode = { 'n', 'v', }, silent = true, },
  ['<leader>tq<leader>p'] = { function() M.quickfix 'PERFDONE' end, 'TodoQuickfix PERFDONE', mode = { 'n', 'v', }, silent = true, },
  ['<leader>tq<leader>n'] = { function() M.quickfix 'NOTEDONE' end, 'TodoQuickfix NOTEDONE', mode = { 'n', 'v', }, silent = true, },
  ['<leader>tq<leader>t'] = { function() M.quickfix 'TESTDONE' end, 'TodoQuickfix TESTDONE', mode = { 'n', 'v', }, silent = true, },
}

return M
