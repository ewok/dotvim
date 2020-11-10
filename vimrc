" vim: ts=2 sts=2 sw=2
" Basic options {{{
set shell=/bin/bash
let g:mapleader = "\<Space>"
let g:maplocalleader = ","

" -> A big mess, should be reviewed {{{
set backspace=2
set clipboard=unnamedplus
set cmdheight=1
set confirm
set copyindent
set cursorline
set encoding=utf-8
set expandtab
set exrc
set fenc=utf-8 enc=utf-8
set hidden
set history=1000
set ignorecase
set laststatus=2
set linebreak
set linespace=0
set mouse=
set nobackup
set nobomb
set nocompatible
set noerrorbells
set nofoldenable
set nolist
set nostartofline
set noswapfile
set nowrap
set nowritebackup
set number
set numberwidth=4
set ruler
set scrolloff=5
set secure
set shiftwidth=4
set shortmess=aOtT
set showmode
if has('ivim')
  set showtabline=2
else
  set showtabline=1
endif
set smartcase
set smarttab
set softtabstop=4
set splitbelow
set splitright
set switchbuf=useopen
set synmaxcol=120
set tabstop=4
set timeoutlen=500
set title
set titlestring=%F
set ttimeoutlen=-1
set ttyfast

if !isdirectory($HOME . "/.vim_undo")
  call mkdir($HOME . "/.vim_undo", "p", 0700)
endif
set undolevels=100
set undodir=~/.vim_undo
set undofile

set visualbell
scriptencoding utf-8

" Mark 80-th character
highlight ColorColumn ctermbg=red
call matchadd('ColorColumn', '\%81v', 100)

filetype plugin indent on

syntax on
set hlsearch
set incsearch
syntax enable

if (has("termguicolors"))
  set termguicolors
endif

if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors

endif

set guicursor=n-v-c:block,i-ci-ve:block,r-cr:hor20,o:hor50
      \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
      \,sm:block-blinkwait175-blinkoff150-blinkon175

" Dynamic timeoutlen
au InsertEnter * set timeoutlen=1000
au InsertLeave * set timeoutlen=500

" }}}
" -> Wildmenu completion {{{
set wildmenu
set wildmode=longest,list

