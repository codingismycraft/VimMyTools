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
