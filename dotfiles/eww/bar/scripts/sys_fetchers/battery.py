import re

from dataclasses import asdict, dataclass
from typing import Any
from sys_fetchers.shared import get_icon_from_stages


battery_stages = {
    0:  '', # nf-fa-battery_empty
    10: '', # nf-fa-battery_quarter
    35: '', # nf-fa-battery_half
    75: '', # nf-fa-battery_three_quarters
    95: '', # nf-fa-battery_full
}

def _regexp_from_uevent_var_name(uevent_var: str) -> re.Pattern[str]:
    return re.compile(rf'{uevent_var}=(\w+)')


class BatteryRegexp:
    name = _regexp_from_uevent_var_name('POWER_SUPPLY_NAME')
    status = _regexp_from_uevent_var_name('POWER_SUPPLY_STATUS')
    voltage_now = _regexp_from_uevent_var_name('POWER_SUPPLY_VOLTAGE_NOW')
    current_now = _regexp_from_uevent_var_name('POWER_SUPPLY_CURRENT_NOW')
    charge_full = _regexp_from_uevent_var_name('POWER_SUPPLY_CHARGE_FULL')
    charge_now = _regexp_from_uevent_var_name('POWER_SUPPLY_CHARGE_NOW')
    capacity = _regexp_from_uevent_var_name('POWER_SUPPLY_CAPACITY')
    capacity_level = _regexp_from_uevent_var_name('POWER_SUPPLY_CAPACITY_LEVEL')


@dataclass
class Battery:
    name: str
    status: str
    voltage_now: int
    current_now: int
    charge_full: int
    charge_now: int
    capacity: int
    capacity_level: str


def _get_battery_status(battery_name: str) -> Battery:
    with open(f'/sys/class/power_supply/{battery_name}/uevent', 'r') as f:
        uevent = f.read()

    return Battery(
        name=BatteryRegexp.name.findall(uevent)[0],
        status=BatteryRegexp.status.findall(uevent)[0],
        voltage_now=int(BatteryRegexp.voltage_now.findall(uevent)[0]),
        current_now=int(BatteryRegexp.current_now.findall(uevent)[0]),
        charge_full=int(BatteryRegexp.charge_full.findall(uevent)[0]),
        charge_now=int(BatteryRegexp.charge_now.findall(uevent)[0]),
        capacity=int(BatteryRegexp.capacity.findall(uevent)[0]),
        capacity_level=BatteryRegexp.capacity_level.findall(uevent)[0],
    )


def _calc_time_left(battery: Battery) -> str:
    total = battery.charge_now
    consuming = battery.current_now
    if consuming == 0:
        return ''  # nf-fa-infinity

    hours_left = total / consuming
    seconds_left = round(hours_left * 3600)
    
    h = seconds_left // 3600
    m = (seconds_left % 3600) // 60
    s = seconds_left % 60

    output = ''
    if h != 0:
        output = f'{h}h {m}m {s}s'
    elif m != 0:
        output = f'{m}m {s}s'
    else:
        output = f'{s}s'
    return output


def get_battery(name: str) -> dict[str, Any]:
    battery = _get_battery_status(name)
    data = {
        'value': asdict(battery),
        'icon': get_icon_from_stages(battery.capacity, battery_stages),
        'time_left': _calc_time_left(battery),
    }
    return data
