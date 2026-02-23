local biome_conf = {
   rootMarkers = { 'biome.json' },
   formatCommand = 'node_modules/.bin/biome format --stdin-file-path "${INPUT}"',
   formatStdin = true,
}

return {
   cmd = { 'efm-langserver' },
   filetypes = {
      'json',
      'javascript', 'javascriptreact', 'javascript.jsx',
      'typescript', 'typescriptreact', 'typescript.jsx',
   },
   root_markers = { '.git' },
   init_options = { documentFormatting = true },
   settings = {
      languages = {
         json = {
            {
               formatCommand = 'reparojson -q',
               formatStdin = true,
            },
         },
         javascript = { biome_conf },
         javascriptreact = { biome_conf },
         ['javascript.jsx'] = { biome_conf },
         typescript = { biome_conf },
         typescriptreact = { biome_conf },
         ['typescript.jsx'] = { biome_conf },
      },
   },
}
