# VimMyTools

## Introduction
VimMyTools is a Vim plugin designed to enhance the Python development
experience directly from the editor. By providing convenient features for
executing scripts, navigating error tracebacks, and potentially more in the
future, it aims to streamline coding workflows and improve productivity for
Python developers.

## Installation
You can install VimMyTools using your preferred Vim plugin manager. Here are
installation instructions for some popular managers:

## VIm Prerequisites
Ensure that your version of Vim is compiled with Python support enabled. You
can check this by running the following command in Vim:

```vim
:echo has("python3")
```

### Using **vim-plug**
```vim
Plug 'user/VimMyTools'
```

### Using **Vundle**
```vim
Plugin 'user/VimMyTools'
```

### Using **Pathogen**
```sh
git clone https://github.com/user/VimMyTools ~/.vim/bundle/VimMyTools
```

## Configuration
To configure VimMyTools, set your preferred Python interpreter in your `.vimrc`
file:

```vim
let g:python_interpreter = 'python3.X'
```

If this is not specified, the plugin defaults to using `python`, which resolves
to the system's default Python version.

Additionally, ensure that `pytest` is installed and accessible if you plan to
run tests.

## Keybindings

### `<leader>r` Mapping

#### Description
The `<leader>r` keybinding allows you to execute Python scripts or test suites
directly from Vim. It intelligently detects whether the current file is a test
file or a regular script, executing the appropriate command.

#### Functionality
- **Test Files**:
  - Runs the specific test under the cursor or the entire suite if no specific test is highlighted.
- **Non-Test Python Files**:
  - Executes the entire script.
- Displays the output within Vim for easy review.

#### Usage
In Normal mode, place the cursor in the desired context and press `<leader>r`.

#### Mapping Command
```vim
nnoremap <leader>r :call vim_my_tools#RunSelectedScript()<CR>
```

### `<leader>t` Mapping

#### Description
The `<leader>t` keybinding facilitates opening files referenced by the line
under the cursor. This is particularly useful for navigating to the exact
source of exceptions or errors when reviewing tracebacks.

#### Supported Formats
1. **Python Traceback**:
   - Matches typical Python error message format:
     ```
     File '/home/user/junk/junk.py', line 2, in test_junk
     ```

2. **Quickfix List with copen**:
   - Format observed in quickfix lists, often used with pytest:
     ```
     some_module.py|2| ValueError
     ```

3. **Pytest Command Line Output**:
   - Format seen in pytest command line output:
     ```
     some_module.py:42: AssertionError
     ```

#### Usage
Position the cursor on a line with one of the identified formats and press
`<leader>t` to open the file and navigate to the specified line.


### `<leader>b` Mapping

####  Overview:
Writes the doc string for the python function, method or class
that is copied to the "0 register.

The created docstring is copied to the "* register.


#### Mapping Command
```vim
nnoremap <leader>t :call vim_my_tools#OpenFile()<CR>
```

## Future Enhancements
VimMyTools is designed with extensibility in mind. Future updates may introduce
additional features to further support Python developers in their coding
environment.

## Contributing
Contributions are welcome! Please feel free to submit issues or pull requests
to help improve VimMyTools.
