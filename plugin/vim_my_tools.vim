"=============================================================================
"
" Vim Plugin: VimMyTools
"
" Description:
" ------------
" VimMyTools is a straightforward Vim plugin that enhances the Python
" development workflow by allowing users to run Python scripts and tests
" seamlessly from within Vim. By recognizing the context of the file, it will
" either run the entire script or the relevant test, providing a simple yet
" efficient development aid.
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
"=============================================================================


nnoremap <leader>r :call vim_my_tools#RunSelectedScript()<CR>



