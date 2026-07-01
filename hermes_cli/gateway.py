"""Gateway subcommand stub for Hermes Lite.

The full gateway (multi-platform messaging) has been removed in the lite
version. This stub preserves the module interface so that imports don't
break, while providing a clear message to users.
"""

import sys


def gateway_command(args):
    """Print a message that the gateway is not available in lite version."""
    print(
        "The 'hermes gateway' command is not available in the lite version.\n"
        "The lite version only supports local CLI and TUI interfaces.\n"
        "For multi-platform messaging, use the full Hermes Agent.",
        file=sys.stderr,
    )
    return 1


def _gateway_stub():
    """Internal stub for any other gateway CLI functions."""
    pass
