" Load Pathogen
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

" Remap Ctrl-j to: Save All; Return to normal mode
imap <silent> <C-j> <Esc>:wa<CR>
nmap <silent> <C-j> <Esc>:wa<CR>

" Don't need vi compatability mode
set nocompatible

" Use hidden buffers for argdo goodness
set hidden

" Set the path
set path=.,,**

" Edit or load .vimrc
nmap <silent> <leader>ev :tabe $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

" re-indent the whole file, remove unnecessary whitespace
map <leader>i :call<SID>ReformatAndClean()<CR>

" Replace all instances of the word under the cursor
nnoremap <Leader>s :%s/\V\<<C-r><C-w>\>/

" Load matchit
runtime macros/matchit.vim

" no goofy buttons
set guioptions=ac
:color blackboard  
set history=10000

" Better tab settings
set sts=2
set smarttab
set shiftwidth=2
set autoindent
set expandtab

set backspace=start,eol,indent

" Highlights matches when searching
set incsearch

" Automatically read and write files as needed
set autoread
set autowrite

" With these options together, we only use case sensitive search when there is a captial letter in the search term
set ignorecase
set smartcase

filetype on
filetype plugin on
filetype indent on

syntax on
syntax sync fromstart

set lazyredraw

" completion on the command line
set wildmenu
set wildmode=list:longest

" numbered lines
set number

" Prevents searched terms from remaining highlighted once search is done
set nohlsearch

" word wrapping
set wrap
set linebreak

" no beeps
set visualbell

" Ignore directories that have crap in them
set wildignore+=tmp,target,*.pyc,*.class

" My Favorite font
set guifont=Inconsolata:h18.00

" central backup directores
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

" Disable F1 help
:nmap <F1> :echo<CR>
:imap <F1> <C-o>:echo<CR>

" Add more info in status line
set statusline=%F%m%r%h%w\ [Line=%03l,Col=%03v][%p%%]\ [Type=%y]\ %{fugitive#statusline()}
set laststatus=2

" vimClojure config
let vimclojure#HighlightBuiltins=1 
let vimclojure#ParenRainbow=1

" map %% to expand to the current file's directory
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" Remap omni-completion to CTRL+Space
nmap <C-space> ea<C-n>
imap <C-space> <C-n>

" Shortcut to touch all files in a project
noremap <C-s> :!find src test -exec touch {} \;<CR><CR>

" Use * to search for the current selection in visual mode
xnoremap * :<C-u>call <SID>VSetSearch()<CR>/<C-R>=@/<CR><CR>
function! s:VSetSearch()
  let temp = @s
  norm! gv"sy
  let @/ = '\V' . substitute(escape(@s, '/\'), '\n', '\\n', 'g')
  let @s = temp
endfunction

" Define Qargs command to load quickfix results into args
command! -nargs=0 -bar Qargs execute 'args' QuickfixFilenames()
function! QuickfixFilenames()
  let buffer_numbers = {}
  for quickfix_item in getqflist()
    let buffer_numbers[quickfix_item['bufnr']] = bufname(quickfix_item['bufnr'])
  endfor
  return join(map(values(buffer_numbers), 'fnameescape(v:val)'))
endfunction

" Treat eco files as HTML
" This shouldn't be here...but not sure where it goes
au BufRead,BufNewFile *html.eco set filetype=html

function! <SID>ReformatAndClean()
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")

  "Replace tabs with spaces
  :1,$retab 
  "Removing Trailing whitespace
  %s/\s\+$//e 
  "Reindent the file
  :normal gg=G 

  " Clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)  
endfunction