" ignores
set wildignore+=*.o,*.obj,*.pyc
set wildignore+=*.png,*.jpg,*.gif,*.ico
set wildignore+=*.swf,*.fla
set wildignore+=*.mp3,*.mp4,*.avi,*.mkv
set wildignore+=*.git*,*.hg*,*.svn*
set wildignore+=*sass-cache*
set wildignore+=*.DS_Store
set wildignore+=log/**
set wildignore+=tmp/**
" }}}
" -> Cursorline {{{
"
" cursorline switched while focus is switched to another split window
augroup cline
  au!
  au WinLeave,InsertEnter * set nocursorline
  au WinEnter,InsertLeave * set cursorline
augroup END
" }}}
" -> Restore cursor {{{
augroup line_return
  au!
  au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \     execute 'normal! g`"zvzz' |
        \ endif
augroup END
" }}}
" -> NeoVim settings  {{{
"
if has('nvim')
  set shada='50,<1000,s100,"10,:10,n~/.viminfo
  set inccommand=nosplit

  let g:python_host_prog = $HOME . "/share/venv/neovim2/bin/python2"
  let g:python3_host_prog = $HOME . "/share/venv/neovim3/bin/python3"

  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1

  nmap <BS> <C-h>
  tnoremap <Esc> <C-\><C-n>
endif

" }}}
" -> Dealing with largefiles  {{{
"
" Protect large files from sourcing and other overhead.
" Files become read only

let g:largefile=0

if !exists("my_auto_commands_loaded")
  let my_auto_commands_loaded = 1
  " Large files are > 10M
  " Set options:
  " eventignore+=FileType (no syntax highlighting etc
  " assumes FileType always on)
  " noswapfile (save copy of file)
  " bufhidden=unload (save memory when other file is viewed)
  " buftype=nowrite (file is read-only)
  " undolevels=-1 (no undo possible)
  "
  let g:LargeFile = 1024 * 1024 * 3
  augroup LargeFile
    au BufReadPre *
          \ let f=expand("<afile>")
          \ | if getfsize(f) > g:LargeFile
            \ | if input("Large file detected, turn off features? (y/n) ", "y") == "y"
              \ | setlocal inccommand=
              \ | setlocal eventignore+=FileType
              \ | setlocal noswapfile bufhidden=unload undolevels=-1
              \ | let b:syntastic_mode="passive"
              \ | let b:ycm_auto_trigger=0
              \ | let g:largefile=1
              \ | endif
            \ | else
              \ | setlocal eventignore-=FileType
              \ | let g:largefile=0
              \ | endif
  augroup END
endif
" }}}
" -> Number Toggle  {{{
function! NumberToggle()
  if(&relativenumber == 1)
    set nornu
  else
    set rnu
  endif
endfunction

set rnu

augroup rnu
  au!
  au InsertEnter * :set nornu
  au InsertLeave * :set rnu
augroup END
" }}}
" -> RunCmd {{{
"
function! RunCmd(cmd)
  exe "!" . a:cmd
endfunction
" }}}
" }}}

" Leader Initialisation {{{
" Define prefix dictionary
let g:lmap =  {}
let g:lmap.b = { 'name': '+Buffer' }
let g:lmap.f = { 'name': '+Find' }
let g:lmap.g = { 'name': '+Git'}
let g:lmap.l = { 'name': '+Location' }
let g:lmap.o = { 'name': '+Open'}
let g:lmap.p = { 'name': '+CtrlP'}
let g:lmap.q = { 'name': '+QFix' }
let g:lmap.r = { 'name': '+Run' }
let g:lmap.s = { 'name': '+Session-Sort' }
let g:lmap.t = { 'name': '+Tags-To-Text' }
let g:lmap.w = { 'name': '+Wiki' }
let g:lmap.z = { 'name': '+Zoom' }
" }}}

" Helpers {{{
" Idempotent packs loading
function PackAddId(packname, ...)

  if a:0 > 0
      let reload = a:1
    else
      let reload = 0
  endif

  let l:packnamenorm = substitute(a:packname, "[-.]", "_", "")

  if ! exists('g:loaded' . l:packnamenorm)

    exe 'packadd ' . a:packname
    exe 'let g:loaded' . l:packnamenorm . '= 1'

    if exists('g:debug')
      echom a:packname . ' loaded'
    endif

    if reload != 0
      exe 'e %'
    endif

  endif
endfunction

command! -nargs=* PackAdd call PackAddId(<f-args>)
" }}}

" Keymaps {{{
" Tabs {{{
" map gr gT
nnoremap <C-W>t :tabnew<CR>

" }}}
" Windows {{{

" Tmux?
if exists('$TMUX')
  nnoremap <Plug>(window_split-tmux) :!tmux split-window -v -p 20<CR><CR>
  nmap <silent><C-W>S <Plug>(window_split-tmux)

  nnoremap <Plug>(window_vsplit-tmux) :!tmux split-window -h -p 20<CR><CR>
  nmap <silent><C-W>V <Plug>(window_vsplit-tmux)

else
  if has('nvim')
    nmap <silent><C-W>S :split +terminal<CR>i
    nmap <silent><C-W>V :vsplit +terminal<CR>i
  else
    nmap <silent><C-W>S :terminal<CR>i
    nmap <silent><C-W>V :terminal<CR>i
  endif
endif

" split window resize
if bufwinnr(1)
  map <C-W><C-J> :resize +5<CR>
  map <C-W><C-K> :resize -5<CR>
  map <C-W><C-L> :vertical resize +6<CR>
  map <C-W><C-H> :vertical resize -6<CR>
  map <C-W><BS> :vertical resize -6<CR>
endif

" }}}
" Folding {{{
" Space to toggle folds.
nnoremap <silent> <leader><leader> za"{{{
nnoremap <silent> z<leader> mzzMzvzz15<c-e>`z
vnoremap <silent> <leader><leader> zf"}}}

" Make zO recursively open whatever fold we're in, even if it's partially open.
nnoremap zO zczO

" Close recursively
nnoremap zC zcV:foldc!<CR>

nnoremap <c-z> mzzMzvzz15<c-e>`z

nmap zj zjmzzMzvzz15<c-e>`z
nmap zk zkmzzMzvzz15<c-e>`z

" " }}}
" Yank {{{
nmap <expr>  MR  ':%s/\(' . @/ . '\)//g<LEFT><LEFT>'
vmap <expr>  MR  ':s/\(' . @/ . '\)//g<LEFT><LEFT>'

let uname = substitute(system('uname'),'\n','','')
if uname == 'Linux'
    if system('$PATH')=~ '/mnt/c/WINDOWS'
      if executable('win32yank.exe')
        let g:win32yank = 1
      endif
    endif
endif

if exists('g:win32yank')

  set clipboard=unnamed

  autocmd TextYankPost * call system('win32yank.exe -i --crlf', @")

  function! Paste(mode)
    let @" = system('win32yank.exe -o --lf')
    return a:mode
  endfunction

  map <expr> p Paste('p')
  map <expr> P Paste('P')

  vmap <expr> p Paste('p').'gv"'.v:register.'y`>'
  vmap <expr> P Paste('P').'gv"'.v:register.'y`>'

else

  " Replace without yanking
  vnoremap p :<C-U>let @p = @+<CR>gvp:let @+ = @p<CR>

endif
" }}}
" Some vim tunings {{{
nnoremap Y y$
nnoremap vv V

" Don't yank to default register when changing something
nnoremap c "xc
xnoremap c "xc
"
" Don't cancel visual select when shifting
xnoremap <  <gv
xnoremap >  >gv

" Keep the cursor in place while joining lines
nnoremap J mzJ`z

" [S]plit line (sister to [J]oin lines) S is covered by cc.
nnoremap S mzi<CR><ESC>`z

" Don't move cursor when searching via *
nnoremap <silent> * :let stay_star_view = winsaveview()<cr>*:call winrestview(stay_star_view)<cr>

" Keep search matches in the middle of the window.
nnoremap n nzzzv
nnoremap N Nzzzv

nnoremap H ^
nnoremap L $
" }}}
" }}}

" Filetypes {{{
" Ansible/Yaml {{{
" inst: https://github.com/pearofducks/ansible-vim filetypes opt ansible
augroup ft_ansible
  au!
  au BufNewFile,BufRead */\(playbooks\|roles\|tasks\|handlers\|defaults\|vars\)/*.\(yaml\|yml\) set filetype=yaml.ansible

  au FileType yaml.ansible call LoadAnsibleFT()
  function! LoadAnsibleFT()
    setlocal commentstring=#\ %s

    PackAdd ale

    let b:ale_ansible_ansible_lint_executable = 'ansible_custom'
    let b:ale_ansible_ansible_lint_command = '%e %t'
    let b:ale_ansible_yamllint_executable = 'yamllint_custom'
    let b:ale_linters = ['yamllint', 'ansible_custom']

    call ale#linter#Define('ansible', {
          \   'name': 'ansible_custom',
          \   'executable': function('ale_linters#ansible#ansible_lint#GetExecutable'),
          \   'command': '%e %s',
          \   'callback': 'ale_linters#ansible#ansible_lint#Handle',
          \})

    PackAdd ansible 1

    let g:ansible_template_syntaxes = { '*.rb.j2': 'ruby', '*.py.j2': 'python' }
    let g:ansible_unindent_after_newline = 1
    let g:ansible_attribute_highlight = "ob"
    let g:ansible_extra_keywords_highlight = 1
    let g:ansible_normal_keywords_highlight = 'Constant'
    let g:ansible_with_keywords_highlight = 'Constant'

  endfunction

augroup END
" }}}
" CSV {{{
" inst: https://github.com/chrisbra/csv.vim filetypes opt csv
augroup ft_csv
  au!
  au BufNewFile,BufRead *.csv set filetype=csv

  au FileType csv call LoadCSVFT()
  function! LoadCSVFT()
    PackAdd csv 1
  endfunction

augroup END
" }}}
" Yaml {{{
augroup ft_yaml
  au!

  au FileType yaml call LoadYamlFT()
  function! LoadYamlFT()

    PackAdd ale
    let b:ale_yaml_yamllint_executable = 'yamllint_custom'
    let b:ale_linters = ['yamllint']

  endfunction

augroup END
" }}}
" Config {{{
augroup ft_config
  au!
  au BufNewFile,BufRead *.conf,*.cfg,*.ini set filetype=config
  au FileType config setlocal commentstring=#\ %s
augroup END
" }}}
" GitIgnore {{{
augroup ft_git
  au!
  au BufNewFile,BufRead *.gitignore set filetype=gitignore
augroup END
" }}}
" Go {{{
" inst: https://github.com/fatih/vim-go filetypes opt vim-go
augroup ft_go
  au!

  au FileType go call LoadGoFT()
  function! LoadGoFT()

    PackAdd vim-go 1

    let g:go_highlight_functions = 1
    let g:go_highlight_methods = 1
    let g:go_highlight_structs = 1
    let g:go_highlight_interfaces = 1
    let g:go_highlight_operators = 1
    let g:go_highlight_build_constraints = 1

    " let g:go_auto_type_info = 1
    let g:go_auto_sameids = 1
    " let g:go_fmt_autosave = 0
    " let g:go_fmt_command = "goimports"

    nmap <buffer> <silent> <leader>rr :silent GoRun<CR>
    nmap <buffer> <silent> <leader>rt :GoTest<CR>
    nmap <buffer> <silent> <leader>rb :GoBuild<CR>
    nmap <buffer> <silent> <leader>rc :GoCoverageToggle<CR>

    let g:lmap.r.d = { 'name': '+Definition' }
    let g:lmap.r.d.s = 'Split'
    nmap <buffer> <Leader>rds <Plug>(go-def-split)

    let g:lmap.r.d.v = 'Vertical'
    nmap <buffer> <Leader>rdv <Plug>(go-def-vertical)

    let g:lmap.r.d.t = 'Tab'
    nmap <buffer> <Leader>rdt <Plug>(go-def-tab)
    " au FileType go nmap <buffer> K <Plug>(go-doc)

    let g:lmap.r.d.i = 'Info'
    nmap <buffer> <Leader>rdi <Plug>(go-info)

  endfunction

augroup END
" }}}
" JSON {{{
augroup ft_json
  au!
  au BufNewFile,BufRead *.json set filetype=javascript
augroup END
" }}}
" Haskell {{{
augroup ft_haskell
  au!
  au BufNewFile,BufRead *.hs,*.lhs set filetype=haskell
augroup END
" }}}
" Logstash {{{
" inst: https://github.com/robbles/logstash.vim filetypes opt logstash
augroup ft_logstash
  au!

  au FileType logstash call LoadLogstashFT()
  function! LoadLogstashFT()

    PackAdd logstash 1

    setlocal foldmethod=marker
    setlocal foldmarker={,}
    setlocal wrap

  endfunction

augroup END
" }}}
" Markdown {{{
" inst: https://github.com/shime/vim-livedown filetypes opt livedown
" inst: https://github.com/gpanders/vim-medieval filetypes opt medieval
augroup ft_markdown
  au!

  au FileType markdown call LoadMarkdownFT()
  function! LoadMarkdownFT()
    setlocal foldlevel=2
    setlocal conceallevel=2

    if !has('ivim')
      PackAdd livedown
      let g:livedown_browser = 'firefox'
      let g:livedown_port = 14545

      nmap <buffer> <silent> <leader>rr :LivedownPreview<CR>
      nmap <buffer> <silent> <leader>rt :LivedownToggle<CR>
      nmap <buffer> <silent> <leader>rk :LivedownKill<CR>

      PackAdd medieval
      let g:medieval_langs = ['python=python3', 'ruby', 'sh', 'console=bash', 'bash', 'perl']

      command! -bang -nargs=? EvalBlock call medieval#eval(<bang>0, <f-args>)
      nmap <buffer> <leader>rb "":EvalBlock<CR>

    endif

    PackAdd ale
    let b:ale_linters = ['vale', 'markdownlint']

  endfunction

augroup END
" }}}
" Mustache {{{
" inst: https://github.com/mustache/vim-mustache-handlebars.git filetypes opt mustache
augroup ft_mustache
  au!

  au FileType mustache call LoadMustacheFT()
  function! LoadMustacheFT()
    PackAdd mustache 1
    let g:mustache_abbreviations = 1
  endfunction

augroup END
" }}}
" Python {{{
" inst: https://github.com/jmcantrell/vim-virtualenv filetypes opt vim-virtualenv
" inst: https://github.com/Vimjas/vim-python-pep8-indent filetypes opt pep8-ind
" inst: https://github.com/davidhalter/jedi-vim filetypes opt jedi
augroup ft_python
  au!

  au FileType python call LoadPythonFT()
  function! LoadPythonFT()

    if !has('ivim')
      PackAdd jedi
      let g:jedi#goto_command = ""
      let g:jedi#goto_assignments_command = "gA"
      let g:jedi#goto_definitions_command = "gd"
      let g:jedi#documentation_command = "K"
      let g:jedi#usages_command = "gr"
      let g:jedi#completions_command = ""
      let g:jedi#rename_command = "<leader>rR"
      let g:jedi#completions_enabled = 0
      let g:jedi#use_splits_not_buffers = "right"
      let g:jedi#goto_stubs_command = ""

      PackAdd vim-virtualenv
      let g:virtualenv_directory = $PWD

    endif
    PackAdd pep8-ind

    setlocal foldmethod=indent
    setlocal foldlevel=0
    setlocal foldnestmax=2
    setlocal commentstring=#\ %s

    nmap <buffer> <leader>rr :w\|call RunCmd("python " . bufname("%"))<CR>
    nmap <buffer> <leader>rt :w\|call RunCmd("python -m unittest " . bufname("%"))<CR>
    nmap <buffer> <leader>rT :w\|call RunCmd("python -m unittest")<CR>
    nmap <buffer> <leader>rL :!pip install flake8 mypy pylint bandit pydocstyle pudb jedi<CR>:ALEInfo<CR>

    let g:lmap.r.b = 'Breakpoint'
    nmap <Plug>(python_breakpoint) oimport pudb; pudb.set_trace()<esc>
    nmap <silent> <buffer> <leader>rb <Plug>(python_breakpoint)

    PackAdd ale
    let b:ale_linters = ['flake8', 'mypy', 'pylint', 'bandit', 'pydocstyle']
    let b:ale_fixers = {'python': ['remove_trailing_lines', 'trim_whitespace', 'autopep8']}
    let b:ale_python_flake8_executable = 'flake8'
    let b:ale_python_flake8_options = '--ignore E501'
    let b:ale_python_flake8_use_global = 0
    let b:ale_python_mypy_executable = 'mypy'
    let b:ale_python_mypy_options = ''
    let b:ale_python_mypy_use_global = 0
    let b:ale_python_pylint_executable = 'pylint'
    let b:ale_python_pylint_options = '--disable C0301,C0111,C0103'
    let b:ale_python_pylint_use_global = 0
    let b:ale_python_bandit_executable = 'bandit'
    let b:ale_python_isort_executable = 'isort'
    let b:ale_python_pydocstyle_executable = 'pydocstyle'
    let b:ale_python_vulture_executable = 'vulture'

    PackAdd textobj-python

  endfunction

augroup END
" }}}
" Puppet {{{
" inst: https://github.com/rodjek/vim-puppet filetypes opt puppet
augroup ft_puppet
  au!

  au BufNewFile,BufRead *.pp set filetype=puppet
  au FileType puppet call LoadPuppetFT()
  function! LoadPuppetFT()

    setlocal commentstring=#\ %s

    nmap <buffer> <leader>rr :w\|call RunCmd("puppet " . bufname("%"))<CR>
    nmap <buffer> <leader>rt :w\|call RunCmd("puppet parser validate")<CR>
    nmap <buffer> <leader>rL :!gem install puppet puppet-lint r10k yaml-lint<CR>:ALEInfo<CR>

    PackAdd puppet 1
    let g:puppet_align_hashes = 0

    " let b:ale_linters = ['puppet', 'puppetlint']
  endfunction

augroup END
" }}}
" Rust {{{
" inst: https://github.com/rust-lang/rust.vim filetypes opt rust
" inst: https://github.com/racer-rust/vim-racer filetypes opt rust-racer
augroup ft_rust
  au!

  au FileType rust call LoadRustFT()
  function! LoadRustFT()

    PackAdd rust 1
    PackAdd rust-racer
    let g:racer_experimental_completer = 1

    nmap <buffer> gd <Plug>(rust-def)
    nmap <buffer> gs <Plug>(rust-def-split)
    nmap <buffer> gx <Plug>(rust-def-vertical)
    nmap <buffer> K <Plug>(rust-doc)
    nmap <buffer> <silent> <leader>rr :RustRun<CR>
    nmap <buffer> <silent> <leader>rt :RustTest<CR>
    nmap <buffer> <silent> <leader>rf :RustFmt<CR>

  endfunction

augroup END
" }}}
" TODO {{{
augroup ft_todo
  au!

  au BufRead,BufNewFile *.todo setf todo

  au FileType todo call LoadTODOFT()
  function! LoadTODOFT()

    hi TASK guifg=Yellow ctermfg=Yellow term=Bold
    syn match TASK "\s\w\{1,10}-\d\{1,6}[ :]"

    hi P1 guifg=Red ctermfg=Red term=Bold
    hi P2 guifg=LightRed ctermfg=LightRed term=Bold
    hi P3 guifg=LightYellow ctermfg=LightYellow term=Bold
    syn match P1 " !!! "
    syn match P2 " !! "
    syn match P3 " ! "

    hi DT guifg=DarkMagenta ctermfg=DarkMagenta term=Bold
    syn match DT "\d\{4}-\d\{2}-\d\{2}"

    hi H1 guifg=LightGreen ctermfg=Grey term=Bold
    hi H2 guifg=DarkGreen ctermfg=DarkGreen term=Bold
    hi H3 guifg=Magenta ctermfg=Magenta term=Bold
    syn match H1 "^[#] .*$"
    syn match H2 "^[#]\{2} .*$"
    syn match H3 "^[#]\{3} .*$"

    hi DONE guifg=Grey ctermfg=Grey term=Italic
    syn match DONE ".*\[[X]\]\s.*$"

    hi TEXT guifg=LightGrey ctermfg=LightGrey
    syn match TEXT "^\s*[-*] .*$" contains=TASK,P1,P2,P3,DONE,DT

    hi Block guifg=Black ctermbg=Black
    syn region Block start="```" end="```" contains=TEXT,DONE,H1,H2,H3
    syn region Block start="<" end=">" contains=TEXT,DONE,H1,H2,H3

  endfunction

augroup END
" }}}
" Vim {{{
augroup ft_vim
  au!

  au FileType help setlocal textwidth=78
  au BufWinEnter *.txt if &ft == 'help' | wincmd L | endif

  au FileType vim call LoadVimFT()
  function! LoadVimFT()

    let g:lmap.r.S = 'Source-line'
    setlocal foldmethod=marker keywordprg=:help
    setlocal commentstring=\"\ %s

    inoremap <c-n> <c-x><c-n>

    let g:lmap.r.r = 'Source'
    nmap <buffer> <leader>rr :source %<CR>:echon "script reloaded!"<CR>
    vnoremap <buffer> <leader>rS y:@"<CR>
    nnoremap <buffer> <leader>rS ^vg_y:execute @@<cr>:echo 'Sourced line.'<cr>

  endfunction

augroup END
" }}}
" ZSH {{{
augroup ft_zsh
  au!
  au BufNewFile,BufRead *.zsh-theme set filetype=zsh
augroup END
" }}}
" Shell {{{
augroup ft_sh
  au!

  au FileType sh call LoadShFT()
  function! LoadShFT()

    nmap <buffer> <leader>rr :w\|call RunCmd("bash " . bufname("%"))<CR>

    PackAdd ale
    let b:ale_linters = ['shellcheck', 'language_server']

  endfunction

augroup END
" }}}
" Vimwiki {{{
augroup ft_vimwiki
  au!

  au FileType vimwiki call LoadVimWikiFT()
  function! LoadVimWikiFT()

    setlocal foldlevel=2

    PackAdd ale
    let b:ale_linters = ['vale', 'markdownlint']

    if !has('ivim')
      PackAdd medieval
      let g:medieval_langs = ['python=python3', 'ruby', 'sh', 'console=bash', 'bash', 'perl']
    endif

  endfunction

augroup END
" }}}
" Dockerfile {{{
augroup ft_dockerfile
  au!

  au FileType dockerfile call LoadDockerfileFT()
  function! LoadDockerfileFT()

    PackAdd ale
    let b:ale_linters = ['hadolint']

  endfunction

augroup END
" }}}
" Mail {{{
augroup ft_mail
  au!
  au FileType mail call LoadMailFT()

  function! LoadMailFT()

    map <buffer> <leader>ry :%!pandoc -f markdown_mmd -t html<CR>

    if !has('ivim')

      PackAdd livedown

      let g:livedown_browser = 'firefox'
      let g:livedown_port = 14545

      nmap <buffer> <silent> <leader>rr :LivedownPreview<CR>
      nmap <buffer> <silent> <leader>rt :LivedownToggle<CR>
      nmap <buffer> <silent> <leader>rk :LivedownKill<CR>

    endif

  endfunction

augroup END
" }}}
" Helm {{{
" inst: https://github.com/towolf/vim-helm filetypes opt helm
augroup ft_helm
  au!
  au BufRead,BufNewFile */templates/*.yaml,*/templates/*.tpl,Chart.yaml,values.yaml set ft=helm

  function! RenderHelm()
    write
    exe '!helm template ./ --output-dir .out'
  endfunction

  au FileType helm call LoadHelmFT()
  function! LoadHelmFT()
    PackAdd helm 1

    nmap <buffer> <silent> <leader>rr :call RenderHelm()<CR>
  endfunction

augroup END
"  }}}
" Log {{{
" inst: https://github.com/mtdl9/vim-log-highlighting filetypes opt log
augroup ft_log
  au!
  au BufNewFile,BufRead *.log set filetype=log

  au FileType log call LoadLogFT()
  function! LoadLogFT()
    PackAdd log 1
  endfunction

augroup END
"  }}}
" Terraform {{{
" inst: https://github.com/hashivim/vim-terraform filetypes opt terraform
augroup ft_terraform
  au!

  au FileType terraform call LoadTerraformFT()
  function! LoadTerraformFT()

    PackAdd terraform 1
    let g:terraform_align=1
    let g:terraform_fmt_on_save=1

    PackAdd ale
    call ale#linter#Define('terraform', {
          \   'name': 'terraform-lsp',
          \   'lsp': 'stdio',
          \   'executable': 'terraform-lsp',
          \   'command': '%e',
          \   'project_root': getcwd(),
          \})

  endfunction

augroup END
"  }}}
" LUA {{{
augroup ft_lua
  au!

  au FileType lua call LoadLUAFT()
  function! LoadLUAFT()

    PackAdd ale
    call ale#linter#Define('lua', {
          \   'name': 'lua-language-server',
          \   'lsp': 'stdio',
          \   'executable': 'lua-language-server',
          \   'command': '%e',
          \   'project_root': getcwd(),
          \})
  endfunction

augroup END
" }}}
" XML {{{
" inst: https://github.com/sukima/xmledit filetypes opt xml "make"
augroup ft_xml
  au!

  au FileType xml call LoadXMLFT()
  function! LoadXMLFT()
    PackAdd xml 1
  endfunction

augroup END
" }}}
" }}}

" UI {{{
" Colorscheme {{{
" inst: https://github.com/KeitaNakamura/neodark.vim ui opt neodark
PackAdd neodark
let g:neodark#background = '#282c34'
colorscheme neodark
" }}}
" Lightline {{{
" inst: https://github.com/itchyny/lightline.vim ui start lightline
if !has('gui_running')
  set t_Co=256
endif

let g:lightline = {
      \ 'colorscheme': 'neodark',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ,
      \             [ 'venv', 'readonly'] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head',
      \   'venv': 'virtualenv#statusline'
      \ },
      \ }

" }}}
" Fuzzy {{{
" inst: https://github.com/junegunn/fzf ui opt fzf
" inst: https://github.com/junegunn/fzf.vim ui opt fzf.vim
" inst: https://github.com/ctrlpvim/ctrlp.vim.git ui opt ctrlp.vim

if has('ivim')

  let g:ctrlp_map = '<leader>p1'
  let g:ctrlp_cmd = 'CtrlP'

  PackAdd ctrlp.vim

  nnoremap <silent> <leader>pp :CtrlP<CR>
  nnoremap <silent> <leader>pb :CtrlPBuffer<CR>
  nnoremap <silent> <leader>ff :CtrlPLine<CR>

else

  PackAdd fzf
  PackAdd fzf.vim

  tnoremap <expr> <Esc> (&filetype == "fzf") ? "<Esc>" : "<c-\><c-n>"
  command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, {'options': '--delimiter : --nth 4..',
        \ 'source': 'ag --hidden --ignore .git -U -p ~/.gitexcludes --nogroup --column --color "^(?=.)"'}, <bang>0)

  let g:fzf_tags_command = 'ctags -R --exclude=.git --exclude=.idea --exclude=log'

  nnoremap <silent> <leader>pp :Files<CR>
  nnoremap <silent> <leader>pm :Marks<CR>
  nnoremap <silent> <leader>pb :Buffers<CR>
  nnoremap <silent> <leader>pf :Filetypes<CR>

  let g:lmap.g.f = { 'name': '+File' }
  let g:lmap.g.f.h = 'file-History'
  nmap <silent> <leader>gfh :BCommits<CR>

  let g:lmap.f.f = 'in-File'
  nmap <silent> <leader>ff :Ag<CR>

  function! s:build_quickfix_list(lines)
    call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
    copen
    cc
  endfunction

  let g:fzf_action = {
        \ 'ctrl-q': function('s:build_quickfix_list'),
        \ 'ctrl-t': 'tab split',
        \ 'ctrl-x': 'split',
        \ 'ctrl-v': 'vsplit' }

  let $FZF_DEFAULT_OPTS = '--bind=ctrl-a:toggle-all,ctrl-space:toggle+down,ctrl-alt-a:deselect-all'
  let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -g "" -U -p ~/.gitexcludes'

endif
" }}}
" NERTree {{{
" inst: https://github.com/preservim/nerdtree ui start nerdtree
" inst: https://github.com/Xuyuanp/nerdtree-git-plugin ui start nerdtree-git

nnoremap <leader>pn :NERDTreeToggle<Bar>wincmd p<CR>
nnoremap <Plug>(find_Path) :call FindPathOrShowNERDTree()<CR>

function! FindPathOrShowNERDTree()
  let currentfile = expand('%')
  if (currentfile == "") || !(currentfile !~? 'NERD')
    NERDTreeToggle
  else
    NERDTreeFind
  endif
endfunction

let g:lmap.f.p = 'Path'
nmap <leader>fp <Plug>(find_Path)

let NERDTreeShowBookmarks=0
let NERDTreeChDirMode=2
let NERDTreeMouseMode=2
let g:nerdtree_tabs_focus_on_files=1
let g:nerdtree_tabs_open_on_gui_startup=0

" make nerdtree look nice
let NERDTreeMinimalUI=1
let NERDTreeDirArrows=1
let g:NERDTreeWinSize=30
let NERDTreeIgnore=['\.pyc$']

" ReMaps
let NERDTreeMapOpenVSplit='v'
let NERDTreeMapOpenSplit='s'
let NERDTreeMapJumpNextSibling=''
let NERDTreeMapJumpPrevSibling=''

" Close vim if the only NERDTree window left
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" }}}
" Which-Key {{{
" inst: https://github.com/liuchengxu/vim-which-key ui opt which-key
PackAdd which-key

nnoremap <silent> <leader> :WhichKey '<Space>'<CR>
vnoremap <silent> <leader> :<c-u>WhichKeyVisual '<Space>'<CR>

nnoremap <silent> <localleader> :<c-u>WhichKey  ','<CR>
vnoremap <silent> <localleader> :<c-u>WhichKeyVisual ','<CR>
" }}}
" Indent-guides {{{
" inst: https://github.com/nathanaelkane/vim-indent-guides ui opt indent-guides
PackAdd indent-guides

let g:indent_guides_auto_colors = 0
hi IndentGuidesOdd  ctermbg=237
hi IndentGuidesEven ctermbg=236

let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_default_mapping = 0
" }}}
" Texting {{{
" inst: https://github.com/junegunn/goyo.vim ui opt goyo
" inst: https://github.com/junegunn/limelight.vim ui opt limelight

" Spell Check
let g:myLangList=["nospell","en_us", "ru_ru"]

function! ToggleSpell()
  if !exists( "b:myLang" )
    if &spell
      let b:myLang=index(g:myLangList, &spelllang)
    else
      let b:myLang=0
    endif
  endif
  let b:myLang=b:myLang+1
  if b:myLang>=len(g:myLangList) | let b:myLang=0 | endif
  if b:myLang==0
    setlocal nospell
    " exe "GrammarousReset"
  else
    execute "setlocal spell spelllang=".get(g:myLangList, b:myLang)
    " execute "GrammarousCheck"
  endif
  echo "spell checking language:" g:myLangList[b:myLang]
endfunction

nnoremap <silent> <F7> :call ToggleSpell()<CR>

let g:lmap.t.s = 'Syntax'
nnoremap <silent> <leader>ts :call ToggleSpell()<CR>
imap <silent> <F7> <ESC>:call ToggleSpell()<CR>a

" Focus on the process
"
function! s:goyo_enter()
  silent !tmux set status off
  silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  set noshowmode
  set noshowcmd
  set scrolloff=999
  set wrap
  Limelight
  " ...
endfunction

function! s:goyo_leave()
  silent !tmux set status on
  silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
  set showmode
  set showcmd
  set scrolloff=5
  set nowrap
  Limelight!
  " ...
endfunction

au! User GoyoEnter nested call <SID>goyo_enter()
au! User GoyoLeave nested call <SID>goyo_leave()

function! StartGoyo()

  if !exists("g:goyo_loaded")
    let g:goyo_loaded = 1
    PackAdd goyo
    PackAdd limelight
  endif

  Goyo

endfunction

let g:lmap.t.t = 'Text-only(Goyo)'
nnoremap <silent> <leader>tt :call StartGoyo()<CR>
" }}}
" Tmux {{{
" inst: https://github.com/christoomey/vim-tmux-navigator ui start tmux-navigator
" inst: https://github.com/benmills/vimux ui opt vimux
if exists('$TMUX')
  if has('nvim')
    nnoremap <silent> <BS> :TmuxNavigateLeft<cr>
  endif

  let g:tmux_navigator_save_on_switch = 2
  let g:tmux_navigator_disable_when_zoomed = 1

  PackAdd vimux

  " Override RunCmd command
  function! RunCmd(cmd)
    mark z
    exe VimuxRunCommand(a:cmd)
    exe "normal! g`z"
    delmark z
  endfunction

  function! CloseRunner()
    if exists('g:VimuxRunnerIndex')
      let choice = confirm("Close runner?", "\n&yes\n&no\nor &detach", 2)

      if choice == 2
        VimuxCloseRunner
      elseif choice == 4
        unlet g:VimuxRunnerIndex
      endif
    else
      echo "Runner is not registered"
    endif
  endfunction

  let g:lmap.r.q = 'Close Runner'
  nmap <leader>rq :call CloseRunner()<CR>

  let g:lmap.r.x = 'Interrupt'
  nmap <leader>rx :VimuxInterruptRunner<CR>
  let g:VimuxHeight = "20"
  let g:VimuxUseNearest = 0
endif
" }}}
" Autoread {{{
" inst: https://github.com/djoshea/vim-autoread ui start autoread
let autoreadargs={'autoread':1}
" }}}
" Zoom {{{
" inst: https://github.com/dhruvasagar/vim-zoom ui start vim-zoom

let g:lmap.z = 'Zoom'
nmap <leader>z :call ZoomToggle()<CR>

function! ZoomToggle()
  if (exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1)
    exe ':NERDTreeClose'
    let zoom_nerd = 1
  endif

  if (exists("t:tagbar_buf_name") && bufwinnr(t:tagbar_buf_name) != -1)
    exe ':TagbarClose'
    let zoom_tag = 1
  endif

  call zoom#toggle()

  if (exists("zoom_nerd") && (zoom_nerd == 1))
    exe ':NERDTreeCWD'
    exe ':wincmd p'
    unlet zoom_nerd
  endif

  if (exists("zoom_tag") && (zoom_tag == 1))
    exe ':TagbarOpen'
    unlet zoom_tag
  endif
endfunction
" }}}
" }}}

" Code {{{
" Ale {{{
" inst: https://github.com/w0rp/ale code opt ale
" let g:ale_sign_column_always = 1
let g:ale_sign_error = '!!'
let g:ale_sign_warning = '..'
" let g:ale_lint_on_text_changed = 'never'
" let g:ale_lint_on_insert_leave = 0
let g:ale_completion_enabled = 0
" }}}
" Completor {{{
" inst: https://github.com/maralla/completor.vim  code opt completor
PackAdd completor

inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? "\<C-y>" : "\<cr>"

" let g:asyncomplete_auto_completeopt = 0
" set completeopt=menuone,noinsert,noselect,preview
" }}}
" Text objects {{{
" inst: https://github.com/kana/vim-textobj-user code start textobj

" adds: f - function
" inst: https://github.com/bps/vim-textobj-python code opt textobj-python

let g:textobj_python_no_default_key_mappings = 1
xmap af <Plug>(textobj-python-function-a)
omap af <Plug>(textobj-python-function-a)
xmap if <Plug>(textobj-python-function-i)
omap if <Plug>(textobj-python-function-i)

" Adds: i - indent, I - the same indent
" inst: https://github.com/kana/vim-textobj-indent code start textobj-indent

" Adds: c - comment, C - whole comment
" inst: https://github.com/glts/vim-textobj-comment code start textobj-comment
" }}}
" Easyalign {{{
" inst: https://github.com/junegunn/vim-easy-align code start easy-align
nmap ga <Plug>(LiveEasyAlign)
xmap ga <Plug>(LiveEasyAlign)
" }}}
" Find and Replace {{{
" inst: https://github.com/brooth/far.vim code start far

let g:far#source = 'agnvim'
let g:far#file_mask_favorites = ['%', '.*', '\.py$', '\.go$']

let g:lmap.f.r = 'Replace'
nnoremap <leader>fr :Far<space>
vnoremap <leader>fr :Far<space>

" }}}
" Surround {{{
" inst: https://github.com/tpope/vim-surround code start surround
let g:surround_113="#{\r}"       " v
let g:surround_35="#{\r}"        " #
let g:surround_45="{%- \r -%}"   " -
let g:surround_61="{%= \r =%}"   " =

" div
let g:surround_{char2nr("d")} = "<div\1id: \r..*\r id=\"&\"\1>\r</div>"
" xml
let g:surround_{char2nr("x")} = "<\1id: \r..*\r&\1>\r</\1\1>"

let g:surround_{char2nr("%")} = "{% \r %}"

" }}}
" AnyJump {{{
if has('ivim')
  " inst: https://github.com/dkprice/vim-easygrep.git code opt easygrep
  PackAdd easygrep
  let g:EasyGrepOptionPrefix=''
  map <silent> <Leader>j <plug>EgMapGrepCurrentWord_v
else
  " inst: https://github.com/pechorin/any-jump.vim code opt anyjump
  PackAdd anyjump
  let g:any_jump_search_prefered_engine = 'rg'
endif
" }}}
" Commentary {{{
" inst: https://github.com/tpope/vim-commentary code start commentary
set commentstring=#\ %s
" }}}
" Snippets {{{
" inst: https://github.com/Shougo/neosnippet.vim code start neosnippet
" inst: https://github.com/Shougo/neosnippet-snippets code start neosnippet-snippets
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)
" }}}
" AutoIndent {{{
" inst: https://github.com/tpope/vim-sleuth code start auto-indent
" }}}
" -> Git {{{
" inst: https://github.com/tpope/vim-fugitive code opt fugitive
" inst: https://github.com/tpope/vim-rhubarb code opt rhubarb
" inst: https://github.com/shumphrey/fugitive-gitlab.vim code opt gitlab

if !has('ivim')

  PackAdd fugitive
  PackAdd rhubarb
  PackAdd gitlab

  " Helper
  function! GitShowBlockHistory()
    exe ":G log -L " . string(getpos("'<'")[1]) . "," . string(getpos("'>'")[1]) . ":%"
  endfunction

  " Fugitive options
  au BufEnter */.git/index nnoremap <buffer> <silent> c :WhichKey 'c'<CR>
  au BufEnter */.git/index nnoremap <buffer> <silent> d :WhichKey 'd'<CR>
  au BufEnter */.git/index nnoremap <buffer> <silent> r :WhichKey 'r'<CR>
  "
  " shortcuts mapping
  let g:lmap.g.s = 'Status'
  nmap <silent> <leader>gs :Gstatus<CR>
  let g:lmap.g.d = 'Diff'
  nmap <silent> <leader>gd :Gdiff<CR>
  let g:lmap.g.C = 'Commit'
  nmap <silent> <leader>gC :Gcommit<CR>
  let g:lmap.g.W = 'Write'
  nmap <silent> <leader>gW :Gwrite<CR>
  let g:lmap.g.R = 'Read'
  nmap <silent> <leader>gR :Gread<CR>

  let g:lmap.g.b = { 'name': '+Blame' }
  let g:lmap.g.b.l = 'bLame'
  nmap <silent> <leader>gbl :Gblame<CR>

  let g:lmap.g.p = { 'name': '+Push-pull' }
  let g:lmap.g.p.s = 'Push'
  nmap <silent> <leader>gps :G push<CR>
  let g:lmap.g.p.l = { 'name': '+Pull' }
  let g:lmap.g.p.l.r = 'Rebase'
  nmap <silent> <leader>gplr :G pull --rebase<CR>
  let g:lmap.g.p.l.m = 'Merge'
  nmap <silent> <leader>gplm :G pull<CR>
  let g:lmap.g.g = 'Browse'
  nmap <silent> <leader>gg :.Gbrowse %<CR>
  vmap <silent> <leader>gg :'<,'>Gbrowse %<CR>
  let g:lmap.g.v = { 'name': '+Visual' }
  vmap <silent> <leader>gvh :<C-U>call GitShowBlockHistory()<CR>

  " Gitgutter options
  " inst: https://github.com/airblade/vim-gitgutter code opt gitgutter
  PackAdd gitgutter
  let g:gitgutter_map_keys = 0

  nmap [g <Plug>(GitGutterPrevHunk)
  nmap ]g <Plug>(GitGutterNextHunk)

  let g:gitgutter_override_sign_column_highlight = 0

  let g:lmap.g.hs = 'Hunk-Stage'
  nmap <leader>ghs :GitGutterStageHunk<CR>
  let g:lmap.g.hr = 'Hunk-Revert'
  nmap <leader>ghr :GitGutterUndoHunk<CR>
  let g:lmap.g.hp = 'Hunk-Preview'
  nmap <leader>ghp :GitGutterPreviewHunk<CR>

  " Gitv options
  " inst: https://github.com/junegunn/gv.vim code opt gv
  PackAdd gv

  let g:lmap.g.h = 'History'
  let g:Gitv_DoNotMapCtrlKey = 1
  nmap <silent> <leader>gh :GV<CR>

  " Git messages in popup
  " inst: https://github.com/rhysd/git-messenger.vim code opt git-messenger
  PackAdd git-messenger

  let g:git_messenger_no_default_mappings = v:true
  let g:git_messenger_always_into_popup = v:true
  nmap <Leader>gbb <Plug>(git-messenger)
