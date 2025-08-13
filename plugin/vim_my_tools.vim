"=============================================================================
"
" Vim Plugin: VimMyTools
"
" Description:
" ------------
"" VimMyTools is a Vim plugin that streamlines the workflow for Python
" development. It provides convenient keybindings for running Python scripts and
" opening files referenced in error tracebacks directly from Vim. By automating
" these processes, VimMyTools enhances productivity and ease of navigation within
" Python projects.
"
" Installation:
" ------------
" - Install VimMyTools with a Vim plugin manager like vim-plug, Vundle, or
"   Pathogen.
"
" Configuration:
" --------------
" - Set your desired Python interpreter in your .vimrc:
"     let g:python_interpreter = 'python3.X'
"
"   The default python interpreter that is used if the above global variable is
"   not defined is python (wherever this is pointing to).
"
" - For tests, pytest will be required and must be installed and available to
"   the running process.
"
"=============================================================================
"
" <leader>r Mapping
"
" Features:
" ---------
" - Execute Python scripts or test suites directly from Vim with a single
"   keystroke.
"
" - Automatically discern whether the current file is a test or regular script
"   and run accordingly.
"
" - Display output within Vim for easy access and review.
"
" Usage:
" -----
" - Normal mode: Press <leader>r to run the current Python file.
"
"   - If inside a test file, it will run the test under the cursor or the
"   entire suite.
"
"   - For other Python files, it executes the complete script.
"
"
nnoremap <leader>r :call vim_my_tools#RunSelectedScript()<CR>

" Open scratch window.
command! Scratch execute "call vim_my_tools#ScratchPad()"
