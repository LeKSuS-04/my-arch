#!/bin/python3

import argparse
import json

from time import sleep
from typing import NoReturn
from sys_fetchers.battery import get_battery
from sys_fetchers.brightness import get_brightness
from sys_fetchers.network import get_network
from sys_fetchers.volume import get_volume

help_msg = '''
USAGE:
    volume.py [-t] [-h]
Fetches system data and prints it as json

OPTIONAL ARGUMENTS:
    -t, --interval <FLOAT>  Interval between messages in seconds
                                default: 2.0

    -s, --show              Print information once and exit

    -h, --help              Display this message and exit
'''


def get_data_as_json() -> str:
    data = {
        'battery': get_battery('BAT0'),
        'brightness': get_brightness(),
        'network': get_network(1),
        'volume': get_volume(),
    }
    return json.dumps(data)


def main_loop(interval: float) -> NoReturn:
    while True:
        print(get_data_as_json())
        sleep(interval)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(add_help=False)
    parser.add_argument('-t', '--interval', type=float, default=2.0)
    parser.add_argument('-h', '--help', action='store_true')
    parser.add_argument('-s', '--show', action='store_true')
    args = parser.parse_args()

    if args.help:
        print(help_msg)
        exit()

    if args.show:
        print(get_data_as_json())
        exit()

    main_loop(args.interval)
