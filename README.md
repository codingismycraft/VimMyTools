# VimMyTools

VimMyTools - Streamline Python Development in Vim

---

[![LICENCE](https://img.shields.io/badge/LICENCE-VimMyTools-green?style=flat&link=https://github.com/codingismycraft/VimMyTools/blob/main/LICENSE)](https://github.com/codingismycraft/VimMyTools/blob/main/LICENSE)


## Contents

1. [Installation](#installation)
2. [Running Scrips](#running-scripts)
3. [Open File](#open-file)
4. [Automate documenation](#automate-documentation)
5. [Buffer Navigation](#buffer-navigation)
6. [Scratch Pad](#scratch-pad)

---

## Installation

VimMyTools is a vim plugin adding python utilites and buffer navigation
features to vim.

The preferred method of installation is using `Vundle`. However, other plugin
installers should work fine as well (although they have not been tested). To
install using Vundle, add the following lines to your .vimrc file:

```
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'codingismycraft/VimMyTools'
call vundle#end()
```

## Running Scripts

Press `<leader> r` to execute the current Python script or test.

**Running a Script**

When you press the keybinding mentioned above while editing a regular Python
script, it will execute using the selected Python interpreter.

**Running a Test**

To run tests you must have `pytest` installed on your system.

If the script is a test file, pressing `<leader> r` will initiate a pytest
session. The behavior of the test execution depends on the cursor's position:

- If your cursor is within a specific test (either in a class method or a
  standalone test function), only that test will be run.

- If your cursor is in the global scope, the entire test suite will be
  executed.

**Running from the Command Line Interface (CLI)**

Execution of the script or test can be paused when prompted by `:make`. This
allows you to stop and manually execute the command from the CLI. The relevant
command is conveniently copied to your clipboard for easy pasting and running.


**Setting the Python Interpreter**

By default, VimMyTools uses the `python` command available in your system path.
To specify a different Python interpreter, add the following line to your
`vimrc` or `init.vim`:

```vim
let g:python_interpreter = 'python3.10'
```

Replace `'python3.10'` with the Python interpreter version you wish to use.

---

 ## Open File

Pressing the `<leader>t` key combination activates a plugin functionality
that opens the file referenced by the line under the cursor. This is
especially useful in the context of exception tracebacks. When the cursor
is on a line containing a file path and a line number (as often seen in
error messages) pressing the above combination automatically navigates to
the specified file and jumps to the corresponding line.

**Supported Formats**

 1. Python Traceback

    Recognizable pattern when running Python scripts, typically formatted as:
    ```
    File '/home/user/junk/junk.py', line 2, in test_junk
    ```

 2. Quickfix List with copen:

    Format seen when utilizing the copen command, particularly in conjunction
    with pytest:

    ```
    some_module.py|2| ValueError
    ```

 3. Pytest Command Line Output:

    Format produced when executing pytest from the terminal:

    ```
    some_module.py:42: AssertionError
    ```

 Usage:
 - Place the cursor over a line fitting one of the supported formats.
 - Press <leader>t to trigger the file opening and line jump action.

---

## Automate Documentation

**Requirements**

To automate the creation of doc strings you need to install and run the following service:

`https://github.com/codingismycraft/querycrafter`

You can either run the above service locally or remotely. If running remotely
you will need to create the following file which will allow the pluggin to talk
to it.

`../VimMyTools/mytools/.config.json`

```
{
    "QUERYCRAFTER_HOST": "http://<hostname>:15959"
}
```

If you are running the service locally you do not need any additional
installation since the pluggin will default to your <localhost:15959> when
accessing it.

**Creating the doc string for a function or class**

To create the doc string for a function or a class you are yanking it and then
you are pressing the `<leader>b` key combination and you wait until the `Query
Execution OK` message is printed to vim's output; once this is completed then
you will have the doc string in your clipboard and you will be able to paste it
in the right place.

---
## Buffer Navigation

Each split window is maintaining its own collection of the buffers that were
viewd in it thus we can move back and forward for each window for each buffer
maintaing the same order that the buffer was opened.

`<C-n>` : Moves to the next buffer (or if in last to the first buffer opened).

`<C-b>` : Moves to the previous buffer (or is first to the last buffer opened).

To print the buffers for the current window you can execute the folloing command:

```
:Lsa
```

---

## Scratch Pad

To open a scratch pad window you can execute the following command:

```
:Scratch
```
