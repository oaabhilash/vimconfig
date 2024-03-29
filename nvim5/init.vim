" find a solution
inoremap jj <Esc>
inoremap jJ <Esc>
syntax on
set number
" Ignoring any previous mapping for space
nnoremap <SPACE> <Nop>
" making space as the leader
let mapleader=" "
set colorcolumn=120
" remapping ctrl w to <Leader> w
nnoremap <Leader>w <C-w>
" adding mapping for opening current split in a new tab
" We are actually opening a tab to simulate the expand
nnoremap <Leader>we :tab split<CR>
" based on neovim faq
set termguicolors
" opens the nvim config file
nnoremap <leader>vm :vsp $MYVIMRC<CR>
" Horizontal scrolling
set sidescroll=1
set nowrap           " do not automatically wrap on load
set formatoptions-=t " do not automatically wrap text when typing

"signcolumn on the left
set signcolumn=yes

" setting splitting behavior so that it alway splits right and below
set splitbelow
set splitright

" copy and paste (Ctrl v works from visual mode)
vmap <C-c> "+yi
vmap <C-x> "+c
"imap <C-v> <ESC>"+pa
" use ctrl+Q for visual mode vertical selection 

cnoreabbrev ws silent write
" based on the recomendation from webpack to enable hot reload
set backupcopy=yes


call plug#begin(stdpath('data').'/plugged')
	Plug 'gruvbox-community/gruvbox'
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'
	Plug 'tpope/vim-fugitive'
	Plug 'easymotion/vim-easymotion'
	Plug 'blueyed/vim-diminactive'
    Plug 'lambdalisue/fern.vim'
    Plug 'lambdalisue/fern-hijack.vim'
    Plug 'neovim/nvim-lspconfig'
    Plug 'nvim-lua/popup.nvim'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'kyazdani42/nvim-web-devicons'
    Plug 'folke/trouble.nvim'
    Plug 'terrortylor/nvim-comment'
    Plug 'alvan/vim-closetag'
    Plug 'mhartington/formatter.nvim'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/nvim-cmp'
    Plug 'hrsh7th/cmp-vsnip'
    Plug 'hrsh7th/vim-vsnip'
    Plug 'tversteeg/registers.nvim', { 'branch': 'main' }
    Plug 'voldikss/vim-floaterm'
call plug#end()

filetype indent off

"---------------------------------------------------------------
" gruvbox color scheme
" ---------------------------------------------------------------
autocmd vimenter * colorscheme gruvbox
set background=dark " gruvbox config. setting it to dark

"----------------------------------------------------------------
" Float Terminal
"----------------------------------------------------------------
let g:floaterm_keymap_toggle = '<leader>t'
"-------------------------------------------------------------------
" easymotion configuration
"--------------------------------------------------------------------
let g:EasyMotion_do_mapping = 0 " Disable default mappings
map <Leader> <Plug>(easymotion-prefix)

" Jump to anywhere you want with minimal keystrokes, with just one key binding.
" `s{char}{label}`
nmap s <Plug>(easymotion-overwin-f)
" or
" `s{char}{char}{label}`
" Need one more keystroke, but on average, it may be more comfortable.
nmap s <Plug>(easymotion-overwin-f2)

" Turn on case-insensitive feature
let g:EasyMotion_smartcase = 1

" JK motions: Line motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
"-----------------------------------------------------------
" Fern mappings
"-----------------------------------------------------------
noremap <silent> <Leader>d :Fern . -reveal=%:p<CR>
noremap <silent> <Leader>. :Fern %:h <CR>

function! s:init_fern() abort
  nmap <buffer> yy <Plug>(fern-action-yank:path)
  nmap <buffer> d <Plug>(fern-action-hidden:toggle)
endfunction

augroup fern-custom
  autocmd! *
  autocmd FileType fern call s:init_fern()
augroup END

" vim indent settings
set tabstop=4
set expandtab
set shiftwidth=4
set autoindent
set smartindent

"----------------------------------------------------------------
" VIM Airline config suggested by vim-devicons
"----------------------------------------------------------------
"let g:airline_powerline_fonts = 1
"let g:airline_theme='powerlineish'
let g:airline#extensions#tabline#enabled = 0
" remove the filetype part
let g:airline_section_x=''
let g:airline_section_y=''
let g:airline_section_z=''
" remove separators for empty sections
let g:airline_skip_empty_sections = 1

"-----------------------------------------------------------
" nvim-comment config
" ------------------------------------------
lua << EOF
require('nvim_comment').setup()
EOF
"----------------------------------------------------------------
" Close Tag configuration
"-----------------------------------------------------------------
" filenames like *.xml, *.html, *.xhtml, ...
" These are the file extensions where this plugin is enabled.
"
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.tsx'

" filenames like *.xml, *.xhtml, ...
" This will make the list of non-closing tags self-closing in the specified files.
"
let g:closetag_xhtml_filenames = '*.xhtml,*.jsx,*.tsx'

" filetypes like xml, html, xhtml, ...
" These are the file types where this plugin is enabled.
"
let g:closetag_filetypes = 'html,xhtml,phtml,tsx,jsx'

" filetypes like xml, xhtml, ...
" This will make the list of non-closing tags self-closing in the specified files.
"
let g:closetag_xhtml_filetypes = 'xhtml,jsx,tsx'

" integer value [0|1]
" This will make the list of non-closing tags case-sensitive (e.g. `<Link>` will be closed while `<link>` won't.)
"
let g:closetag_emptyTags_caseSensitive = 1

