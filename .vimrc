" Skip setup if started as evim
if v:progname =~? "evim"
    finish
endif

" Standard Vim Settings

" General
set backspace=indent,eol,start  " Enable backspacing over indents, line breaks, and start
set history=500                 " Keep 500 lines of command history
set ruler                      " Show cursor position
set showcmd                    " Show incomplete commands
set incsearch                  " Enable incremental search
set ignorecase                 " Ignore case in searches
set magic                      " Enable regex magic mode
set nobackup                   " Disable backup files
set nowritebackup
set noundofile
set nomodeline                 " Disable modelines for security
set cm=zip                     " Use zip encryption
set showmatch                  " Show matching brackets
set mat=2
set mps+=<:>                   " Include angle brackets in match pairs
" Disabled due to unwanted comment highlighting
" set spell
" set spelllang=en

" Syntax and Filetype
if &t_Co > 2 || has("gui_running")
    syntax on                  " Enable syntax highlighting
    set hlsearch               " Highlight search results
    let c_comment_strings=1    " Highlight strings in C comments
endif
if has("autocmd")
    filetype plugin indent on  " Enable file type detection and language-specific indentation
    augroup vimrcEx
        au!
        autocmd BufReadPost *
            \ if line("'\"") > 1 && line("'\"") <= line("$") |
            \   exe "normal! g`\"" |
            \ endif
    augroup END
else
    set autoindent             " Enable autoindenting
endif
set tabstop=4                  " Configure indentation
set shiftwidth=4
set softtabstop=4
set expandtab
set smarttab
set autoindent
set smartindent
set list                       " Show tabs as >-
set listchars=tab:>-

" Appearance
highlight Comment ctermfg=8     " Configure colors
highlight LineNr ctermfg=grey
hi TabLineFill cterm=none ctermfg=grey ctermbg=cyan
hi TabLine     cterm=none ctermfg=white ctermbg=cyan
hi TabLineSel  cterm=none ctermfg=black ctermbg=white
hi StatusLine ctermbg=black ctermfg=darkgrey
set cursorline
set laststatus=2
set guitablabel=%N/\ %t\ %M

" Key Mappings
map Q gq                       " Map Q to format text instead of Ex mode
inoremap <C-U> <C-G>u<C-U>     " Break undo before CTRL-U in insert mode
nmap <F1> :set invnumber<CR>
nmap <F2> :set invrelativenumber<CR>
nmap <F5> :tabprevious<CR>
nmap <F6> :tabnext<CR>
nmap <F7> :tabnew<CR>
set pastetoggle=<F4>           " Toggle paste mode
nnoremap <C-h> :call ToggleFKeys()<CR>  " Toggle F-key status line

" File Handling
if !exists(":DiffOrig")
    command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
        \ | wincmd p | diffthis
endif
if has('langmap') && exists('+langnoremap')
    set langnoremap            " Prevent langmap from affecting mappings
endif
packadd matchit                " Enable matchit plugin for enhanced % navigation
let g:LargeFile = 1024 * 1024 * 10  " Optimize large files (>10MB)
augroup LargeFile
    autocmd!
    autocmd BufReadPre * let f = expand("<afile>") | if getfsize(f) > g:LargeFile | call s:LargeFile() | endif
augroup END
function! s:LargeFile()
    setlocal syntax=off        " Disable syntax highlighting
    setlocal noswapfile        " Disable swapfile
    setlocal bufhidden=unload  " Unload buffer when hidden
    setlocal undolevels=-1     " Disable undo
    setlocal buftype=nowrite   " Make buffer read-only
    autocmd VimEnter * echo "Large file detected (> " . (g:LargeFile / 1024 / 1024) . " MB). Performance options applied."
endfunction

" Buffer Write Handling
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction
function! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun
function! HandlePasteBeforeWrite()
    let s:was_paste = &paste
    if s:was_paste
        set nopaste
    endif
    return s:was_paste
endfunction
function! RestorePasteAfterWrite(was_paste)
    if a:was_paste
        set paste
    endif
endfunction
augroup BufWritePreSettings
    autocmd!
    autocmd BufWritePre * let s:was_paste = HandlePasteBeforeWrite()
    autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()
    autocmd BufWritePre * :%retab!
    autocmd BufWritePost * call RestorePasteAfterWrite(s:was_paste)
augroup END

" Menus
set wildmenu
set wcm=<Tab>
" Encoding menu
command! -nargs=+ SetEnc execute 'e ++enc=<args>'
menu Encoding.koi8-r        :SetEnc koi8-r ++ff=unix<CR>
menu Encoding.windows-1251  :SetEnc cp1251 ++ff=dos<CR>
menu Encoding.cp866         :SetEnc cp866 ++ff=dos<CR>
menu Encoding.utf-8         :SetEnc utf-8<CR>
menu Encoding.koi8-u        :SetEnc koi8-u ++ff=unix<CR>
map <F8> :emenu Encoding.<TAB>
" Vim-plug menu
menu Plug.Status   :PlugStatus<CR>
menu Plug.Install  :PlugInstall<CR>
menu Plug.Update   :PlugUpdate<CR>
menu Plug.Clean    :PlugClean!<CR>
menu Plug.Purge    :PlugPurge<CR>
menu Plug.Upgrade  :PlugUpgrade<CR>
nnoremap <F10> :emenu Plug.<TAB>

