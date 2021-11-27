vimrc.after_ftplugin('php', function(conf)
   conf.indent(conf.SPACE, 2)

   -- If a buffer is empty, insert `<?php` tag and 2 blank lines, and position the
   -- cursor at the end of the buffer (line 3, column 0).
   --
   -- Example:
   -- <?php
   --
   -- [cursor]
   if vim.fn.line('$') == 1 and vim.fn.getline(1) == '' then
      vim.fn.setline(1, { '<?php', '', '' })
      vim.fn.cursor(3, 0)
   end
end)
