" Add Pathogen to handle plugins:
" mkdir -p ~/.vim/autoload ~/.vim/bundle && curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
" cd ~/.vim/bundle && \
" git clone https://github.com/tpope/vim-sensible.git && \
" git clone https://github.com/rodjek/vim-puppet.git

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
