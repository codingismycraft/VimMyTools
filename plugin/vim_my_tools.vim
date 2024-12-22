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
"
" <leader>b Mapping
"
" Overview:
" Writes the doc string for the python function, method or class
" that is copied to the "0 register.
"
" The created docstring is copied to the "* register.
"
nnoremap <silent><leader>b :call vim_my_tools#MakeDocStr()<CR>

"=============================================================================
"
" Managing the buffers per window it the order they are opened.
"
"
autocmd! BufWinEnter * :call vim_my_tools#AddBuffer()

" Ctrl -n : Displays the next buffer in the list.
nnoremap <C-n> :call vim_my_tools#ShowNextBuffer()<CR>

" Ctrl -b : Displays the previous buffer in the list.
nnoremap <C-b> :call vim_my_tools#ShowPreviousBuffer()<CR>


" Ctrl -a : Displays all available buffers
nnoremap <C-a> :call vim_my_tools#ListBuffersForActiveWindow()<CR>




