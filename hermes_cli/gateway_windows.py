"""Windows gateway service backend stub for Hermes Lite.

The full gateway (multi-platform messaging) has been removed in the lite
version. This stub preserves the module interface so that imports don't
break on Windows.
"""


def launchd_install(*args, **kwargs):
    """Stub: Windows gateway service installation."""
    return False


def launchd_start(*args, **kwargs):
    """Stub: Windows gateway service start."""
    return False


def launchd_stop(*args, **kwargs):
    """Stub: Windows gateway service stop."""
    return False


def launchd_status(*args, **kwargs):
    """Stub: Windows gateway service status."""
    return False


def launchd_uninstall(*args, **kwargs):
    """Stub: Windows gateway service uninstall."""
    return False
