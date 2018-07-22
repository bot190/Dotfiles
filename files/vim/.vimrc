" General
set number	                " Show line numbers
set relativenumber              " Show line numbers relative to current line
"set showbreak=+++               " Wrap-broken line prefix
set wrapmargin=0                " Disable automaticly inserting linebreaks
set showmatch	                " Highlight matching brace
syntax on                       " Enable syntax highlighting
set so=5                        " Ensure at least 5 lines remain above/below cursor
 
set hlsearch	                " Highlight all search results
set ignorecase                  " Ignore case by default
set smartcase	                " Enable smart-case search
set incsearch	                " Searches for strings incrementally

set foldlevelstart=99           " Don't start with files folded

" Indent settings
set autoindent	                " Auto-indent new lines
filetype plugin indent on       " Enable filetype based indent
set expandtab	                " Use spaces instead of tabs
set shiftwidth=4                " Number of auto-indent spaces
set smarttab	                " Enable smart-tabs
set softtabstop=4               " Number of spaces per Tab

 
"" Advanced
set ruler	                " Show row and column ruler information
set splitright                  " Split to right
set splitbelow                  " Split below
set undolevels=1000	        " Number of undo levels
set backspace=indent,eol,start	" Backspace behavior

"" netrw Settinsg
let g:netrw_sort_by="time"
let g:netrw_liststyle=1

"" Fancy Mappings

" Search for selected text, forwards or backwards.
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>


" Install plugin manager
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Plugins
Plugin 'VundleVim/Vundle.vim'

" SimpylFold 
Plugin 'tmhedberg/SimpylFold'
let g:SimpylFold_fold_import = 0

" FastFold
Plugin 'Konfekt/FastFold'

" Vim Stay
Plugin 'kopischke/vim-stay'

" Command-T
Plugin 'wincent/command-t'

" Vim-Fugitive
Plugin 'tpope/vim-fugitive'

" vim-gitgutter
Plugin 'airblade/vim-gitgutter'
set updatetime=250

" All of your Plugins must be added before the following line
call vundle#end()            " required
