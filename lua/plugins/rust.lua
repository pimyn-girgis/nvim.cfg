return {
  'mrcjkb/rustaceanvim',
  version = '^5', -- Recommended
  ft = 'rust',
  config = function()
    vim.g.rustaceanvim = {
      server = {
        on_attach = function(_, bufnr)
          On_attach(_, bufnr)
          local rmap = function(keys, func, desc)
            if desc then
              desc = 'LSP: ' .. desc
            end
            vim.keymap.set('n', keys, function()
              vim.cmd.RustLsp(func)
            end, { buffer = bufnr, desc = desc })
          end
          rmap('<leader>rd', { 'debug' }, '[R]ust [D]ebug')
          rmap('<leader>re', { 'explainError' }, '[R]ust [E]rror')
          rmap('<leader>rr', { 'run' }, '[R]ust [R]un')
          rmap('<leader>ro', { 'openDocs' }, '[R]ust [O]pen Docs')
          rmap('<leader>rj', { 'joinLines' }, '[R]ust [J]oin lines')
          rmap('<leader>rh', { 'view', 'hir' }, '[R]ust [H]IR')
          rmap('<leader>rm', { 'view', 'mir' }, '[R]ust [M]IR')
          rmap('<leader>rsd', { 'renderDiagnostic' }, '[R]ust [S]how [D]iagnostic')
        end,
        capabilities = Capabilities,
      },
    }
  end
}