" dict
" Disables auto-close if not in a "valid" region (based on filetype)
"
let g:closetag_regions = {
    \ 'typescript.tsx': 'jsxRegion,tsxRegion',
    \ 'javascript.jsx': 'jsxRegion',
    \ 'typescriptreact': 'jsxRegion,tsxRegion',
    \ 'javascriptreact': 'jsxRegion',
    \ }

" Shortcut for closing tags, default is '>'
let g:closetag_shortcut = '>'
" to add > without doing a close tag do leader >
let g:closetag_close_shortcut = '<ctrl>>'
" -----------------------------------------------------------
" Telescope mappings
" ----------------------------------------------------------
" Find files using Telescope command-line sugar.
nnoremap <leader>fd <cmd>Telescope find_files<cr>
" Same command without previewer
nnoremap <leader><leader> <cmd>lua require('telescope.builtin').find_files { previewer = false}<cr>

" Search for string in the current working direcotry
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
" Search for string under your curseor
nnoremap <leader>fc <cmd>Telescope grep_string<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <Leader>r <cmd>lua require'telescope.builtin'.registers{}<CR>
command Ag Telescope live_grep

"-----------------------------------------------------------------------
" LSP trouble configuration
"----------------------------------------------------------------------
lua << EOF
  -- Default bindings for trouble can be viewed at https://github.com/folke/trouble.nvim
  -- Telescope integration with trouble. Press Ctrl+t to move telescope results to trouble
  local actions = require("telescope.actions")
  local trouble = require("trouble.providers.telescope")
  local telescope = require("telescope")
  telescope.setup {
   defaults = {
    mappings = {
      i = { ["<c-t>"] = trouble.open_with_trouble },
      n = { ["<c-t>"] = trouble.open_with_trouble },
    },
  },
}
EOF
nnoremap <leader>xx <cmd>TroubleToggle<cr>
nnoremap <leader>xw <cmd>TroubleToggle lsp_workspace_diagnostics<cr>
nnoremap <leader>xd <cmd>TroubleToggle lsp_document_diagnostics<cr>
nnoremap <leader>xq <cmd>TroubleToggle quickfix<cr>
nnoremap <leader>xl <cmd>TroubleToggle loclist<cr>
"-----------------------------------------------------------------
" LSP Configuration - Type script
" For new langs, makes sure add the name to the kebinding config
"----------------------------------------------------------------
lua << EOF
require'lspconfig'.tsserver.setup{
        flags = {
          debounce_text_changes = 150,
        }
    }
EOF

"-----------------------------------------------------------------
" LSP Key bindings
" ----------------------------------------------------------------
"  WARNING : Based on the docs this was supposed to be added after the
"  language server is loaded. But there is seems to be a bug
"  So I am mapping it directly for now. Need to update this once that bug is
"  fiexed
nnoremap gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap gD <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap gi <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap gr <cmd>lua vim.lsp.buf.references()<CR>
nnoremap K <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <leader>D <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <leader>a <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <leader>e <cmd>lua vim.diagnostic.open_float()<CR>
nnoremap <leader>rn <cmd>lua vim.lsp.buf.rename()<CR>
"-----------------------------------------------------------------------
" nvim.cmp configuration
"----------------------------------------------------------------------

set completeopt=menu,menuone,noselect

lua <<EOF
  -- Setup nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      expand = function(args)
        -- For `vsnip` user.
        vim.fn["vsnip#anonymous"](args.body)
      end,
    },
    mapping = {
     ['<C-j>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
     ['<C-k>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
     ['<Down>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
     ['<Up>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
     ['<C-d>'] = cmp.mapping.scroll_docs(-4),
     ['<C-f>'] = cmp.mapping.scroll_docs(4),
     ['<C-Space>'] = cmp.mapping.complete(),
     ['<C-e>'] = cmp.mapping.close(),
     ['<CR>'] = cmp.mapping.confirm({
    behavior = cmp.ConfirmBehavior.Replace,
    select = true,
  })
    },
    sources = {
      { name = 'nvim_lsp' },
      -- For vsnip user.
      { name = 'vsnip' },
      -- { name = 'buffer' },
    }
  })
  
    -- Setup lspconfig.
  require('lspconfig')["tsserver"].setup {
    capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  }

EOF

"----------------------------------------------------------------------
" Formatter.vim configuration
" ---------------------------------------------------------------------
lua << EOF
require("formatter").setup(
  {
    logging = true,
    filetype = {
      typescriptreact = {
        -- prettier
        function()
          return {
            exe = "prettier",
            args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0), "--print-width 120"},
            stdin = true
          }
        end
      },
      typescript = {
        -- prettier
        function()
          return {
            exe = "prettier",
            args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0), "--print-width 120"},
            stdin = true
          }
        end
      },
      javascript = {
        -- prettier
        function()
          return {
            exe = "prettier",
            args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0), "--print-width 120"},
            stdin = true
          }
        end
      },
      javascriptreact = {
        -- prettier
        function()
          return {
            exe = "prettier",
            args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0), "--print-width 120"},
            stdin = true
          }
        end
      },
      json = {
        -- prettier
        function()
          return {
            exe = "prettier",
            args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0), "--print-width 120"},
            stdin = true
          }
        end
      },
    }
  }
)
EOF
nnoremap <silent> <leader>f :Format<CR>