endif
" }}}
" }}}

" Motion {{{
" Easymotion {{{
" inst: https://github.com/easymotion/vim-easymotion ui start easymotion
"
let g:EasyMotion_do_mapping = 0 " Disable default mappings

" Jump to anywhere you want with minimal keystrokes, with just one key binding.
nmap ss <Plug>(easymotion-overwin-f)

" Turn on case insensitive feature
let g:EasyMotion_smartcase = 1

map sl <Plug>(easymotion-lineforward)
map sj <Plug>(easymotion-j)
map sk <Plug>(easymotion-k)
map sh <Plug>(easymotion-linebackward)
" }}}
" }}}

" Additional {{{
" VimWiki {{{
" inst: https://github.com/vimwiki/vimwiki ui opt vimwiki "branch dev"
function! LoadVimwiki()

  let g:lmap.w.w = 'Index'
  nunmap <Leader>ww
  noremap <Leader>ww :call VimwikiIndexCd()<CR>
  noremap <Leader>wj :VimwikiDiaryNextDay<CR>
  noremap <Leader>wk :VimwikiDiaryPrevDay<CR>

  nunmap <Leader>w<Space>i
  nunmap <Leader>w<Space>t
  nunmap <Leader>w<Space>w
  nunmap <Leader>w<Space>y
  nunmap <Leader>w<Space>m
  nunmap <Leader>wt
  " i - generate
  " t tab make diary
  " w make diary
  " y yesterday
  " m tommorow

  map <leader>wt :call VimwikiMakeDiaryNoteNew()<CR>
  let g:lmap.w.s = 'Select-wiki'
  let g:lmap.w.t = 'Today'
  let g:lmap.w.i = 'Diary'
