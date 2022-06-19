import re
from typing import Any

from sys_fetchers.shared import get_icon_from_stages, get_value_from_cmd


volume_cmd = ["amixer", "sget", "Master"]
volume_value_regexp = re.compile(r"\[(\d?\d?\d?)%\]")
volume_status_regexp = re.compile(r"\[(on|off)\]")
volume_muted = 'ﱝ' # nf-mdi-volume_mute
volume_stages = {
    0:  '', # nf-fa-volume_off
    30: '', # nf-fa-volume_down
    60: '', # nf-fa-volume_up
}

def get_volume() -> dict[str, Any]:
    value = int(get_value_from_cmd(volume_cmd, volume_value_regexp))
    is_muted = get_value_from_cmd(volume_cmd,volume_status_regexp) == 'off'
    icon = volume_muted if is_muted else get_icon_from_stages(value, volume_stages)
    data = {
        'value': value,
        'is_muted': is_muted,
        'icon': icon, 
    }
    return data