" Plugin Settings
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

function! PlugPurge()
    if !isdirectory(expand('~/.vim/plugged'))
        echom "No plugins directory found at ~/.vim/plugged"
        return
    endif
    if confirm("Purge all vim-plug plugins? This will delete all plugin files in ~/.vim/plugged.", "&Yes\n&No") == 1
        call system('rm -rf ~/.vim/plugged/*')
        echom "All vim-plug plugins have been purged"
    else
        echom "Purge cancelled"
    endif
endfunction

command! PlugPurge call PlugPurge()

call plug#begin('~/.vim/plugged')
Plug 'itchyny/lightline.vim'       " Lightweight status line
Plug 'preservim/nerdtree'         " File explorer
Plug 'tpope/vim-sensible'         " Sensible defaults
Plug 'tpope/vim-surround'         " Surround text with pairs
Plug 'tpope/vim-commentary'       " Comment/uncomment lines
Plug 'tpope/vim-repeat'           " Enhance repeat command
Plug 'Joorem/vim-haproxy'         " HAProxy syntax highlighting
Plug 'chr4/nginx.vim'             " Nginx syntax highlighting
call plug#end()

" Initialize F-key status line visibility
let g:show_fkeys = 0

function! ToggleFKeys()
    let g:show_fkeys = !g:show_fkeys
    if has_key(g:plugs, 'lightline.vim') && isdirectory(g:plugs['lightline.vim'].dir)
        call lightline#update()
    endif
endfunction

if has_key(g:plugs, 'lightline.vim') && isdirectory(g:plugs['lightline.vim'].dir)
    function! LightlineFKeys()
        if g:show_fkeys
            return 'F1:Num F2:RelNum F3:Comment F4:Paste F5:TabPrev F6:TabNext F7:TabNew F8:Enc F10:Plug F11:Expl F12:Expl'
        endif
        return ''
    endfunction
    let g:lightline = {
      \ 'component_function': {
      \   'filename': 'LightlineFilename',
      \   'fkeys': 'LightlineFKeys'
      \ },
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'filename', 'modified' ] ],
      \   'right': [ [ 'fkeys' ], [ 'lineinfo' ], [ 'fileencoding', 'filetype' ] ]
      \ }
      \ }
    function! LightlineFilename()
        let l:full_path = expand('%:p')
        let l:cwd = getcwd()
        if l:full_path !~# '^' . l:cwd
            let l:max_len = 50
            if len(l:full_path) > l:max_len
                let l:parts = split(l:full_path, '/')
                if len(l:parts) > 3
                    let l:short_parts = l:parts[0:1] + map(l:parts[2:-2], 'v:val[0]')
                    let l:short_parts += [l:parts[-1]]
                    let l:short_path = join(l:short_parts, '/')
                    if len(l:short_path) > l:max_len
                        return '...' . l:short_path[-l:max_len:]
                    endif
                    return l:short_path
                endif
            endif
            return l:full_path
        endif
        return expand('%')
    endfunction
else
    function! LinePercent()
        return line('.') * 100 / line('$') . '%'
    endfunction
    function! StatuslineFKeys()
        if g:show_fkeys
            return ' F1:Num F2:RelNum F3:Comment F4:Paste F5:TabPrev F6:TabNext F7:TabNew F8:Enc F10:Plug F11:Expl F12:Expl'
        endif
        return ''
    endfunction
    set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c\ [%{LinePercent()}%h]%{StatuslineFKeys()}
endif

if has_key(g:plugs, 'nerdtree') && isdirectory(g:plugs['nerdtree'].dir) && exists(':NERDTreeToggle')
    let g:loaded_netrw=1
    let g:loaded_netrwPlugin=1
    let g:NERDTreeHijackNetrw=0
    nmap <F11> :sp +NERDTree<CR>
    nmap <F12> :NERDTree<CR>
    " Disabled for testing
    " nnoremap <C-n> :NERDTreeToggle<CR>
    " nnoremap <C-f> :NERDTreeFind<CR>
    autocmd StdinReadPre * let s:std_in=1
    autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif
else
    let g:netrw_liststyle=3
    nmap <F11> :sp +Explore<CR>
    nmap <F12> :Explore<CR>
endif

if has_key(g:plugs, 'vim-commentary') && isdirectory(g:plugs['vim-commentary'].dir)
    nmap <F3> gcc              " Comment/uncomment current line
    vmap <F3> gc               " Comment/uncomment selected block
endif

if has_key(g:plugs, 'vim-haproxy') && isdirectory(g:plugs['vim-haproxy'].dir)
    autocmd BufRead,BufNewFile haproxy*.cfg setfiletype haproxy
endif

if has_key(g:plugs, 'nginx.vim') && isdirectory(g:plugs['nginx.vim'].dir)
    autocmd BufRead,BufNewFile nginx.conf,*/nginx/*,*/nginx.conf.d/* setfiletype nginx
endif

" Load local settings
if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif

