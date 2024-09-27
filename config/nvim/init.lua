local opt = vim.opt
opt.cursorline = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.cursorcolumn = true
opt.number = true
opt.relativenumber = true
opt.backup = false
opt.hlsearch = true
opt.scrolloff = 10
opt.smartcase = true
opt.smartindent = true
opt.softtabstop = 2
opt.wildmenu = true
opt.writebackup = false
opt.clipboard = 'unnamedplus'
opt.wrap = false

-- Keymaps
local set = vim.keymap.set
vim.g.mapleader = " "

--for naviagting in split windows
set('i', 'jj', '<Esc>')
set('n', '<c-h>', '<c-w>h')
set('n', '<c-j>', '<c-w>j')
set('n', '<c-k>', '<c-w>k')
set('n', '<c-l>', '<c-w>l')

--for splitting the window
set('n', '<leader>v', '<c-w>v')
set('n', '<leader>s', '<c-w>s')
set('n', '<leader>c', '<c-w>c')
set('n', '<leader>o', '<c-w>o')

--clear search highlight
set('n', '<leader>\\', ':nohlsearch<CR>')

--Sexplore, explore, and Vexplore
set("n", "<leader>pv", vim.cmd.Vex)

-- Lualine
require("lualine").setup({
	options = {
  	  icons_enabled = true,
  	  theme = 'gruvbox',
  	  component_separators = { left = '', right = ''},
  	  section_separators = { left = '', right = ''},
  	  disabled_filetypes = {
  	    statusline = {},
  	    winbar = {},
  	  },
  	  ignore_focus = {},
  	  always_divide_middle = true,
  	  globalstatus = false,
  	  refresh = {
  	    statusline = 1000,
  	    tabline = 1000,
  	    winbar = 1000,
  	  }
  	},
  	sections = {
  	  lualine_a = {'mode'},
  	  lualine_b = {'branch', 'diff', 'diagnostics'},
  	  lualine_c = {'filename'},
  	  lualine_x = {'encoding', 'fileformat', 'filetype'},
  	  lualine_y = {'progress'},
  	  lualine_z = {'location'}
  	},
  	inactive_sections = {
  	  lualine_a = {},
  	  lualine_b = {},
  	  lualine_c = {'filename'},
  	  lualine_x = {'location'},
  	  lualine_y = {},
  	  lualine_z = {}
  	},
  	tabline = {},
  	winbar = {},
  	inactive_winbar = {},
  	extensions = {}
})

-- Colorscheme

-- Comment
require("Comment").setup()

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true

require("nvim-tree").setup()

require("nvim-surround").setup({})
local on_attach = function(_, bufnr)

  local bufmap = function(keys, func)
    vim.keymap.set('n', keys, func, { buffer = bufnr })
  end

  bufmap('<leader>r', vim.lsp.buf.rename)
  bufmap('<leader>a', vim.lsp.buf.code_action)

  bufmap('gd', vim.lsp.buf.definition)
  bufmap('gD', vim.lsp.buf.declaration)
  bufmap('gI', vim.lsp.buf.implementation)
  bufmap('<leader>D', vim.lsp.buf.type_definition)

  bufmap('gr', require('telescope.builtin').lsp_references)
  bufmap('<leader>s', require('telescope.builtin').lsp_document_symbols)
  bufmap('<leader>S', require('telescope.builtin').lsp_dynamic_workspace_symbols)

  bufmap('K', vim.lsp.buf.hover)

  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, {})
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

require('neodev').setup()
require('lspconfig').lua_ls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
	root_dir = function()
        return vim.loop.cwd()
    end,
	cmd = { "lua-lsp" },
    settings = {
        Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
        },
    }
}

require('lspconfig').nil_ls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
}
require('lspconfig').ts_ls.setup({})

require("Comment").setup()
vim.o.background = "dark"
-- Default options:
require("gruvbox").setup({
  terminal_colors = true, -- add neovim terminal colors
  undercurl = true,
  underline = true,
  bold = true,
  italic = {
    strings = true,
    emphasis = true,
    comments = true,
    operators = false,
    folds = true,
  },
  strikethrough = true,
  invert_selection = false,
  invert_signs = false,
  invert_tabline = false,
  invert_intend_guides = false,
  inverse = true, -- invert background for search, diffs, statuslines and errors
  contrast = "hard", -- can be "hard", "soft" or empty string
  palette_overrides = {},
  overrides = {},
  dim_inactive = false,
  transparent_mode = false,
  overrides = {
    SignColumn = {bg = "#ff9900"},
    ["@lsp.type.method"] = { bg = "#ff9900" },
    ["@comment.lua"] = { bg = "#000000" }
  }
})

