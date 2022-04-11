vimrc.after_ftplugin('php', function(conf)
   -- If a buffer is empty, insert a template and position the
   -- cursor at the end of the buffer.
   --
   -- Example:
   -- <?php
   --
   -- declare(strict_types=1);
   --
   -- [cursor]
   if vim.fn.line('$') == 1 and vim.fn.getline(1) == '' then
      vim.fn.setline(1, { '<?php', '', 'declare(strict_types=1);', '', '' })
      vim.fn.cursor(6, 0)
   end
end)
