"""Hermes Gateway - Lite version (session context and config only).

The full gateway (multi-platform messaging) has been removed in the lite
version. This module retains only the general-purpose session context and
config utilities that are shared by CLI, TUI, ACP, and cron.
"""

from .config import GatewayConfig, PlatformConfig, HomeChannel, load_gateway_config
from .session_context import (
    set_session_vars,
    clear_session_vars,
    _redact_approval_command,
)

__all__ = [
    # Config
    "GatewayConfig",
    "PlatformConfig",
    "HomeChannel",
    "load_gateway_config",
    # Session context
    "set_session_vars",
    "clear_session_vars",
    "_redact_approval_command",
]