endfunction

function! VimWikiHelpers()
  let g:lmap.w.r = 'Rename-link'
  let g:lmap.w.d = 'Delete-link'
  let g:lmap.w.h = 'to-Html'
  let g:lmap.w.hh = 'toHtml-browse'
  let g:lmap.w.n = 'goto'
endfunction

function! VimwikiIndexCd()
  VimwikiIndex
  cd %:h
  call VimWikiHelpers()
endfunction

function! VimwikiMakeDiaryNoteNew()
  VimwikiMakeDiaryNote
  cd %:h:h
  call VimWikiHelpers()
endfunction

let g:vimwiki_list = [{'path': '~/Notes/',
      \ 'syntax': 'markdown', 'ext': '.md',
      \ 'auto_toc': 1,
      \ 'auto_diary_index': 1,
      \ 'list_margin': 0,
      \ 'custom_wiki2html': 'vimwiki-godown',
      \ 'auto_tags': 1}]

let g:vimwiki_ext2syntax = {'.md': 'markdown',
      \ '.mkd': 'markdown',
      \ '.wiki': 'media'}

let g:vimwiki_folding = 'expr'
let g:vimwiki_hl_headers = 1
let g:vimwiki_hl_cb_checked = 2
"let g:vimwiki_markdown_link_ext = 1

