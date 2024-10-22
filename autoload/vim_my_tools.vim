let s:plugin_path = expand('<sfile>:p:h')
let s:path_was_added = 0


python3 << endpython

import os
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


function! vim_my_tools#GetGitMakeProg()
" Returns the command that will be passed to the makeprg optionl
let make_program_command = "n/a" 
python3 << endpython
preparePythonPath()
import mytools.mytools as mytools
home_dir = vim.eval("""expand("$HOME")""")
fullpath = vim.eval("""expand("%:p")""").strip()
filepath = os.path.join(home_dir, fullpath)
prg_cmd = mytools.get_program_command()
vim.command(f"let make_program_command='{prg_cmd}'")
endpython
return make_program_command
endfunction

