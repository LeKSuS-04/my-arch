import psutil

from dataclasses import dataclass
from typing import Any, Literal, cast


InterfaceField = Literal['sent', 'recv', 'total']
InterfaceJson = dict[InterfaceField, int]


@dataclass
class Interface:
    sent: int
    recv: int

    @property
    def total(self) -> int:
        return self.sent + self.recv

    def to_json(self) -> InterfaceJson:
        return {
            'sent': self.sent,
            'recv': self.recv,
            'total': self.total,
        }


class InterfaceData(dict[str, Interface]):
    def to_json(self) -> dict[str, InterfaceJson]:
        return {k: v.to_json() for k, v in self.items()}


BYTE_PREFIXES = ['', 'k', 'M', 'G', 'T', 'P', 'E', 'Z', 'Y']
IFACE_PREFIX_ICON_MAPPING = {
    'en': '',  # Ethernet: nf-mdi-ethernet
    'wl': '',  # WLAN: nf-fa-wifi
    'ww': '',  # WWAN: nf-fa-wifi
}
UNKNOWN_IFACE_ICON = '?'
NO_INTERNET_ICON = '' # nf-mdi-close_network

IGNORE_IFACES = [
    'lo',     # loopback is not internet  
    'docker', # neither is docker
]


def _get_stats() -> InterfaceData:
    interfaces: InterfaceData = InterfaceData()
    net = cast(dict[str, psutil._common.snetio], psutil.net_io_counters(pernic=True))

    for name, data in net.items():
        interfaces[name] = Interface(sent=data.bytes_sent, recv=data.bytes_recv)

    return interfaces


def _get_interface_icon(name: str, interface: Interface) -> str:
    if interface.total == 0:
        return NO_INTERNET_ICON

    for prefix, icon in IFACE_PREFIX_ICON_MAPPING.items():
        if name.startswith(prefix):
            return icon

    return UNKNOWN_IFACE_ICON


def _get_per_second(
    old: InterfaceData, new: InterfaceData, update_interval: float
) -> InterfaceData:
    diff: InterfaceData = InterfaceData()
    for name, new_data in new.items():
        if name in old:
            old_data = old[name]

            diff[name] = Interface(
                sent=round((new_data.sent - old_data.sent) / update_interval),
                recv=round((new_data.recv - old_data.recv) / update_interval),
            )
    return diff


def get_active_interface(interfaces: InterfaceData) -> tuple[str, Interface]:
    def iface_cmp(key: str) -> int:
        is_ignored_iface = any(part in key for part in IGNORE_IFACES)
        if is_ignored_iface:
            return 0

        interface = interfaces[key]
        return interface.total

    active_name = max(interfaces, key=iface_cmp)
    return active_name, interfaces[active_name]


stats = _get_stats()
def get_network(interval: float) -> dict[str, Any]:
    global stats

    new_stats = _get_stats()
    diff = _get_per_second(stats, new_stats, interval)
    active_name, active_interface = get_active_interface(diff)
    data = {
        'overall': new_stats.to_json(),
        'diff': diff.to_json(),
        'active_interface': active_interface.to_json(),
        'active_name': active_name,
        'icon': _get_interface_icon(active_name, active_interface),
    }

    stats = new_stats
    return data