PackAdd vimwiki
" }}}
" Sessions {{{
let g:sessiondir = $HOME . "/.vim_sessions"

function! MakeSession(file)

  if (exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1)
    exe ':tabdo NERDTreeClose'
  endif

  if (exists("t:tagbar_buf_name") && bufwinnr(t:tagbar_buf_name) != -1)
    exe ':tabdo TagbarClose'
  endif

  exe ':lclose|cclose'

  let file = a:file

  if (file == "")
    if (exists('g:sessionfile'))
      let b:sessiondir = g:sessiondir
      let file = g:sessionfile
    else
      let b:sessiondir = g:sessiondir . getcwd()
      let file = "session"
    endif
  else
    let b:sessiondir = g:sessiondir
    let g:sessionfile = file
  endif

  if (filewritable(b:sessiondir) != 2)
    exe 'silent !mkdir -p ' b:sessiondir
    redraw!
  endif
  let b:filename = b:sessiondir . '/' . file . '.vim'

  exe "silent mksession! " . b:filename
endfunction

function! LoadSession(file)

  let file = a:file

  if (file == "")
    if (exists('g:sessionfile'))
      let b:sessiondir = g:sessiondir
      let file = g:sessionfile
    else
      let b:sessiondir = g:sessiondir . getcwd()
      let file = "session"
    endif
  else
    let b:sessiondir = g:sessiondir
    let g:sessionfile = file
  endif

  let b:sessionfile = b:sessiondir . '/' . file . '.vim'
  if (filereadable(b:sessionfile))
    exe 'silent source ' b:sessionfile
  else
    echo "No session loaded."
  endif
