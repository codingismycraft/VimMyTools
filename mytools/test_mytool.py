"""Tests the make_python_exec_line module."""

import unittest

import tempfile
import os

from . mytools import get_exec_target, is_testing_script, get_filename_and_line


class TestGetFilenameAndLine(unittest.TestCase):
    """Tests the get_filename_and_line function."""

    INVALID_LINES = [
        'line 3, in <module>',  # Missing the "File" keyword and file path
        'File "/home/user_name/junk/junk.py", not a number',  # Missing line
        '',  # Completely empty input
        'This is just some random text with no correct format',  # Invalid
        'File "some_file.py"',  # Missing line number
        'File , line 3',  # Missing file path
        '"junk.py", line 3',  # Missing the "File" keyword
        'File "junk.py", in <module>',  # Missing the line number
        'File "/home/user_name/junk/junk.py", line',  # Not a line number
        'File "/home/user_name/junk/junk.py line 3',  # Missing comma after filename
        'File "/home/user_name/junk/junk.py", line abc ',  # Invalid line
    ]

    def test_successfull_call(self):
        """Test calling get_filename_and_line successfully."""
        line = 'File "/home/user_name/junk/junk.py", line 321, in <module>'
        path, line = get_filename_and_line(line)
        expected_path = "/home/user_name/junk/junk.py"
        expected_line = 321
        self.assertEqual(path, expected_path)
        self.assertEqual(line, expected_line)

    def test_successfull_call_pytest_format(self):
        """Tests test succesful call using pytest format."""
        line = "test_mytool.py|30|"
        path, line = get_filename_and_line(line)
        expected_path = "test_mytool.py"
        expected_line = 30
        self.assertEqual(path, expected_path)
        self.assertEqual(line, expected_line)


    def test_not_containing_valid_file(self):
        """Tests calling get_filename_and_line with invalid text."""
        for line in self.INVALID_LINES:
            with self.assertRaises(ValueError):
                get_filename_and_line(line)


class TestFindExecTarget(unittest.TestCase):
    """Tests the make_python_exec_line module."""

    def create_temp_script(self, content):
        """Utility method to create a temporary file with given content."""
        with tempfile.NamedTemporaryFile(
                delete=False, suffix='.py', mode='w',
                encoding='utf-8') as temp_file:
            temp_file.write(content)
        return temp_file.name

    def test_executable_script(self):
        """Tests running the full script."""
        script_content = """
print("This is an executable script")
"""
        script_path = self.create_temp_script(script_content)
        try:
            result = get_exec_target(script_path, 1)
            self.assertEqual(result, script_path)
        finally:
            os.remove(script_path)

    def test_free_test_function(self):
        """Tests running a free testing function."""
        script_content = """
def test_free_function():
    pass
"""
        script_path = self.create_temp_script(script_content)
        try:
            result = get_exec_target(script_path, 2)
            expected = f"{script_path}::test_free_function"
            self.assertEqual(result, expected)
        finally:
            os.remove(script_path)

    def test_method_in_testing_class(self):
        """Tests running a method of a testing class."""
        script_content = """
class TestClass:
    def test_method(self):
        pass
def test_free_function():
    pass
"""
        script_path = self.create_temp_script(script_content)
        try:
            result = get_exec_target(script_path, 3)
            expected = f"{script_path}::TestClass::test_method"
            self.assertEqual(result, expected)

            result = get_exec_target(script_path, 5)
            expected = f"{script_path}::test_free_function"
            self.assertEqual(result, expected)

        finally:
            os.remove(script_path)

    def test_method_in_regular_class(self):
        """Tests running a method of a testing class."""
        script_content = """
class SomeClass:
    def some_method(self):
        pass
"""
        script_path = self.create_temp_script(script_content)
        try:
            result = get_exec_target(script_path, 3)
            expected = f"{script_path}"
            self.assertEqual(result, expected)

            result = get_exec_target(script_path, 5)
            expected = f"{script_path}"
            self.assertEqual(result, expected)

        finally:
            os.remove(script_path)

    def test_nonexistent_line(self):
        """Test passing non existing line number."""
        script_content = """
def test_function():
    pass
"""
        script_path = self.create_temp_script(script_content)
        try:
            # Line number outside the range of the script
            result = get_exec_target(script_path, 10)
            self.assertEqual(result, script_path)
        finally:
            os.remove(script_path)

    def test_is_non_testing_script(self):
        """Tests a script that is an executable."""
        script_content = """
print("This is an executable script")
"""
        script_path = self.create_temp_script(script_content)
        try:
            result = is_testing_script(script_path)
            self.assertFalse(result)
        finally:
            os.remove(script_path)

    def test_testing_script(self):
        """Tests a script that is a test."""
        script_content = """
def test_free_function():
    pass
"""
        script_path = self.create_temp_script(script_content)

        try:
            result = is_testing_script(script_path)
            self.assertTrue(result)
        finally:
            os.remove(script_path)

        script_content = """
class TestClass:
    def test_method(self):
        pass
def test_free_function():
    pass
"""
        script_path = self.create_temp_script(script_content)

        try:
            result = is_testing_script(script_path)
            self.assertTrue(result)
        finally:
            os.remove(script_path)


if __name__ == '__main__':
    unittest.main()
