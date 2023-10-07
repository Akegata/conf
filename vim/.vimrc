" Add Pathogen to handle plugins:
" mkdir -p ~/.vim/autoload ~/.vim/bundle && curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

execute pathogen#infect()
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
