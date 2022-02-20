-- lua require('tests').test(TEST_SUITE_NAME)

local M = {}


local T = {}

function T.new(suite_name)
   local instance = {}
   instance.suite_name = suite_name
   instance._index = 1
   setmetatable(instance, {__index = T})
   return instance
end

function T:assert(expr, message)
   assert(expr, ('[tests.%s:%d] %s'):format(self.suite_name, self._index, message))
   self._index = self._index + 1
end

function T:assert_eq(expected, actual, message)
   message = message or (tostring(expected) .. ' != ' .. tostring(actual))
   assert(expected == actual, ('[tests.%s:%d] %s'):format(self.suite_name, self._index, message))
   self._index = self._index + 1
end


function M.test(suite_name)
   assert(suite_name, '[tests.test] suite_name is required.')

   local suite = require('tests.' .. suite_name)
   suite.test(T.new(suite_name))
end


return M
