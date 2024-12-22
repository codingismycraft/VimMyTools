"""Tests the BufferManager class."""

import pytest

from . buffer_manager import BufferManager

def test_buffer_management():
    """Tests adding and managing buffers in BufferManager."""
    BufferManager.clear()
    assert BufferManager.count_windows() == 0
    with pytest.raises(ValueError):
        BufferManager.count_buffers(1)

    BufferManager.add_buffer(window_id=1, buffer_id=1)
    assert BufferManager.count_windows() == 1
    assert BufferManager.count_buffers(1) == 1

    BufferManager.add_buffer(window_id=1, buffer_id=2)
    assert BufferManager.count_windows() == 1
    assert BufferManager.count_buffers(1) == 2

    BufferManager.add_buffer(window_id=2, buffer_id=1)

    assert BufferManager.count_buffers(1) == 2
    assert BufferManager.count_buffers(2) == 1

    BufferManager.remove_buffer(1)
    assert BufferManager.count_buffers(1) == 1
    assert BufferManager.count_buffers(2) == 0

    BufferManager.remove_window(1)
    assert BufferManager.count_windows() == 1
    with pytest.raises(ValueError):
        BufferManager.count_buffers(1)


class TestGetNextBuffer:
    """Class to test the get_next_buffer method."""

    def test_walking_empty_list(self):
        """Tests walking an empty list in BufferManager. """
        BufferManager.clear()
        with pytest.raises(ValueError):
            BufferManager.get_next_buffer(1, 1)

    def test_not_existing_buffer(self):
        """Tests the behavior when a non-existing buffer is accessed."""
        BufferManager.clear()
        BufferManager.add_buffer(window_id=1, buffer_id=1)
        with pytest.raises(ValueError):
            BufferManager.get_next_buffer(1, 2)

    def test_single_buffer(self):
        """Tests getting the same buffer as next in single buffer list."""
        BufferManager.clear()
        BufferManager.add_buffer(window_id=1, buffer_id=14)
        retrieved = BufferManager.get_next_buffer(1, 14)
        assert retrieved == 14

    def test_multiple_buffers(self):
        """Tests getting the next buffer."""
        BufferManager.clear()

        buffer_ids = [14, 82, 1, 33, 12]
        for buffer_id in buffer_ids:
            BufferManager.add_buffer(window_id=1, buffer_id=buffer_id)

        for index, buffer_id in enumerate(buffer_ids[:-1]):
            retrieved = BufferManager.get_next_buffer(1, buffer_id)
            expected = buffer_ids[index + 1]
            assert expected == retrieved

        buffer_id = buffer_ids[-1]
        retrieved = BufferManager.get_next_buffer(1, buffer_id)
        expected = buffer_ids[0]
        assert expected == retrieved


class TestGetPreviousBuffer:
    """Class to test the get_previous_buffer method."""

    def test_walking_empty_list(self):
        """Tests walking an empty list in BufferManager. """
        BufferManager.clear()
        with pytest.raises(ValueError):
            BufferManager.get_previous_buffer(1, 1)

    def test_not_existing_buffer(self):
        """Tests the behavior when a non-existing buffer is accessed."""
        BufferManager.clear()
        BufferManager.add_buffer(window_id=1, buffer_id=1)
        with pytest.raises(ValueError):
            BufferManager.get_previous_buffer(1, 2)

    def test_single_buffer(self):
        """Tests getting the same buffer as previous in single buffer list."""
        BufferManager.clear()
        BufferManager.add_buffer(window_id=1, buffer_id=14)
        retrieved = BufferManager.get_previous_buffer(1, 14)
        assert retrieved == 14

    def test_multiple_buffers(self):
        """Tests getting the previous buffer."""
        BufferManager.clear()

        buffer_ids = [14, 82, 1, 33, 12]
        for buffer_id in buffer_ids:
            BufferManager.add_buffer(window_id=1, buffer_id=buffer_id)

        for index, buffer_id in enumerate(buffer_ids[1:], start=1):
            retrieved = BufferManager.get_previous_buffer(1, buffer_id)
            expected = buffer_ids[index - 1]
            assert expected == retrieved

        buffer_id = buffer_ids[0]
        retrieved = BufferManager.get_previous_buffer(1, buffer_id)
        expected = buffer_ids[-1]
        assert expected == retrieved
