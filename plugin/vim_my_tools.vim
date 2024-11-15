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

"=============================================================================
"
" <leader>t Mapping
"
" Overview:
" Pressing the <leader>t key combination activates a plugin functionality
" that opens the file referenced by the line under the cursor. This is
" especially useful in the context of exception tracebacks. When the cursor
" is on a line containing a file path and a line number (as often seen in
" error messages), the plugin automatically navigates to the specified file
" and jumps to the corresponding line.
"
" Supported Formats:
"
" 1. Python Traceback:
"    Recognizable pattern when running Python scripts, typically formatted as:
"    File '/home/user/junk/junk.py', line 2, in test_junk
"
" 2. Quickfix List with copen:
"    Format seen when utilizing the copen command, particularly in conjunction with pytest:
"    some_module.py|2| ValueError
"
" 3. Pytest Command Line Output:
"    Format produced when executing pytest from the terminal:
"    some_module.py:42: AssertionError
"
" Usage:
" - Place the cursor over a line fitting one of the supported formats.
" - Press <leader>t to trigger the file opening and line jump action.
"
nnoremap <leader>t :call vim_my_tools#OpenFile()<CR>

"=============================================================================
