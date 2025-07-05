local M = {}

local uniquify = require('uniquify').uniquify


function M.test(t)
   local test_cases = {
      -- expected, this_path, other_paths
      {'foo.txt',         'foo.txt',             {}},
      {'foo.txt',         'bar/foo.txt',         {}},
      {'foo.txt',         'foo.txt',             {'foo.txt'}},
      {'foo.txt',         'bar/foo.txt',         {'bar/foo.txt'}},
      {'foo.txt',         'bar/foo.txt',         {'bar/foo.txt', 'bar/foo.txt'}},
      {'bar/foo.txt',     'bar/foo.txt',         {'foo.txt'}},
      {'bar/foo.txt',     'bar/foo.txt',         {'baz/foo.txt'}},
      {'bar/foo.txt',     'qux/bar/foo.txt',     {'baz/foo.txt'}},
      {'foo.txt',         'bar/foo.txt',         {'bar.txt', 'baz.txt'}},
      {'foo.txt',         'bar/foo.txt',         {'bar.txt', 'baz.txt'}},
      {'baz.txt',         'foo/bar/baz.txt',     {}},
      {'foo/b/baz.txt',   'foo/bar/baz.txt',     {'qux/bar/baz.txt'}},
      {'foo/b/baz.txt',   'foo/bar/baz.txt',     {'fiz/foo/bar/baz.txt', 'qux/bar/baz.txt'}},
      {'fiz/f/b/baz.txt', 'fiz/foo/bar/baz.txt', {'foo/bar/baz.txt'}},
      {'foo.txt',         'bar/foo.txt',         {'bar/foo.txt'}},
      {'bar/foo.txt',     'fiz/bar/foo.txt',     {'bar/baz.txt', 'qux/foo.txt'}},
   }

   for _, row in ipairs(test_cases) do
      local expected = row[1]
      local this_path = row[2]
      local other_paths = row[3]
      t:assert_eq(expected, uniquify(this_path, other_paths))
   end
end


return M
