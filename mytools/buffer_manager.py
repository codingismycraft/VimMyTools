"""Maintains the order of buffers for each Vim window.

This utility facilitates switching buffers in the sequence they were opened,
as Vim inherently stores buffers in a non-deterministic order. Consequently,
changing buffers can become cumbersome, often requiring multiple presses of
'bn' or manual selection using 'b name<tab>'. This tool simplifies buffer
switching by preserving and managing the original order of opened buffers.
"""


class BufferManager:
    """Manages buffers across different windows using class methods.

    :cvar dict _buffers_per_window: Stores buffer lists keyed by window ID.
    """

    _buffers_per_window = {}

    @classmethod
    def clear(cls):
        """Removes all buffers and windows."""
        cls._buffers_per_window = {}

    @classmethod
    def count_windows(cls):
        """Counts the number of windows managed by the class.

        :returns: The number of windows.
        :rtype: int
        """
        return len(cls._buffers_per_window)

    @classmethod
    def count_buffers(cls, window_id):
        """Counts the number of buffers associated with a given window ID.

        :param int window_id: The ID of the window to query.

        :returns: The number of buffers found.
        :rtype: int

        :raises: ValueError
        """
        if window_id not in cls._buffers_per_window:
            raise ValueError(f"Window id {window_id} not found.")
        buffers = cls._buffers_per_window[window_id]
        return len(buffers)

    @classmethod
    def add_buffer(cls, window_id, buffer_id):
        """Adds a buffer to the specified window's buffer list.

        :param int window_id: Identifier for the window.
        :param int buffer_id: Identifier for the buffer to be added.
        """
        if window_id not in cls._buffers_per_window:
            cls._buffers_per_window[window_id] = []
        if buffer_id not in cls._buffers_per_window[window_id]:
            cls._buffers_per_window[window_id].append(buffer_id)

    @classmethod
    def remove_window(cls, window_id):
        """Removes a window from the class's tracking by its ID.

        :param int window_id: The ID of the window to remove.
        """
        if window_id in cls._buffers_per_window:
            del cls._buffers_per_window[window_id]

    @classmethod
    def remove_buffer(cls, buffer_id):
        """Removes a buffer from class storage by its ID.

        :param int buffer_id: The ID of the buffer to remove.
        """
        for _, v in cls._buffers_per_window.items():
            if buffer_id in v:
                v.remove(buffer_id)

    @classmethod
    def get_next_buffer(cls, window_id, current_buffer_id):
        """Get the next buffer ID in the sequence for a given window.

        :param int window_id: The ID of the window to query buffers from.

        :param int current_buffer_id: The current buffer ID to find the next
        one.

        :returns: The buffer ID that follows the current buffer ID.
        :rtype: int

        :raises: ValueError
        """
        buffers = cls._buffers_per_window.get(window_id)
        if not buffers:
            raise ValueError(f"Window id {window_id} not BufferManager.")
        if current_buffer_id not in buffers:
            raise ValueError(f"Non existing buffer id {current_buffer_id}.")
        pos = buffers.index(current_buffer_id)
        next_pos = pos + 1
        if next_pos >= len(buffers):
            next_pos = 0
        return buffers[next_pos]


    @classmethod
    def get_previous_buffer(cls, window_id, current_buffer_id):
        """Retrieve the previous buffer ID in the given window's buffer list.

        :param int window_id: The ID of the window to search buffers in.

        :param int current_buffer_id: The current buffer ID to find the
        previous one.

        :returns: The buffer ID of the previous buffer in the list.
        :rtype: int

        :raises: ValueError
        """
        buffers = cls._buffers_per_window.get(window_id)
        if not buffers:
            raise ValueError(f"Window id {window_id} not BufferManager.")
        if current_buffer_id not in buffers:
            raise ValueError(f"Non existing buffer id {current_buffer_id}.")
        pos = buffers.index(current_buffer_id)
        next_pos = pos - 1
        if next_pos < 0:
            next_pos = len(buffers) -1
        return buffers[next_pos]


    @classmethod
    def get_buffers(cls, window_id):
        """Returns the buffer_id for the passed in window_id.

        :param int window_id: The window_id to get the buffers for.

        :returns: A list with the buffer ids for the passed in window.
        :rtype: list

        :raises: ValueError
        """
        buffers = cls._buffers_per_window.get(window_id)
        if not buffers:
            raise ValueError(f"Window id {window_id} not BufferManager.")
        return buffers[:]

    @classmethod
    def get_as_str(cls):
        """Returns the buffers per window as a string.

        :returns: The buffers per window as a string.
        :rtype: str
        """
        desc = []
        for k, v in cls._buffers_per_window.items():
            buffers = ','.join([str(b) for b in v])
            desc.append(f"[ {k}: {buffers} ] ")
        if not desc:
            return "No buffers.."
        return " ".join(desc)


