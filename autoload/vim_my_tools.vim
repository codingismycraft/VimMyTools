let s:plugin_path = expand('<sfile>:p:h')
let s:path_was_added = 0

python3 << endpython
import vim
import sys
import os

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
try:
    filepath, line = mytools.get_filename_and_line(current_line)
except ValueError:
    vim.vars['vt_filepath'] = ""
    vim.vars['vt_line'] = ""
else:
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
    execute "edit ". a:filepath
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
    print(command)
    vim.command(command)
else:
    print(f"Do not know how to run {filepath}")
endpython
call feedkeys(":make", 'n')
endfunction
