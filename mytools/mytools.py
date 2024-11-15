"""Exports utility functions."""

import ast
import os
import re


def get_exec_target(fullpath, linenum):
    """Gets the execution path for the passed in file and linenum.

    Determine the target string for the Vim 'makeprg' setting based on the type
    of Python code at a specific line.

    This function analyzes a Python script to identify whether the line number
    provided corresponds to:

    1. An executable script (default behavior).
    2. A free-standing test function.
    3. A test method within a test class.

    It utilizes the Abstract Syntax Tree (AST) to parse the script and identify
    the appropriate context, returning a string suitable for the 'makeprg'
    setting in Vim. This allows Vim's make command to execute the relevant
    script or test.

    Parameters:
    - fullpath (str): The complete file path of the Python script.
    - linenum (int): The line number in the script where the cursor is
      currently positioned.

    Returns:
    - str: A string representing the execution target:
        - The full path for a standalone script.
        - The full path and function name for a free test function.
        - The full path, class name, and method name for a test method in a
          class.
    """
    with open(fullpath, 'r', encoding='utf-8') as file:
        source = file.read()
    module = ast.parse(source)

    # Track function and class names
    current_class = None
    targeted_function = None
    for node in ast.walk(module):
        if isinstance(node, (ast.FunctionDef, ast.AsyncFunctionDef)):
            # Check if the function node includes the line number
            if node.lineno <= linenum < (
                    node.end_lineno or (node.lineno + len(node.body))):
                targeted_function = node.name
                break
        elif isinstance(node, ast.ClassDef):
            # Check if class node contains the line number
            if node.lineno <= linenum < (
                    node.end_lineno or (node.lineno + len(node.body))):
                current_class = node.name

    if targeted_function and targeted_function.lower().startswith("test"):
        if current_class:
            return f"{fullpath}::{current_class}::{targeted_function}"
        else:
            return f"{fullpath}::{targeted_function}"
    else:
        return fullpath


def is_testing_script(filepath):
    """Determine if the given Python script is a testing script.

    Parameters:
    - filepath (str): The full path to the Python script.

    Returns:
    - bool: True if the script is likely a testing script, False otherwise.
    """
    with open(filepath, 'r', encoding='utf-8') as file:
        source = file.read()

    try:
        tree = ast.parse(source)
    except SyntaxError:
        # If invalid syntax, not necessarily an indicator of test or regular
        return False

    for node in ast.walk(tree):
        # Check for test-related imports
        if isinstance(node, ast.Import) or isinstance(node, ast.ImportFrom):
            for alias in node.names:
                if alias.name in {'unittest', 'pytest', 'nose'}:
                    return True

        # Check function definitions
        if isinstance(node, ast.FunctionDef):
            if node.name.startswith('test_'):
                return True

    return False


def get_filename_and_line(line):
    """Extracts the filepath and the line from the passed in line.

    Used to jump to the file and the line that is causing a python exception.
    Expects the standard format that is used from python tracebacks, example:

    File "/home/john/junk/junk.py", line 3, in <module>

    :param str line: The line of text to extract the fullpath; if no path is
    found then a ValueError exception is raised.

    :returns: A tuple consisting of the filepath and line number.
    :rtype: Tuple [str, int]

    :raises: ValueError
    """
    log_entry = line
    pattern = r'File "(.*?)", line (\d+)'
    match = re.search(pattern, log_entry)
    if match:
        full_path = match.group(1)
        if not os.path.isfile(full_path):
            raise ValueError
        line_number = match.group(2)
        line_number = int(line_number)
        return full_path, line_number
    else:
        raise ValueError
