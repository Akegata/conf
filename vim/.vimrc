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

" NERDTree config
nnoremap <C-o> :NERDTreeToggle<CR>
"nnoremap <C-l> :NERDTreeFocus<CR>
let NERDTreeShowHidden=1
" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
" Close the tab if NERDTree is the only window remaining in it.
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endi

" Automatically install vim-plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
    silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
      autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs),'!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

call plug#begin()
  Plug 'https://github.com/rodjek/vim-puppet.git'
  Plug 'tpope/vim-sensible'
  Plug 'embark-theme/vim', { 'as': 'embark' }
  Plug 'itchyny/lightline.vim'
  Plug 'sheerun/vim-polyglot'
  Plug 'preservim/nerdtree'
  Plug 'ryanoasis/vim-devicons'
call plug#end()

" Load the embark colorscheme only if it's installed
if filereadable(expand("~/.vim/plugged/embark/colors/embark.vim"))
    colorscheme embark
endif
