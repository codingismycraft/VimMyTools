# VimMyTools

VimMyTools - Streamline Python Development in Vim

---

[![LICENCE](https://img.shields.io/badge/LICENCE-VimMyTools-green?style=flat&link=https://github.com/codingismycraft/VimMyTools/blob/main/LICENSE)](https://github.com/codingismycraft/VimMyTools/blob/main/LICENSE)


## Contents

1. [Introduction](#introduction)
2. [Installation](#installation)
3. [Configuration](#configuration)
4. [Key Mappings](#key-mappings)
    - [4.1. `<Leader>r` Mapping](#41-leaderr-mapping)
    - [4.2. `<Leader>t` Mapping](#42-leadert-mapping)
    - [4.3. `<Leader>b` Mapping](#43-leaderb-mapping)
    - [4.4. Buffer Navigation Keybindings](#44-buffer-navigation-keybindings)
        - [4.4.1. `<C-n>`: Show Next Buffer](#441-c-n-show-next-buffer)
        - [4.4.2. `<C-b>`: Show Previous Buffer](#442-c-b-show-previous-buffer)
        - [4.4.3. `<C-a>`: List Buffers for Active Window](#443-c-a-list-buffers-for-active-window)
5. [Commands](#commands)
6. [License](#license)
7. [Contact Information](#contact-information)

---

## Introduction

VimMyTools is a Vim plugin designed to streamline the workflow for Python
development. It provides convenient key mappings for:

- Running Python scripts and test suites directly from Vim.
- Opening files referenced in error tracebacks.
- Generating docstrings for Python functions, methods, and classes.
- Enhanced buffer management per window.

By automating these tasks, VimMyTools enhances productivity and eases
navigation within Python projects.

---

## Installation

**Using a Plugin Manager:**

- **vim-plug:**

  Add the following line to your `vimrc` or `init.vim`:

  ```vim
  Plug 'codingismycraft/VimMyTools/VimMyTools'
  ```

  Then, run `:PlugInstall` in Vim.

- **Vundle:**

  Add:

  ```vim
  Plugin 'codingismycraft/VimMyTools/VimMyTools'
  ```

  Then, run `:PluginInstall`.

- **Pathogen:**

  Clone the repository into your `bundle` directory:

  ```bash
  git clone https://github.com/codingismycraft/VimMyTools/VimMyTools.git ~/.vim/bundle/VimMyTools
  ```

**Manual Installation:**

1. Download or clone the VimMyTools plugin repository.
2. Copy the contents to your `.vim` directory (`~/.vim/`).

---

## Configuration

### Set Python Interpreter

By default, VimMyTools uses the `python` command available in your system path. To specify a different Python interpreter, add the following line to your `vimrc` or `init.vim`:

```vim
let g:python_interpreter = 'python3.9'
```

Replace `'python3.9'` with the Python interpreter version you wish to use.

### Requirements for Testing

- **Pytest** must be installed and available if you intend to run tests. Install Pytest via pip:

  ```bash
  pip install pytest
  ```

---

## Key Mappings

VimMyTools introduces several key mappings to enhance your Python development experience.

### 4.1. `<Leader>r` Mapping

**Description:**

- Executes Python scripts or test suites directly from Vim.

**Mode:**

- Normal mode

**Default Mapping:**

```vim
nnoremap <Leader>r :call VimMyTools#RunSelectedScript()<CR>
```

**Features:**

- Automatically detects if the current file is a test or a regular script.
- Runs the test under the cursor, the entire test suite, or executes the script.
- Displays output within Vim for easy access and review.

**Usage:**

- **Run Current Python File:**

  In Normal mode, press `<Leader>r` to execute the current Python file.

- **In Test Files:**

  - If the cursor is on a test function or method, pressing `<Leader>r` will run that specific test.
  - If not on a specific test, it will run the entire test suite in the file.

- **In Regular Python Files:**

  - Executes the entire script.

**Examples:**

- **Running a script:**

  Open `script.py`, then press `<Leader>r`.

- **Running a specific test:**

  Open `test_module.py`, place the cursor on `def test_example():`, then press `<Leader>r` to run only `test_example`.

### 4.2. `<Leader>t` Mapping

**Description:**

- Opens the file referenced by the line under the cursor, especially useful for navigating error tracebacks.

**Mode:**

- Normal mode

**Default Mapping:**

```vim
nnoremap <Leader>t :call VimMyTools#OpenFile()<CR>
```

**Supported Formats:**

1. **Python Traceback:**

   ```
   File "/path/to/file.py", line 42, in function_name
   ```

2. **Quickfix List with `:copen`:**

   ```
   file.py|42| Error message here
   ```

3. **Pytest Command Line Output:**

   ```
   file.py:42: AssertionError
   ```

**Usage:**

- Place the cursor over a line that matches one of the supported formats.
- Press `<Leader>t` to open the file and jump to the specified line.

**Example:**

- After running tests, you see:

  ```
  File "/home/user/project/module.py", line 10, in func
  ```

  Place the cursor on this line and press `<Leader>t` to open `module.py` at line 10.

### 4.3. `<Leader>b` Mapping

**Description:**

- Generates a docstring template for the Python function, method, or class under the cursor.

**Mode:**

- Normal mode

**Default Mapping:**

```vim
nnoremap <silent><Leader>b :call VimMyTools#MakeDocStr()<CR>
```

**Features:**

- Writes the docstring to the unnamed register (`"0`).
- Copies the created docstring to the system clipboard (`"*`), allowing you to paste it elsewhere.

**Usage:**

- Place the cursor on the line of a function, method, or class definition.
- Press `<Leader>b` to generate the docstring.
- The docstring is now available for pasting.

**Example:**

- With the cursor on:

  ```python
  def calculate_area(radius):
  ```

  Press `<Leader>b`, and then paste to insert:

  ```python
  def calculate_area(radius):
      """
      Calculate the area of a circle given its radius.

      :param radius: The radius of the circle.
      :type radius: float
      :return: The area of the circle.
      :rtype: float
      """
  ```

### 4.4. Buffer Navigation Keybindings

VimMyTools enhances buffer management by keeping track of buffers per window in the order they were opened.

**Auto Commands:**

```vim
autocmd! BufWinEnter * call VimMyTools#AddBuffer()
autocmd! WinNew * call VimMyTools#AddBuffer()
```

#### 4.4.1. `<C-n>`: Show Next Buffer

**Default Mapping:**

```vim
nnoremap <C-n> :call VimMyTools#ShowNextBuffer()<CR>
```

**Usage:**

- In Normal mode, press `<C-n>` to switch to the next buffer in the list for the current window.

#### 4.4.2. `<C-b>`: Show Previous Buffer

**Default Mapping:**

```vim
nnoremap <C-b> :call VimMyTools#ShowPreviousBuffer()<CR>
```

**Usage:**

- In Normal mode, press `<C-b>` to switch to the previous buffer in the list
  for the current window.

#### 4.4.3. `<C-a>`: List Buffers for Active Window

**Default Mapping:**

```vim
nnoremap <C-a> :call VimMyTools#ListBuffersForActiveWindow()<CR>
```

**Usage:**

- In Normal mode, press `<C-a>` to display a list of buffers associated with
  the current window.

**Note:**

- These mappings are designed to navigate buffers based on the order they were
  opened and accessed, providing an IDE-like experience.

---

## Commands

VimMyTools provides the following commands through its mappings:

- `VimMyTools#RunSelectedScript()`

  - Executes the current Python script or test.

- `VimMyTools#OpenFile()`

  - Opens a file and jumps to a specific line based on the text under the
    cursor.

- `VimMyTools#MakeDocStr()`

  - Generates a Python docstring for the function, method, or class under the
    cursor.

- `VimMyTools#AddBuffer()`

  - Adds the current buffer to the window's buffer list.

- `VimMyTools#ShowNextBuffer()`

  - Switches to the next buffer in the window's buffer list.

- `VimMyTools#ShowPreviousBuffer()`

  - Switches to the previous buffer in the window's buffer list.

- `VimMyTools#ListBuffersForActiveWindow()`

  - Lists all buffers associated with the current window.

---

## License

VimMyTools is open-source software licensed under the
GNU GENERAL PUBLIC LICENSE License.

---

## Contact Information


**Email:**

<codingismycraft@gmail.com>

**GitHub Repository:**

[https://github.com/codingismycraft/VimMyTools/VimMyTools](https://github.com/codingismycraft/VimMyTools/VimMyTools)

For any questions, issues, or contributions, please feel free to reach out or
submit an issue on GitHub.

---


**To read the introduction:**

```vim
:help VimMyTools
```

**To learn about the `<Leader>r` mapping:**

```vim
:help VimMyTools-mapping-leader-r
```

**To see all key mappings:**

```vim
:help VimMyTools-key-mappings
```

### Customizing Key Mappings

If you prefer to use different key mappings, you can disable the default
mappings and set your own.

**Disable Default Mappings:**

Add the following line to your `vimrc`:

```vim
let g:VimMyTools_no_mappings = 1
```

**Set Custom Mappings:**

After disabling the defaults, define your custom mappings:

```vim
nnoremap <YourKey> :call VimMyTools#RunSelectedScript()<CR>
nnoremap <YourKey> :call VimMyTools#OpenFile()<CR>
nnoremap <YourKey> :call VimMyTools#MakeDocStr()<CR>
nnoremap <YourKey> :call VimMyTools#ShowNextBuffer()<CR>
nnoremap <YourKey> :call VimMyTools#ShowPreviousBuffer()<CR>
nnoremap <YourKey> :call VimMyTools#ListBuffersForActiveWindow()<CR>
```

**Example:**

```vim
" Disable default mappings
let g:VimMyTools_no_mappings = 1

" Custom mappings
nnoremap <Leader>p :call VimMyTools#RunSelectedScript()<CR>
nnoremap <Leader>o :call VimMyTools#OpenFile()<CR>
nnoremap <Leader>d :call VimMyTools#MakeDocStr()<CR>
nnoremap <Leader>n :call VimMyTools#ShowNextBuffer()<CR>
nnoremap <Leader>b :call VimMyTools#ShowPreviousBuffer()<CR>
nnoremap <Leader>a :call VimMyTools#ListBuffersForActiveWindow()<CR>
```

---

## Final Remarks

This documentation provides users with all the necessary information to install, configure, and use VimMyTools effectively. Ensure that the documentation stays updated with any changes or new features added to the plugin.

Feel free to customize and expand upon this documentation to suit your needs.

---

*vim:tw=78:ts=8:ft=help:norl:*
