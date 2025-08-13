let s:plugin_path = expand('<sfile>:p:h')
let s:path_was_added = 0

python3 << endpython

import os
import subprocess
import sys
import vim

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
