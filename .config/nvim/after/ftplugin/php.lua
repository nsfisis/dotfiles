vimrc.after_ftplugin('php', function(conf)
   -- Find "composer.json" file upward from the base directory.
   local function find_composer_json(base_dir)
      return vim.fs.find('composer.json', {
         path = base_dir,
         upward = true,
         stop = vim.loop.os_homedir(),
         type = 'file',
      })[1]
   end

   -- Read and decode JSON file.
   local function load_json(file_path)
      local ok_read, content = pcall(vim.fn.readblob, file_path)
      if not ok_read then
         return nil
      end
      local ok_decode, obj = pcall(vim.json.decode, content)
      if not ok_decode then
         return nil
      end
      return obj
   end

   -- Generate namespace declaration based on the current file name and autoload settings.
   local function generate_namespace_declaration()
      local current_dir = vim.fs.dirname(vim.api.nvim_buf_get_name(0))
      local path_to_composer_json = find_composer_json(current_dir)
      if not path_to_composer_json then
         return nil -- failed to locate composer.json
      end
      local composer_json = load_json(path_to_composer_json)
      if not composer_json then
         return nil -- failed to load composer.json
      end
      local psr4 = vim.tbl_get(composer_json, 'autoload', 'psr-4')
      if not psr4 then
         return nil -- autoload.psr-4 section is absent
      end
      if vim.tbl_count(psr4) ~= 1 then
         return nil -- psr-4 section is ambiguous
      end
      local psr4_namespace, psr4_dir
      for k, v in pairs(psr4) do
         psr4_namespace = k
         psr4_dir = v
      end
      if type(psr4_dir) == 'table' then
         if #psr4_dir == 1 then
            psr4_dir = psr4_dir[1]
         else
            return nil -- psr-4 section is ambiguous
         end
      end
      if type(psr4_namespace) ~= 'string' or type(psr4_dir) ~= 'string' then
         return nil -- psr-4 section is invalid
      end
      if psr4_namespace:sub(-1, -1) == '\\' then
         psr4_namespace = psr4_namespace:sub(0, -2)
      end
      if psr4_dir:sub(-1, -1) == '/' then
         psr4_dir = psr4_dir:sub(0, -2)
      end
      local namespace_root_dir = vim.fs.dirname(path_to_composer_json) .. '/' .. psr4_dir
      if not vim.startswith(current_dir, namespace_root_dir) then
         return nil
      end
      local current_path_suffix = current_dir:sub(#namespace_root_dir + 1)
      local namespace = psr4_namespace .. current_path_suffix:gsub('/', '\\')
      return ("namespace %s;"):format(namespace)
   end

   local function generate_template()
      local lines = {
         '<?php',
         '',
         'declare(strict_types=1);',
         '',
      }
      local namespace_decl = generate_namespace_declaration()
      if namespace_decl then
         lines[#lines + 1] = namespace_decl
         lines[#lines + 1] = ''
      end
      lines[#lines + 1] = ''
      return lines
   end

   -- If a buffer is empty, insert a template and position the
   -- cursor at the end of the buffer.
   --
   -- Example 1:
   -- <?php
   --
   -- declare(strict_types=1);
   --
   -- [cursor]
   --
   -- Example 2 with namespace declaration:
   -- <?php
   --
   -- declare(strict_types=1);
   --
   -- namespace Foo\Bar\Baz;
   --
   -- [cursor]
   if vim.fn.line('$') == 1 and vim.fn.getline(1) == '' then
      vim.fn.setline(1, generate_template())
      vim.fn.cursor('$', 0)
   end
end)
