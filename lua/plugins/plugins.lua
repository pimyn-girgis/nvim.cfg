return {
  {
    'numToStr/Comment.nvim',
    opts = {
      -- change commentstring for C/CPP to only use `//`
      commentstring = '// %s',
    },
    keys = {
      { 'gcc' }, { 'gbc' }
    },
  }
}