endfunction

function! DeleteSession(file)

  let file = a:file

  if (file == "")
    if (exists('g:sessionfile'))
      let b:sessiondir = g:sessiondir
      let file = g:sessionfile
    else
      let b:sessiondir = g:sessiondir . getcwd()
      let file = "session"
    endif
  else
    let b:sessiondir = g:sessiondir
  endif

  let b:sessionfile = b:sessiondir . '/' . file . '.vim'
  if (filereadable(b:sessionfile))
    exe 'silent !rm -f ' b:sessionfile
  else
    echo "No session loaded."
  endif
endfunction

function! CloseSession()
  if (exists('g:sessionfile'))
    call MakeSession(g:sessionfile)
    unlet g:sessionfile
  else
    call MakeSession("")
  endif
  exe 'silent wa | %bd!'
endfunction

function! CloseSessionAndExit()
  call CloseSession()
  exe 'silent qa'
endfunction

fun! ListSessions(A,L,P)
  return system("ls " . g:sessiondir . ' | grep .vim | sed s/\.vim$//')
endfun

command! -nargs=1 -range -complete=custom,ListSessions MakeSession :call MakeSession("<args>")
command! -nargs=1 -range -complete=custom,ListSessions LoadSession :call LoadSession("<args>")
command! -nargs=1 -range -complete=custom,ListSessions DeleteSession :call DeleteSession("<args>")
command! MakeSessionCurrent :call MakeSession("")
command! LoadSessionCurrent :call LoadSession("")
command! DeleteSessionCurrent :call DeleteSession("")
command! CloseSession :call CloseSession()
command! CloseSessionAndExitCurrent :call CloseSessionAndExit()

