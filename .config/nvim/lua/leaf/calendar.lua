local M = {}


local floor = math.floor


M.MON = 1
M.TUE = 2
M.WED = 3
M.THU = 4
M.FRI = 5
M.SAT = 6
M.SUN = 7


function M.calc_week_of_day(y, m, d)
   -- Zeller's congruence
   if m == 1 or m == 2 then
      m = m + 12
      y = y - 1
   end
   local C = floor(y / 100)
   local Y = y % 100
   local G = 5*C + floor(C/4)
   return 1 + (d + floor(26 * (m+1) / 10) + Y + floor(Y/4) + G + 5) % 7
end


function M.translate_week_of_day(w, locale)
   -- assert(locale == 'ja_JP')
   return ({
      [M.MON] = '月',
      [M.TUE] = '火',
      [M.WED] = '水',
      [M.THU] = '木',
      [M.FRI] = '金',
      [M.SAT] = '土',
      [M.SUN] = '日',
   })[w]
end


return M
