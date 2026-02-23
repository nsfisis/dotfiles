local is_deno_repo = vim.fs.root(0, { 'deno.json', 'deno.jsonc' }) ~= nil

local servers = { 'gopls', 'phpactor', 'zls', 'efm' }
if is_deno_repo then
   table.insert(servers, 'denols')
else
   table.insert(servers, 'ts_ls')
end

vim.lsp.enable(servers)

vim.api.nvim_create_autocmd('LspAttach', {
   group = vim.api.nvim_create_augroup('UserLspConfig', {}),
   callback = function(e)
      local client = assert(vim.lsp.get_client_by_id(e.data.client_id))

      if client:supports_method('textDocument/completion') then
         vim.lsp.completion.enable(true, client.id, e.buf, { autotrigger = true })
      end

      if client:supports_method('textDocument/formatting') then
         vim.keymap.set('n', '<space>f', function()
            vim.lsp.buf.format({
               bufnr = e.buf,
               id = client.id,
               async = true,
               filter = function(client) return client.name ~= "ts_ls" end,
            })
         end, { buffer = e.buf })

         if not client:supports_method('textDocument/willSaveWaitUntil') then
            vim.api.nvim_create_autocmd('BufWritePre', {
               group = vim.api.nvim_create_augroup('UserLspConfig', { clear = false }),
               buffer = e.buf,
               callback = function()
                  vim.lsp.buf.format({
                     bufnr = e.buf,
                     id = client.id,
                     timeout_ms = 5000,
                     filter = function(client) return client.name ~= "ts_ls" end,
                  })
               end
            })
         end
      end
   end,
})