nnoremap <Plug>(session_Load) :LoadSession<SPACE>
nnoremap <Plug>(session_Load-Current) :LoadSessionCurrent<CR>
nnoremap <Plug>(session_Make) :MakeSessionCurrent<CR>
nnoremap <Plug>(session_Exit) :CloseSessionAndExit<CR>
nnoremap <Plug>(session_Close) :CloseSession<CR>
nnoremap <Plug>(session_Delete) :DeleteSessionCurrent<CR>

let g:lmap.s.o = 'Open'
nmap <leader>so <Plug>(session_Load)
let g:lmap.s.u = 'open-cUrrent'
nmap <leader>su <Plug>(session_Load-Current)
let g:lmap.s.s = 'Save'
nmap <leader>ss <Plug>(session_Make)
let g:lmap.s.q = 'Quit'
nmap <leader>sq <Plug>(session_Exit)
let g:lmap.s.c = 'Close'
nmap <leader>sc <Plug>(session_Close)
let g:lmap.s.d = 'Delete'
nmap <leader>sd <Plug>(session_Delete)
" }}}
" Folding {{{
" Thx Steve Losh
set foldlevelstart=0

" "Focus" the current line.  Basically:
"
" 1. Close all folds.
" 2. Open just the folds containing the current line.
" 3. Move the line to a little bit (15 lines) above the center of the screen.
"
" This mapping wipes out the z mark, which I never use.
"
function! MyFoldText() " {{{
  let line = getline(v:foldstart)

  let nucolwidth = &fdc + &number * &numberwidth
  let windowwidth = winwidth(0) - nucolwidth - 3
  let foldedlinecount = v:foldend - v:foldstart

  " expand tabs into spaces
  let onetab = strpart('          ', 0, &tabstop)
  let line = substitute(line, '\t', onetab, 'g')

  let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
  let fillcharcount = windowwidth - len(line) - len(foldedlinecount)
  return line . '…' . repeat(" ",fillcharcount) . foldedlinecount . '…' . ' '
endfunction " }}}
set foldtext=MyFoldText()

" }}}
" AutoSave feature {{{

" Trigger autoread when changing buffers or coming back to vim.
" au FocusGained,BufEnter,WinEnter * :silent! !

au! FileType vim,python,golang,go,yaml.ansible,puppet,json,sh,vimwiki,rust,yaml call DefaultOn()

function! DefaultOn()
  if !exists("b:auto_save")
    let b:auto_save = 1
  endif
endfunction

set updatetime=4000

let s:save_cpo = &cpo
set cpo&vim

if !exists("g:auto_save_silent")
  let g:auto_save_silent = 0
endif

if !exists("g:auto_save_events")
  let g:auto_save_events = ["CursorHold","CursorHoldI","BufLeave","FocusLost","WinLeave"]
endif

" Check all used events exist
for event in g:auto_save_events
  if !exists("##" . event)
    let eventIndex = index(g:auto_save_events, event)
    if (eventIndex >= 0)
      call remove(g:auto_save_events, eventIndex)
      echo "(AutoSave) Save on " . event . " event is not supported for your Vim version!"
      echo "(AutoSave) " . event . " was removed from g:auto_save_events variable."
      echo "(AutoSave) Please, upgrade your Vim to a newer version or use other events in g:auto_save_events!"
    endif
  endif
endfor

augroup auto_save
  au!
  for event in g:auto_save_events
    execute "au " . event . " * nested call AutoSave()"
  endfor
