let s:plugin_path = expand('<sfile>:p:h')
let s:path_was_added = 0

python3 << endpython

import os
import subprocess
import sys
import vim

def preparePythonPath():
    """Adds the path of the related code to the python path.

    The path is added only once since we rely on a script scoped
    variable (path_was_added) as the import guard.
    """
    was_added = int(vim.eval("s:path_was_added"))
    if not was_added:
        path = vim.eval("s:plugin_path")
        path = os.path.dirname(path)
        sys.path.insert(0, path)
        vim.command("let s:path_was_added = 1")
endpython

function! vim_my_tools#MakeDocStr()
set cmdheight=2
echo "Please wait.."
let fullpath = s:plugin_path . "/../mytools/execquery.py"
let exit_status = system(fullpath)
if v:shell_error != 0
    echom "Query Execution failed!"
else
    echo "Query Execution OK."
endif
endfunction


function! vim_my_tools#OpenFile()
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Opens a file placing the cursor in the specified line number.
"
" If the cursor rests in a line containing a filename and line this
" function will open it either in a new window or bring the existing window
" to the front.
"
" If the line where the user's cursor does not conform to the expected format
" then an error will be echoed.
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

python3 << endpython
preparePythonPath()
import mytools.mytools as mytools
current_line = vim.eval("""getline('.')""")
vim.vars['vt_filepath'] = ""
vim.vars['vt_line'] = ""
try:
    filepath, line = mytools.get_filename_and_line(current_line)
except ValueError:
    vim.vars['vt_filepath'] = ""
    vim.vars['vt_line'] = ""
else:
    if os.path.isfile(filepath):
        vim.vars['vt_filepath'] = filepath
        vim.vars['vt_line'] = line
endpython

let l:filepath = g:vt_filepath
let l:line = g:vt_line

if !empty(l:filepath)
    call vim_my_tools#ActivateWindow(l:filepath, l:line)
else
    echo "No matching file was found.."
endif

if exists('g:vt_filepath')
    unlet g:vt_filepath
endif

if exists('g:vt_line')
    unlet g:vt_line
endif

endfunction

function! vim_my_tools#ActivateWindow(filepath, line)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Activates the passed in file and move the curssor to the specified line.
"
" If the passed in file path is already open then the corresponding window
" will be activated.
" Othewise the file will be opened in the active window (overwritting the
" existing content).
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
execute "highlight CursorLine NONE"
let windowNr = bufwinnr(a:filepath)
if windowNr > 0
    execute windowNr 'wincmd w'
else
    execute "sp ". a:filepath
endif
execute ":".a:line
endfunction


function! vim_my_tools#RunSelectedScript()
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Sets the makeprg based on the location of the cursor in the current file.
"
" Based on the file type and the location of the cursor this function is
" setting the proper value for the makeprg vim variable so the make can be
" called accordingnly.
"
" Currently, only python is supported and the functionality in this case is to
" detect if the user is pointing on a unit test or an regulart script and make
" the proper calls.
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
python3 << endpython
preparePythonPath()
import mytools.mytools as mytools
home_dir = vim.eval("""expand("$HOME")""")
fullpath = vim.eval("""expand("%:p")""").strip()

try:
    python_interpreter = vim.eval("g:python_interpreter")
except:
    python_interpreter = "python"

TESTING_PROGRAM = "pytest"

filepath = os.path.join(home_dir, fullpath)
if filepath.endswith(".py"):
    linenum = int(vim.eval(""" line(".") """))
    exec_path = mytools.get_exec_target(filepath, linenum)
    is_test = mytools.is_testing_script(filepath)
    program_name = TESTING_PROGRAM if is_test else python_interpreter
    command = f"set makeprg={program_name}\\ {exec_path}"

    # Adds the command to run in the clipboard just in case you need
    # to execute it by hand in another CLI window.
    run_command = f"{program_name} {exec_path}"
    vim.command(f'let @*="{run_command}"')
    vim.command(f'let @+="{run_command}"')
    vim.command(f'let @"="{run_command}"')
    vim.command(f'let @0="{run_command}"')

    # Execute the make command (which will run either the script of the test).
    vim.command(command)
else:
    print(f"Do not know how to run {filepath}")
endpython
call feedkeys(":make", 'n')
endfunction


function! vim_my_tools#AddBuffer()
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Binds the buffer_id with the buffers for the window_id.
"
" Meant to be called every time the buffer is becoming visible in the
" passed in window.
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
python3 << endpython
preparePythonPath()
import mytools.buffer_manager as buffer_manager
window_id = vim.eval("""win_getid()""")
buffer_id = vim.eval("""bufnr()""")
try:
    buffer_manager.BufferManager.add_buffer(window_id, buffer_id)
except:
    print("Failed..")
endpython
endfunction


function! vim_my_tools#RemoveBuffer(buffer_id)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Removes the buffer_id with the buffers for the window_id.
"
" Meant to be called when the buffer is removed from the memory.
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
python3 << endpython
preparePythonPath()
import mytools.buffer_manager as buffer_manager
try:
    buffer_manager.BufferManager.remove_buffer(buffer_id)
except:
    print("Failed..")
endpython
endfunction

function! vim_my_tools#ShowNextBuffer()
python3 << endpython
preparePythonPath()
import mytools.buffer_manager as buffer_manager
window_id = vim.eval("""win_getid()""")
try:
    while True:
        buffer_id = vim.eval("""bufnr()""")
        b = buffer_manager.BufferManager.get_next_buffer(window_id, buffer_id)
        exists = int(vim.eval(f"buflisted({b})"))
        if exists:
            vim.command(f"buffer {b}")
            break
        else:
            print("Removing buffer: " + str(b))
            buffer_manager.BufferManager.remove_buffer(b)
except Exception as ex:
    print("Failed to show next buffer: " + str(ex))
endpython
endfunction

function! vim_my_tools#ShowPreviousBuffer()
python3 << endpython
preparePythonPath()
import mytools.buffer_manager as buffer_manager
window_id = vim.eval("""win_getid()""")
try:
    while True:
        buffer_id = vim.eval("""bufnr()""")
        b = buffer_manager.BufferManager.get_previous_buffer(window_id, buffer_id)
        exists = int(vim.eval(f"buflisted({b})"))
        if exists:
            vim.command(f"buffer {b}")
            break
        else:
            buffer_manager.BufferManager.remove_buffer(b)
except Exception as ex:
    print("Failed to show previous buffer: " + str(ex))
endpython
endfunction


function! vim_my_tools#ListBuffersForActiveWindow()
python3 << endpython
preparePythonPath()
import mytools.buffer_manager as buffer_manager
window_id = vim.eval("""win_getid()""")
current_buffer_id = vim.eval("""bufnr()""")
buffer_ids = buffer_manager.BufferManager.get_buffers(
    window_id, current_buffer_id
)
try:
    lines = []
    for buffer_id in buffer_ids:
        exists = int(vim.eval(f"buflisted({buffer_id})"))
        if exists:
            buffer_name = vim.eval(f"bufname({buffer_id})")
            lines.append(f"{buffer_name} ({buffer_id})")
        else:
            buffer_manager.BufferManager.remove_buffer(buffer_id)
    buffers_str = '\n'.join(lines)
    vim.command(f"""echo "{buffers_str}" """)
except Exception as ex:
    print("Failed to show previous buffer: " + str(ex))
endpython
endfunction


function! vim_my_tools#ScratchPad()
" Open a scratch window
let name="scratch-pad"
let windowNr = bufwinnr(name)
if windowNr > 0
    execute windowNr 'wincmd w'
else
    execute "sp ". name
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile
endif
endfunction
