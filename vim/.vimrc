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
set mouse=a
set autoindent
set incsearch
set wildmenu
set wildmode=longest:full,full
set termguicolors

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
call plug#end()

colorscheme embark
