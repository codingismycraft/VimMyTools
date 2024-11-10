# VimMyTools

VimMyTools is a simple Vim plugin designed to streamline the workflow for
Python developers. It enables you to run Python scripts and tests directly from
Vim, offering a smoother and more efficient development process.

## Features

- **Run Python Scripts and Tests**: Execute both Python scripts and test suites
  directly from Vim.

- **Context Aware Execution**: Automatically detects if the current buffer is a
  test or regular script and runs it accordingly.

- **Integrated Output**: Displays execution output within Vim for quick and
  easy access.

## Usage

- **Execute**: While in normal mode, press `<leader>r` to run the current Python file.
  - If the file is part of a test suite, it will run the test under the cursor or the entire suite.

  - For non-test Python files, it executes the complete script.

- **Debugging**: Use breakpoints in your code to facilitate debugging during execution.

- **cliboard**: The run command (can be running a python script, a test file or
  a single test) is copied to the clipboard so it can be pasted to a command
  line and run as as stand-alone without having to rely on vim's make
  mechanism.

### How `make` is running and passing command line arguments.

After pressing `<leader>r`, Vim will insert the `make` command into the command
line. You will then have the option to press `Enter` to execute it or `Escape`
to cancel. If you need to include command-line arguments, you can add them at
this stage in the command prompt. Should you press `Escape`, the most recent
`makeprg` will be retained in memory, meaning it will be used if you run the
`make` command again later. You can still provide command-line arguments at
that point if necessary.

## Installation

To install VimMyTools, use a Vim plugin manager like
[vim-plug](https://github.com/junegunn/vim-plug),
[Vundle](https://github.com/VundleVim/Vundle.vim), or
[Pathogen](https://github.com/tpope/vim-pathogen).

### Example with vundle:
```vim
Plugin 'codingismycraft/VimMyTools'
```

After adding the line to your `.vimrc`, run `:PlugInstall` in Vim to install the plugin.

## Configuration

Specify your preferred Python interpreter in your `.vimrc`:

```vim
let g:python_interpreter = 'python3'
```

