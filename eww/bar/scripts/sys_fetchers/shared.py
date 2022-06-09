import subprocess
from typing import Pattern


def get_value_from_cmd(cmd: list[str], regexp: Pattern[str]) -> str:
    cmd_out = subprocess.run(cmd, capture_output=True).stdout.decode()
    matches = regexp.findall(cmd_out)
    return matches[0]


def get_icon_from_stages(value: int, stages: dict[int, str]) -> str:
    def cmp(level: int) -> int:
        d = abs(level - value)
        if level > value:
            return d * 100
        return d

    closest_level = min(stages, key=cmp)
    return stages[closest_level]
