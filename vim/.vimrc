syntax on
filetype plugin indent on
set background=dark
set statusline+=%F
set laststatus=2
set hlsearch
set ruler
set shiftwidth=2
set softtabstop=2
set expandtab
set autoindent
set incsearch
set wildmenu
set wildmode=longest:full,full
set termguicolors
" Set encoding for vim-devicons compatibility
set encoding=UTF-8
set term=xterm-256color

" NERDTree config
nnoremap <C-o> :NERDTreeFocus<CR>
nnoremap <C-l> :NERDTreeToggle<CR>
"noremap <C-p> <NOP>
nnoremap <C-p> :NERDTreeFind<CR>
let NERDTreeShowHidden=1
" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
" Close the tab if NERDTree is the only window remaining in it.
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endi
let NERDTreeMouseMode=2
let g:NERDTreeMinimalUI = 1
let g:NERDTreeWinLeaveWidth = 1
set fillchars+=vert:\ "White space at the end

augroup MouseInNERDTreeOnly
    autocmd!
    autocmd BufEnter NERD_tree_* set mouse=a
    autocmd BufLeave NERD_tree_* set mouse=
augroup END
set mouse=

" Automatically install vim-plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
    silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
      autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif

call plug#begin()
  Plug 'https://github.com/rodjek/vim-puppet.git'
  Plug 'tpope/vim-sensible'
  Plug 'embark-theme/vim', { 'as': 'embark' }
  Plug 'catppuccin/vim', { 'as': 'catppuccin' }  
  Plug 'itchyny/lightline.vim'
  Plug 'sheerun/vim-polyglot'
  Plug 'preservim/nerdtree'
  Plug 'ryanoasis/vim-devicons'
  Plug 'tpope/vim-obsession'
call plug#end()

" Load the embark colorscheme only if it's installed
if filereadable(expand("~/.vim/plugged/catppuccin/colors/catppuccin_mocha.vim"))
    colorscheme catppuccin_mocha
endif

" Run PlugInstall if there are missing plugins
"autocmd VimEnter * if len(filter(values(g:plugs),'!isdirectory(v:val.dir)'))
"  \| PlugInstall --sync | source $MYVIMRC
"\| endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
