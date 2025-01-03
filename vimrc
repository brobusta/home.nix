"{{{ basic settings
set nocompatible
set encoding=utf-8

filetype indent plugin on
syntax on

set mouse=a
set hidden
set wildmenu
set wildmode=longest:full,full
set wildoptions=pum
set list
set listchars=tab:▸\ ,trail:·
set showcmd
set incsearch
set hlsearch
set ignorecase
set smartcase
set backspace=indent,eol,start
set autoindent
set nostartofline
set noerrorbells visualbell t_vb=
set number
set relativenumber

set shiftwidth=2
set softtabstop=2
set expandtab
set scrolloff=8
set splitright
set splitbelow

set clipboard=unnamedplus
set foldmethod=marker
set signcolumn=yes

" workaround for vim-devicons
let &t_ut=''
set t_RV=
set ttymouse=xterm2

nnoremap <space> <nop>
let mapleader=" "

let g:airline#extensions#ale#enabled = 1
let g:ale_set_highlights = 0
let g:ale_completion_enabled = 0
let g:ale_sign_error = '✗'
let g:ale_sign_warning = '⚡ '

let g:rustfmt_autosave = 1
let g:ale_fix_on_save = 1
let g:ale_floating_preview = 1
let g:ale_floating_window_border = repeat([''], 8)

" To fix ugly lsp hover text
let g:polyglot_disabled = ['markdown']
"}}}

"{{{ colorscheme
set termguicolors
colorscheme tokyonight-night
set background=dark
"}}}

"{{{ vim-airline
let g:airline_theme='base16_classic'
let g:airline_powerline_fonts = 1
let g:airline_skip_empty_sections = 1
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'
" airline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
"}}}

"{{{ key mappings
" Quicker window movement
nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k
nnoremap <leader>h <C-w>h
nnoremap <leader>l <C-w>l
nnoremap <leader>wf :w!<cr>
nnoremap <leader>q :bd<cr>
nnoremap <leader>wq :wq<cr>
" Vertical and horizontal splits
nnoremap <leader>vs <C-w>v
nnoremap <leader>xs <C-w>S
nnoremap <silent> <leader>+ :vertical resize +5<cr>
nnoremap <silent> <leader>- :vertical resize -5<cr>
nnoremap <S-l> :bnext<cr>
nnoremap <S-h> :bprevious<cr>
nnoremap <leader>u :bprevious<cr>
tnoremap <leader><esc> <C-\><C-n>
" Keep it centered
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z
vnoremap < <gv
vnoremap > >gv
vnoremap p "_dP
vnoremap y myy`y
vnoremap Y myY`y
nnoremap Y y$
nnoremap <leader>xo :!xdg-open %<cr><cr>
nnoremap <C-a> <esc>ggVG
imap jk <esc>
imap ;; <esc>A;<esc>
nmap <silent> gf :edit <cfile><cr>
nnoremap <leader>ef :NERDTreeToggle %<cr>
nnoremap <leader>f :Files<cr>
nnoremap <leader>b :Buffers<cr>
nnoremap <leader>l :BLines<cr>
nnoremap <leader>rg :Rg<cr>
nnoremap <leader>gb :GBranches<cr>
nmap <F2> :Maps<cr>
cnoremap w!! w !sudo tee > /dev/null %

" vim-lsp
function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete

  if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
  nmap <buffer> gd <plug>(lsp-definition)
  nmap <buffer> gs <plug>(lsp-document-symbol-search)
  nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
  nmap <buffer> gr <plug>(lsp-references)
  nmap <buffer> gi <plug>(lsp-implementation)
  nmap <buffer> <leader>gt <plug>(lsp-type-definition)
  nmap <buffer> <leader>rn <plug>(lsp-rename)
  nmap <buffer> <leader>ca <plug>(lsp-code-action-float)
  nmap <buffer> [g <plug>(ale_previous_wrap)
  nmap <buffer> ]g <plug>(ale_next_wrap)
  nmap <buffer> K <plug>(lsp-hover)
  nnoremap <buffer> <expr><c-d> lsp#scroll(+4)
  nnoremap <buffer> <expr><c-u> lsp#scroll(-4)

  let g:lsp_format_sync_timeout = 1000
  autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')
endfunction

augroup lsp_install
  au!
  " call s:on_lsp_buffer_enabled only for languages that has the server registered.
  au User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" asyncomplete
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"
imap <c-@> <plug>(asyncomplete_force_refresh)

" snippet
imap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
smap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'

" editor
nnoremap <leader>wf :w!<cr>
nnoremap <leader>Q :qa!<cr>
vnoremap <C-r> "hy:%s,<C-r>h,,g<left><left>
"}}}
