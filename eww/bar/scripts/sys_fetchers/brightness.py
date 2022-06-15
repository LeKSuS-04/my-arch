import re
from typing import Any

from sys_fetchers.shared import get_icon_from_stages, get_value_from_cmd


brightness_cmd = ["brightnessctl"]
brightness_regexp = re.compile(r"Current brightness: \d+ \((\d+)%\)")
brightness_stages = {
    0:  '', # nf-mdi-brightness_1
    5:  '', # nf-mdi-brightness_2
    20: '', # nf-mdi-brightness_3
    40: '', # nf-mdi-brightness_4
    60: '', # nf-mdi-brightness_5
    80: '', # nf-mdi-brightness_6
    96: '', # nf-mdi-brightness_7
}

def get_brightness() -> dict[str, Any]:
    value = int(get_value_from_cmd(
        cmd=brightness_cmd,
        regexp=brightness_regexp
    ))
    icon = get_icon_from_stages(value, brightness_stages)
    data = {
        'value': value,
        'icon': icon, 
    }
    return data