vim.cmd.colorscheme "gruvbox"

local cmp = require('cmp')
local luasnip = require('luasnip')

require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
  -- css colors integration with nvim-cmp
  formatting = {
    format = function(entry, item)
      local color_item = require("nvim-highlight-colors").format(entry, { kind = item.kind })
      item = require("lspkind").cmp_format({
        -- any lspkind format settings here
      })(entry, item)
      if color_item.abbr_hl_group then
        item.kind_hl_group = color_item.abbr_hl_group
        item.kind = color_item.abbr
      end
      return item
    end
  }
}

require('telescope').setup({
  defaults = {
    mappings = {
      i = {
        ["<C-h>"] = "which_key"
      }
    }
  },

	extensions = {
    	fzf = {
      	fuzzy = true,                    -- false will only do exact matching
      	override_generic_sorter = true,  -- override the generic sorter
      	override_file_sorter = true,     -- override the file sorter
      	case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    	}
  	}
})

require('telescope').load_extension('fzf')

--Telescopic keybinds
local builtin = require('telescope.builtin')
local keys = vim.keymap.set
keys('n', '<leader>ff', builtin.find_files, {})
keys('n', '<leader>fg', builtin.live_grep, {})
keys('n', '<leader>fb', builtin.buffers, {})
keys('n', '<leader>fh', builtin.help_tags, {})

--Search within a git repo
keys('n', '<C-p>', builtin.git_files, {})

require("ibl").setup()
require('nvim-treesitter.configs').setup {
    auto_install = false,

    highlight = { enable = true },

    indent = { enable = true },
}

vim.opt.termguicolors = true;

require("nvim-highlight-colors").setup {
	---Render style
	---@usage 'background'|'foreground'|'virtual'
	render = 'background',

	---Set virtual symbol (requires render to be set to 'virtual')
	virtual_symbol = '■',

	---Set virtual symbol suffix (defaults to '')
	virtual_symbol_prefix = '',

	---Set virtual symbol suffix (defaults to ' ')
	virtual_symbol_suffix = ' ',

	---Set virtual symbol position()
 	---@usage 'inline'|'eol'|'eow'
 	---inline mimics VS Code style
 	---eol stands for `end of column` - Recommended to set `virtual_symbol_suffix = ''` when used.
 	---eow stands for `end of word` - Recommended to set `virtual_symbol_prefix = ' ' and virtual_symbol_suffix = ''` when used.
	virtual_symbol_position = 'inline',

	---Highlight hex colors, e.g. '#FFFFFF'
	enable_hex = true,

    	---Highlight short hex colors e.g. '#fff'
	enable_short_hex = true,

	---Highlight rgb colors, e.g. 'rgb(0 0 0)'
	enable_rgb = true,

	---Highlight hsl colors, e.g. 'hsl(150deg 30% 40%)'
	enable_hsl = true,

	---Highlight CSS variables, e.g. 'var(--testing-color)'
	enable_var_usage = true,

	---Highlight named colors, e.g. 'green'
	enable_named_colors = true,

	---Highlight tailwind colors, e.g. 'bg-blue-500'
	enable_tailwind = false,

	---Set custom colors
	---Label must be properly escaped with '%' to adhere to `string.gmatch`
	--- :help string.gmatch
	custom_colors = {
		{ label = '%-%-theme%-primary%-color', color = '#0f1219' },
		{ label = '%-%-theme%-secondary%-color', color = '#5a5d64' },
	},

  -- Exclude filetypes or buftypes from highlighting e.g. 'exclude_buftypes = {'text'}'
  exclude_filetypes = {},
  exclude_buftypes = {}
}

local lspkind = require('lspkind')
cmp.setup {
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol', -- show only symbol annotations
      maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                     -- can also be a function to dynamically calculate max width such as 
                     -- maxwidth = function() return math.floor(0.45 * vim.o.columns) end,
      ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
      show_labelDetails = true, -- show labelDetails in menu. Disabled by default

      -- The function below will be called before any actual modifications from lspkind
      -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
      before = function (entry, vim_item)
        return vim_item
      end
    })
  }
}

local async = require ("plenary.async")
require("toggleterm").setup()