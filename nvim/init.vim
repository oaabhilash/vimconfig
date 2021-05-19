" TODO healthcheck and fix the ers
" TODO cocinstll -> tsserver, prettier, python
" IMPORTANT NOTE -> Avoid insert mode mappings for leader key.
" Do npm install -g neovim // This is required for fzf-preveiw
" Do CocInstall coc-fzf-preview
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
	Plug 'tomasiser/vim-code-dark'
	Plug 'morhetz/gruvbox'
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'
	Plug 'neoclide/coc.nvim', {'branch': 'release'}
	Plug 'tpope/vim-fugitive'
	Plug 'sheerun/vim-polyglot'
	Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
	Plug 'junegunn/fzf.vim'
	Plug 'airblade/vim-rooter'
    Plug 'yuki-ycino/fzf-preview.vim', { 'branch': 'release/remote', 'do': ':UpdateRemotePlugins' }
	Plug 'ntpeters/vim-better-whitespace'
	Plug 'alvan/vim-closetag'
	Plug 'nathanaelkane/vim-indent-guides'
	Plug 'RRethy/vim-illuminate'
    Plug 'voldikss/vim-floaterm'
	Plug 'luochen1990/rainbow'
	Plug 'easymotion/vim-easymotion'
	Plug 'blueyed/vim-diminactive'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-commentary'
    Plug 'antoinemadec/FixCursorHold.nvim'
    Plug 'lambdalisue/fern.vim'
    Plug 'lambdalisue/fern-hijack.vim'
call plug#end()
"---------------------------------------------------------------
"Fixing neovim cursorhold bug
"..............................................................
let g:cursorhold_updatetime = 100

"-------------------------------------------------------------
" Quick Scope configuration
" ------------------------------------------------------------
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
augroup qs_colors
  autocmd!
  autocmd ColorScheme * highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline
  autocmd ColorScheme * highlight QuickScopeSecondary guifg='#5fffff' gui=underline ctermfg=81 cterm=underline
augroup END

"---------------------------------------------------------------
" gruvbox color scheme
" ---------------------------------------------------------------
autocmd vimenter * colorscheme gruvbox
set background=dark " gruvbox config. setting it to dark
" using vs code color scheme
" colorscheme codedark


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
"--------------------------------------------------------------------
" Enable rainbow brackets . (Also disabling for nerdtree)
"---------------------------------------------------------------------
let g:rainbow_active = 1
let g:rainbow_conf = {
	\	'separately': {
	\		'nerdtree': 0,
	\	}
	\}

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

"---------------------------------------------------------------
" Float term key maps
"--------------------------------------------------------------
let g:floaterm_shell='powershell'
let g:floaterm_keymap_new    = '<F7>'
let g:floaterm_keymap_prev   = '<F8>'
let g:floaterm_keymap_next   = '<F9>'
let g:floaterm_keymap_toggle = '<F12>'

"----------------------------------------------------------------
" fzf-vim
"----------------------------------------------------------------
" Start ag in the specified directory
" e.g.
"   :AgIn .. foo
function! s:ag_in(bang, ...)
  if !isdirectory(a:1)
    throw 'not a valid directory: ' .. a:1
  endif
  " Press `?' to enable preview window.
  call fzf#vim#ag(join(a:000[1:], ' '), fzf#vim#with_preview({'dir': a:1}, 'up:50%:hidden', '?'), a:bang)
  " If you don't want preview option, use this
  " call fzf#vim#ag(join(a:000[1:], ' '), {'dir': a:1}, a:bang)
endfunction

command! -bang -nargs=+ -complete=dir AgIn call s:ag_in(<bang>0, <f-args>)
cnoreabbrev ag Ag
cnoreabbrev agin AgIn

"disabling preview window, as it is not working now
"let g:fzf_preview_window = []

nnoremap <silent> <leader><space> :GFiles<CR>
"This command will open the :Files fzf command assuming the path is already
"yanked. This is helpful to use along with yank path action of the fern file
"explorer
nnoremap <silent> <leader>fi :Files <C-R>"<CR>
nnoremap <silent> <leader>ag :AgIn <C-R>"<CR>

let g:fzf_action = {
  \ 'alt-i': 'split',
  \ 'alt-s': 'vsplit' }

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

" ---------------------------------------------------------------
" COC-PRETTIER CONFIGURATION. :CocInstall coc-prettier
"----------------------------------------------------------------
" :Prettier to format the current buffer
command! -nargs=0 Prettier :CocCommand prettier.formatFile
" format short cut keys
vmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

"-----------------------------------------
" Stripping whitespace on save by default
"----------------------------------------
let g:better_whitespace_enabled=1
let g:strip_whitespace_confirm=0
let g:strip_whitespace_on_save=1

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


"----------------------------------------------------------------
"Setting up Vim Indent guides <leader>ig to toggle indeent guide
"----------------------------------------------------------------
" let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level=2
let g:indent_guides_guide_size=1
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=black ctermbg=3
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=darkgrey ctermbg=4
"----------------------------------------------------------------
" COC configuration from readme
"----------------------------------------------------------------
" Adding a custom command to see all errors in the project :Tsc :copen
command! -nargs=0 Tsc :call CocAction('runCommand', 'tsserver.watchBuild')

" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
" Note coc#float#scroll works on neovim >= 0.4.3 or vim >= 8.2.0750
nnoremap <nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')
" Adding a for abbrivation for easier typing
cnoreabbrev for Format

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>


