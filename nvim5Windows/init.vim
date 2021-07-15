" TODO :: investigate the use of nvim snippet
" TODO :: compe tab based completion has a bug. Can we use another package or
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
nnoremap <Leader>we :tabedit % <CR>
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
imap <C-v> <ESC>"+pa

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
    Plug 'glepnir/lspsaga.nvim'
    Plug 'kyazdani42/nvim-web-devicons'
    Plug 'folke/trouble.nvim'
    Plug 'terrortylor/nvim-comment'
    Plug 'alvan/vim-closetag'
    Plug 'nvim-lua/completion-nvim'
    Plug 'cohama/lexima.vim' " auto pair () {} etc
    Plug 'mhartington/formatter.nvim'
call plug#end()


"---------------------------------------------------------------
" gruvbox color scheme
" ---------------------------------------------------------------
autocmd vimenter * colorscheme gruvbox
set background=dark " gruvbox config. setting it to dark


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
noremap <silent> <Leader>d :Fern . -reveal=% <CR>
noremap <silent> <Leader>. :Fern %:h <CR>

function! s:init_fern() abort
  nmap <buffer> yy <Plug>(fern-action-yank:path)
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
    \ }

" Shortcut for closing tags, default is '>'
let g:closetag_shortcut = '>'
" -----------------------------------------------------------
" Telescope mappings
" ----------------------------------------------------------
" Find files using Telescope command-line sugar.
nnoremap <leader><leader> <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

command Ag Telescope live_grep 

"---------------------------------------------------------------
" LSP Saga Configuration
"----------------------------------------------------------------
lua << EOF
    local saga = require 'lspsaga'
    saga.init_lsp_saga()
EOF
" overriding the gr command from regular lsp ... This may be bit slow.. but
" let us test this
" nnoremap <silent> gr <cmd>lua require'lspsaga.provider'.lsp_finder()<CR>
" overriding the code_action from native lsp
nnoremap <silent><leader>a <cmd>lua require('lspsaga.codeaction').code_action()<CR>
vnoremap <silent><leader>a :<C-U>lua require('lspsaga.codeaction').range_code_action()<CR>
" This is the only new feature from lsp saga... If perf is an issure remove
" others
nnoremap <silent> <leader>t <cmd>lua require('lspsaga.floaterm').open_float_terminal()<CR> powershell<CR>
tnoremap <silent> <leader>t <C-\><C-n>:lua require('lspsaga.floaterm').close_float_terminal()<CR>
" Hoverdoc
nnoremap <silent> K <cmd>lua require('lspsaga.hover').render_hover_doc()<CR>
" rename
nnoremap <leader>rn <cmd>lua require('lspsaga.rename').rename()<CR>
"-----------------------------------------------------------------------
" LSP trouble configuration
"----------------------------------------------------------------------
lua << EOF
  require("trouble").setup {
    position = "bottom", -- position of the list can be: bottom, top, left, right
    height = 10, -- height of the trouble list when position is top or bottom
    width = 50, -- width of the list when position is left or right
    icons = true, -- use devicons for filenames
    mode = "lsp_workspace_diagnostics", -- "lsp_workspace_diagnostics", "lsp_document_diagnostics", "quickfix", "lsp_references", "loclist"
    fold_open = "", -- icon used for open folds
    fold_closed = "", -- icon used for closed folds
    action_keys = { -- key mappings for actions in the trouble list
        -- map to {} to remove a mapping, for example:
        -- close = {},
        close = "q", -- close the list
        cancel = "<esc>", -- cancel the preview and get back to your last window / buffer / cursor
        refresh = "r", -- manually refresh
        jump = {"<cr>", "<tab>"}, -- jump to the diagnostic or open / close folds
        open_split = { "<c-x>" }, -- open buffer in new split
        open_vsplit = { "<c-v>" }, -- open buffer in new vsplit
        open_tab = { "<c-t>" }, -- open buffer in new tab
        jump_close = {"o"}, -- jump to the diagnostic and close the list
        toggle_mode = "m", -- toggle between "workspace" and "document" diagnostics mode
        toggle_preview = "P", -- toggle auto_preview
        hover = "K", -- opens a small poup with the full multiline message
        preview = "p", -- preview the diagnostic location
        close_folds = {"zM", "zm"}, -- close all folds
        open_folds = {"zR", "zr"}, -- open all folds
        toggle_fold = {"zA", "za"}, -- toggle fold of current file
        previous = "k", -- preview item
        next = "j" -- next item
    },
    indent_lines = true, -- add an indent guide below the fold icons
    auto_open = false, -- automatically open the list when you have diagnostics
    auto_close = false, -- automatically close the list when you have no diagnostics
    auto_preview = true, -- automatyically preview the location of the diagnostic. <esc> to close preview and go back to last window
    auto_fold = false, -- automatically fold a file trouble list at creation
    signs = {
        -- icons / text used for a diagnostic
        error = "",
        warning = "",
        hint = "",
        information = "",
        other = "﫠"
    },
    use_lsp_diagnostic_signs = false -- enabling this will use the signs defined in your lsp client
  }
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
require'lspconfig'.tsserver.setup{}
EOF

"-----------------------------------------------------------------
" LSP Key bindings
" ----------------------------------------------------------------
lua << EOF
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys 
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  -- buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  --buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  -- buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  -- buf_set_keymap('n', '<space>a', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  -- buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
-- Need to add new languge servers to this list fore the key bindings to work
local servers = { "tsserver" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup { on_attach = on_attach }
end
EOF
"-------------------------------------------------------------------
" completion.nvim configuration
"-------------------------------------------------------------------
autocmd BufEnter * lua require'completion'.on_attach()
" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

" Avoid showing message extra message when using completion
set shortmess+=c

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
