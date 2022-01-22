set nocompatible
set number " Show line numbers
set relativenumber "show de the relative line number 
set mouse=a
set clipboard=unnamedplus
set noswapfile

" TextEdit might fail if hidden is not set.
set hidden

" transparent bg
autocmd vimenter * hi Normal guibg=NONE ctermbg=NONE
" For Vim<8, replace EndOfBuffer by NonText
autocmd vimenter * hi EndOfBuffer guibg=NONE ctermbg=NONE

set showmatch               " show matching brackets.
set ignorecase              " case insensitive matching
set hlsearch                " highlight search results
set tabstop=2               " number of columns occupied by a tab character
set softtabstop=2           " see multiple spaces as tabstops so <BS> does the right thing
set expandtab               " converts tabs to white space
set shiftwidth=2            " width for autoindents
set autoindent              " indent a new line the same amount as the line just typed
set smartindent             " smart indednt 
set wildmode=longest,list   " get bash-like tab completions
filetype plugin indent on   " allows auto-indenting depending on file type
syntax on                   " syntax highlighting

set encoding=UTF-8

set wildignore+=*node_modules/**

nmap <Leader>o :CocCommand tsserver.organizeImports<CR>

nmap <Leader>fa :CocCommand tsserver.findAllFileReferences<CR>


call plug#begin('~/.vim/plugged')
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'

  Plug 'embear/vim-localvimrc'

  Plug 'wakatime/vim-wakatime'

  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  
  Plug 'rafi/awesome-vim-colorschemes'

  Plug 'vim-airline/vim-airline'

  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }

  Plug 'junegunn/fzf.vim'

  Plug 'tpope/vim-fugitive'
  
  Plug 'airblade/vim-gitgutter'

  Plug 'scrooloose/nerdtree'

  Plug 'xuyuanp/nerdtree-git-plugin'

  Plug 'majutsushi/tagbar'

  Plug 'dense-analysis/ale'

  Plug 'puremourning/vimspector'

  Plug 'honza/vim-snippets'

  Plug 'yggdroot/indentline'

  Plug 'jreybert/vimagit'

  Plug 'ludovicchabant/vim-gutentags'

  Plug 'preservim/nerdcommenter'

  Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }

  Plug 'kkoomen/vim-doge', { 'do': { -> doge#install() } }

  Plug 'ryanoasis/vim-devicons'

  Plug 'zivyangll/git-blame.vim'

  Plug 'morhetz/gruvbox'

call plug#end()

nnoremap <leader>sv :source $MYVIMRC<CR>

" js file imports
let g:js_file_import_sort_after_insert = 1

" VIMSPECTOR configs
let g:vimspector_enable_mappings = 'VISUAL_STUDIO'

" Theme
syntax enable
colorscheme gruvbox
set background=dark
set t_Co=256

" set cursorline
set cursorline
hi CursorLine term=bold cterm=bold guibg=Grey40
hi LineNr ctermfg=grey 

" system remaps
vnoremap <C-c> "+y
map <C-d> "+p

"vim git-blame 
nnoremap <Leader>s :<C-u>call gitblame#echo()<CR>

"fzf configs
"remap
nnoremap <C-p> :Files<CR>
nnoremap <C-f> :call fzf#run(fzf#wrap({'source': 'git ls-files --exclude-standard --others --cached'}))<CR>
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>h :History<CR>

" airline configs
let g:airline_powerline_fonts = 1
let g:airline#extensions#whitespace#enabled = 0
let g:airline_solarized_bg='dark'

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = '▓▒░'
let g:airline_right_sep = '░▒▓'
let g:airline_symbols.crypt = '🔒'
let g:airline_symbols.maxlinenr = '☰'
let g:airline_symbols.branch = '🌱'
let g:airline_theme = 'tender'

"command! FD call fzf#run(fzf#wrap({'source': 'git ls-files --exclude-standard --others --cached'}))
"
"NERDTree configs
"remap
map <C-n> :NERDTreeToggle<CR>

let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
let g:NERDTreeGitStatusUseNerdFonts = 1
let g:NERDTreeGitStatusConcealBrackets = 1 " default: 0
let NERDTreeCustomOpenArgs={'file':{'where': 't'}}
let NERDTreeShowHidden = 1

"GitGutter configs
let g:gitgutter_sign_added = '⊞'
let g:gitgutter_sign_modified = '🤔'
let g:gitgutter_sign_removed = '⊟'
let g:gitgutter_git_executable = '/usr/bin/git'
let g:gitgutter_use_location_list = 1

" ALE configs
let g:ale_sign_error = '❌'
let g:ale_sign_warning = '⚠️'

"TagBar configs
nmap <F8> :TagbarToggle<CR>

" Vimspector configs
let g:vimspector_enable_mappings = 'VISUAL_STUDIO'
let g:vimspector_base_dir='$HOME/.vim/configs/vimspector'

" Navigate bewtween tabs
" Go to tab by number
noremap <leader>1 1gt
noremap <leader>2 2gt
noremap <leader>3 3gt
noremap <leader>4 4gt
noremap <leader>5 5gt
noremap <leader>6 6gt
noremap <leader>7 7gt
noremap <leader>8 8gt
noremap <leader>9 9gt
noremap <leader>0 :tablast<cr>

" localvimrc configs
let g:localvimrc_enable = 1
" whitelist all local vimrc files in users project 
let g:localvimrc_whitelist='$HOME/code/.*'

" CocConfigs
" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" add node relativepath so coc-nvim would work
let g:coc_node_path = '/home/rodrigo/.nvm/versions/node/v14.18.1/bin/node'

" Run jest for current project
command! -nargs=0 Jest :call  CocAction('runCommand', 'jest.projectTest')

" Run jest for current file
command! -nargs=0 JestCurrent :call  CocAction('runCommand', 'jest.fileTest', ['%'])

" Run jest for current test
nnoremap <leader>jrc :call CocAction('runCommand', 'jest.fileTest')<CR>
nnoremap <leader>jrt :call CocAction('runCommand', 'jest.singleTest')<CR>

" Init jest in current cwd, require global jest command exists
command! JestInit :call CocAction('runCommand', 'jest.init')

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

" indentLine configs
let g:indentLine_char_list = ['|', '¦', '┆', '┊']

" YAML filetype config
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

if &term =~ '^screen'
  " tmux will send xterm-style keys when its xterm-keys option is on
  execute "set <xUp>=\e[1;*A"
  execute "set <xDown>=\e[1;*B"
  execute "set <xRight>=\e[1;*C"
  execute "set <xLeft>=\e[1;*D"
endif

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <TAB>
  \ pumvisible() ? coc#_select_confirm() :
  \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ coc#refresh()

let g:coc_snippet_next = '<tab>'



