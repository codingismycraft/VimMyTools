"""Tests the documenter module."""

from . documenter import make_post_request


FUNCTION = """

def divide(i, j):
    if j == 0:
        raise ValueError
    return i/j
"""


def test_successfull_post():
    """Test successfully posting to querycrafter."""
    retrieved = make_post_request(FUNCTION)
    print(retrieved)
