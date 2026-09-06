return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        eslint = {
          settings = {
            run = "onSave",
          },
        },
      },
    },
  },
}
