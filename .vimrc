set ci

" === Tabs and Indentation (and Autoindentation)
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
"     F3: Toggle Autoindentation for the sake of pasting raw lines
set pastetoggle=<F3>


nmap \l :setlocal number!<CR>
nmap \o :set paste!<CR>

set incsearch
set ignorecase
set smartcase
set hlsearch
nmap \q :nohlsearch<CR>

syntax on
filetype plugin indent on


" ====== Syntastic ======
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_aggregate_errors = 1
let g:syntastic_php_checkers = ['php', 'phpcs', 'phpmd']
let g:syntastic_python_checkers = ['pylint3', 'flake8']


