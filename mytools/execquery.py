#!/usr/bin/env python3
"""Executes a Chat query.

This program must be available to the execution path for the process that will
be used to make the chat request to the query-crafter server (typicall this
process will be a pluggin used by either vim, pycharm or any other editor or
IDE).

This program will use the text that exists in the clipboard and send it to the
querycrafter while the returned value is copied to the cliboard as the returned
value.

If needed you can pass a log file in the command line as the first argument
which will cause loggin messages to be logged in this file.

Requires:
pip install pyperclip
sudo apt-get install xclip
"""

import json
import logging
import os
import pathlib
import sys

import requests
import pyperclip

_DEFAULT_URL = "http://127.0.0.1:15959"

_CURRENT_DIR = os.path.dirname(os.path.realpath(__file__))


def get_url():
    """Returns the url of the QueryCrafter server to use.

    Uses the QUERYCRAFTER_HOST value from the local .config.json file, if
    available. Otherwise, defaults to the standard host.

    :returns: The URL for the QueryCrafter server.
    :rtype: str
    """
    config_filepath = os.path.join(_CURRENT_DIR, ".config.json")
    try:
        with open(config_filepath) as fin:
            settings = json.load(fin)
        return settings["QUERYCRAFTER_HOST"]
    except (BaseException, Exception):
        return _DEFAULT_URL


def main():
    """Sends an HTTP POST request to a specific hostname and address.

    The text to send must already by in the system clipboard while the returned
    value is also copied to the clipboard as well.
    """
    logger = None
    if len(sys.argv) >= 2:
        log_filename = sys.argv[1]
    else:
        home_dir = pathlib.Path.home()
        log_filename = os.path.join(home_dir, "execquery.log")

    logging.basicConfig(
        filename=log_filename,
        format='%(asctime)s,%(msecs)d %(name)s %(levelname)s %(message)s',
        datefmt='%H:%M:%S',
        level=logging.INFO
    )
    logger = logging.getLogger(__name__)

    data = pyperclip.paste()
    if logger:
        logger.info("Processing text: %s", str(data))
    try:
        url = get_url()
        payload = {
            "text": data
        }

        response = requests.post(url, json=payload, timeout=210)
        response.raise_for_status()
        pyperclip.copy(str(response.text))
        if logger:
            logger.info("Returning value: %s", str(response.text))
    except Exception as e:
        if logger:
            logger.exception(e)
        sys.exit(-1)


if __name__ == '__main__':
    main()
