"""Defines the functionality to interact with the querycrafter server.

Used to build documentation for python code.
"""

import requests

DEFAULT_URL = "http://127.0.0.1:15959"


def make_post_request(data, url=None, max_line_length=None):
    """Sends an HTTP POST request to a specific hostname and address.

    :param dict data: The json to be sent in the POST request.
    :param str url: The URL to use.
    :param int max_line_length: The max_line_length for the docstr.

    :returns: Response object from the POST request.
    """
    url = url or DEFAULT_URL
    payload = {
        "text": data
    }
    if max_line_length:
        payload["max_line_length"] = max_line_length

    try:
        response = requests.post(url, json=payload, timeout=10)
        response.raise_for_status()  # Raise an exception for HTTP errors
        return response.text
    except requests.exceptions.RequestException as e:
        print(f"An error occurred: {e}")
        return None