augroup END

function! AutoSave()
  if &modified > 0
    if !exists("b:auto_save")
      let b:auto_save = 0
    endif

    if b:auto_save == 0
      return
    end

    let was_modified = &modified

    " Preserve marks that are used to remember start and
    " end position of the last changed or yanked text (`:h '[`).
    let first_char_pos = getpos("'[")
    let last_char_pos = getpos("']")

    call DoSave()

    call setpos("'[", first_char_pos)
    call setpos("']", last_char_pos)

    if was_modified && !&modified
      if g:auto_save_silent == 0
        echo "(AutoSave) saved at " . strftime("%H:%M:%S")
      endif
    endif
  endif
endfunction

function! DoSave()
  silent! w
endfunction

function! ToggleAutoSave()
  if !exists("b:auto_save")
    let b:auto_save = 0
  endif

  if b:auto_save == 0
    let b:auto_save = 1
  else
    let b:auto_save = 0
  end
endfunction

command! ToggleAutoSave :call ToggleAutoSave()

let &cpo = s:save_cpo
unlet s:save_cpo
" }}}
" Quickfix {{{
function! GetBufferList()
  redir =>buflist
  silent! ls!
  redir END
  return buflist
endfunction

function! ToggleList(bufname, pfx)
  let buflist = GetBufferList()
  for bufnum in map(filter(split(buflist, '\n'), 'v:val =~ "'.a:bufname.'"'), 'str2nr(matchstr(v:val, "\\d\\+"))')
    if bufwinnr(bufnum) != -1
      exec(a:pfx.'close')
      return
    endif
  endfor
  if a:pfx == 'l' && len(getloclist(0)) == 0
    echohl ErrorMsg
    echo "Location List is Empty."
    return
  endif
  let winnr = winnr()
  exec(a:pfx.'open')
  if winnr() != winnr
    wincmd p
  endif
endfunction

function! QFixSwitch(direction)
  exec('copen')
  if a:direction == 'next'
    try
      cnext
    catch E42
    catch E553
      echom "No more items"
    endtry
  elseif a:direction == 'prev'
    try
      cprevious
    catch E42
    catch E553
      echom "No more items"
    endtry
  else
    echom "Unknown direction"
  endif
endfunction

nnoremap <Plug>(qfix_Toggle) :call ToggleList("Quickfix List", 'c')<CR>
nnoremap <Plug>(qfix_Open) :copen<CR>
nnoremap <Plug>(qfix_Close) :cclose<CR>
nnoremap <Plug>(qfix_QNext) :call QFixSwitch('next')<CR>
nnoremap <Plug>(qfix_QPrev) :call QFixSwitch('prev')<CR>
let g:lmap.q.q = 'toggle'
nmap <leader>qq  <Plug>(qfix_Toggle)
let g:lmap.q.o = 'Open'
nmap <leader>qo <Plug>(qfix_Open)
let g:lmap.q.c = 'Close'
nmap <leader>qc <Plug>(qfix_Close)
let g:lmap.q.n = 'Next'
nmap <leader>qn <Plug>(qfix_QNext)
let g:lmap.q.p = 'Previous'
nmap <leader>qp <Plug>(qfix_QPrev)

nnoremap <Plug>(qfix_LToggle) :call ToggleList("Location List", 'l')<CR>
nnoremap <Plug>(qfix_LOpen) :lopen<CR>
nnoremap <Plug>(qfix_LClose) :lclose<CR>
nnoremap <Plug>(qfix_LNext) :lnext<CR>
nnoremap <Plug>(qfix_LPrev) :lprev<CR>
let g:lmap.l.l = 'toggle'
nmap <leader>ll  <Plug>(qfix_LToggle)
let g:lmap.l.o = 'Open'
nmap <leader>lo <Plug>(qfix_LOpen)
let g:lmap.l.c = 'Close'
nmap <leader>lc <Plug>(qfix_LClose)
let g:lmap.l.n = 'Next'
nmap <leader>ln <Plug>(qfix_LNext)
let g:lmap.l.p = 'Previous'
nmap <leader>lp <Plug>(qfix_LPrev)
" }}}
" TODOs {{{
inoremap \td <C-R>=split(&commentstring, '%s')[0] . 'TODO: '<CR><CR><C-R>=expand("%:h") . '/' . expand("%:t") . ':' . line(".")<CR><C-G><C-K><C-O>A
inoremap \dts <C-R>=strftime("%Y-%m-%d %H:%M:%S")<CR>
inoremap \dtm <C-R>=strftime("%Y-%m-%d %H:%M")<CR>
inoremap \dtd <C-R>=strftime("%Y-%m-%d")<CR>
inoremap \fl <C-R>=expand("%:h") . '/' . expand("%:t") . ':' . line(".")<CR>
inoremap \fp <C-R>=expand("%:h") . '/' . expand("%:t")<CR>

let g:lmap.t.d = 'to-Do'
nnoremap <leader>td O<C-R>=split(&commentstring, '%s')[0] . 'TODO: '<CR><CR><C-R>=expand("%:h") . '/' . expand("%:t") . ':' . line(".")<CR><C-G><C-K><C-O>A

let g:lmap.o.t = 'To-do'
nnoremap <leader>ot :call OpenToDo()<CR>
function! OpenToDo()
  vsplit TODO.md
  nnoremap <buffer> q :x<CR>
  hi TODO guifg=Yellow ctermfg=Yellow term=Bold
  hi FIXME guifg=Red ctermfg=Red term=Bold
  hi P1 guifg=Red ctermfg=Red term=Bold
  hi P2 guifg=LightRed ctermfg=LightRed term=Bold
  hi P3 guifg=LightYellow ctermfg=LightYellow term=Bold
  hi P4 guifg=LightGrey ctermfg=Grey term=Italic
  hi DONE guifg=DarkGreen ctermfg=Grey term=Italic

  call matchadd('TODO', 'TODO')
  call matchadd('TODO', '@todo')
  call matchadd('FIXME', 'FIXME')
  call matchadd('FIXME', '@fixme')
  syn match P1 ".*\[[^X]\]\s\+[pP]1.*$"
  syn match P2 ".*\[[^X]\]\s\+[pP]2.*$"
  syn match P3 ".*\[[^X]\]\s\+[pP]3.*$"
  syn match P4 ".*\[[^X]\]\s\+[pP]4.*$"
  syn match DONE ".*\[[X]\]\s.*$"
endfunction

let g:lmap.t.h = 'To-Html'
nnoremap <leader>th :TOhtml<CR>
vnoremap <leader>th :TOhtml<CR>
" }}}
" Small plugins {{{
" inst: https://github.com/bronson/vim-trailing-whitespace other start whitespace
" inst: https://github.com/jiangmiao/auto-pairs other start auto-pairs
" inst: https://github.com/junegunn/vim-peekaboo other start peekaboo
let g:peekaboo_delay = 1000
" inst: https://github.com/chaoren/vim-wordmotion other start wordmotion
" inst: https://github.com/tpope/vim-repeat other start repeat

" if !has('ivim')
" inst: https://github.com/powerline/fonts other opt fonts
" endif
" }}}
" }}}

" -> Xkb {{{
" inst: https://github.com/lyokha/vim-xkbswitch other start xkbswitch
let g:XkbSwitchEnabled = 1
let g:XkbSwitchSkipFt = [ 'nerdtree' ]
" }}}

" Leader end
call which_key#register('<Space>', "g:lmap")

" Start {{{
au! VimEnter * call AfterVimEnter()
function! AfterVimEnter()
  if g:largefile != 1
    exe ":IndentGuidesEnable"
  endif

  call LoadVimwiki()
endfunction
" }}}

" Load local vars {{{
"
try
  source ~/.vimrc.local
catch
  " Ignoring
endtry
" }}}
