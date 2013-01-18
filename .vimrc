"" Use Vim settings, rather then Vi settings (much better!).
"" This must be first, because it changes other options as a side effect.
set nocompatible

"" UI settings
set esckeys " Allow cursor keys in insert mode
set wildmenu " Enhance command-line completion
set history=200		" keep X lines of command line history
set ttyfast " Optimize for fast terminal connections
set encoding=utf-8 nobomb " Use UTF-8 without BOM
let mapleader="," " Change mapleader
set ruler
set incsearch
set hlsearch "highlight search terms
set number
set ignorecase
set smartcase
set binary " Don’t add empty newlines at the end of files
set noeol
set nostartofline " Show the cursor position
set laststatus=2 " Always show status line
set shortmess=atI " Don’t show the intro message when starting vim
set showmode " Show the current mode
set title " Show the filename in the window titlebar
set showcmd " Show the (partial) command as it’s being typed
"set colorcolumn=80
"highlight ColorColumn ctermbg=8
"highlight ColorColumn guibg=Black
highlight OverLength ctermbg=darkgrey guibg=darkgrey
match OverLength /\%>80v.\+/

" setup backup settings
set backupdir=~/.vim/backups
set directory=~/.vim/swaps
if exists("&undodir")
	set undodir=~/.vim/undo
endif
set backup

"" set filetype check on
:filetype plugin indent on

" encodings configure
set fileencoding=utf-8
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,gb2312,cp936
set sessionoptions+=unix,slash

" indentation related settings
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set backspace=indent,eol,start
set autoindent
set smartindent

" setting about old window resizing behavior when open a new window
set winfixheight
" not let all windows keep the same height/width
set noequalalways

" syntax highlighting settings
syntax on 
set t_Co=256 " 256 colors
set background=dark 
"set cursorline " Highlight current line
set lcs=tab:▸\ ,trail:·,nbsp:_ " Show “invisible” characters
set list
if filereadable(expand("$HOME/.vim/colors/peaksea.vim"))
  colorscheme peaksea
end

" some macros to execute script in ruby
nmap ;e :w<CR>:exe ":!ruby " . getreg("%") . "" <CR>
nmap ;c :w<CR>:exe ":!ruby -c " . getreg("%") . "" <CR>
nmap ,o o<Esc>

"folding settings
"za = toggle fold on this scope
"zM = fold all
"zR = unfold all
"#zo = unfold # scopes down
"#zc = fold # scopes up

set foldmethod=syntax   "fold based on syntax. Alt method: "indent"
set foldnestmax=20      "deepest fold is 20 levels
set nofoldenable        "dont fold by default
set foldlevel=1         "this is just what i use
highlight Folded ctermbg=black ctermfg=darkgrey

if has("folding")
  function! UnfoldCur()
    if !&foldenable
      return
    endif
    let cl = line(".")
    if cl <= 1
      return
    endif
    let cf  = foldlevel(cl)
    let uf  = foldlevel(cl - 1)
    let min = (cf > uf ? uf : cf)
    if min
      execute "normal!" min . "zo"
      return 1
    endif
  endfunction
endif

function! ResCur()
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction

augroup resCur
  autocmd!
  if has("folding")
    autocmd BufWinEnter * if ResCur() | call UnfoldCur() | endif
  else
    autocmd BufWinEnter * call ResCur()
  endif
augroup END

" Strip trailing whitespace (,ss)
function! StripWhitespace()
	let save_cursor = getpos(".")
	let old_query = getreg('/')
	:%s/\s\+$//e
	call setpos('.', save_cursor)
	call setreg('/', old_query)
endfunction
noremap <leader>ss :call StripWhitespace()<CR>
" Save a file as root (,W)
noremap <leader>W :w !sudo tee % > /dev/null<CR>
noremap <leader>n :set nonumber!<CR>
noremap <leader>c I#<Esc><Esc>


" Automatic commands
if has("autocmd")
	" Enable file type detection
	filetype on
	" Treat .json files as .js
	autocmd BufNewFile,BufRead *.json setfiletype json syntax=javascript
endif

" Syntax for Vagrantfile
au BufRead,BufNewFile Vagrantfile setfiletype ruby
au BufRead,BufNewFile Berksfile setfiletype ruby
au BufRead,BufNewFile Berksfile.lock setfiletype ruby
