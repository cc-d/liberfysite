#!/usr/bin/env python3
import time
import logging
import os
import requests
import re
import json
import sys
from requests.exceptions import RequestException
from os.path import abspath, join, dirname
from urllib.parse import urlparse
from time import sleep, time

SITE_URLS = (
    'https://life.liberfy.ai',
    'https://liberfy.ai',
    'https://open2fa.liberfy.ai',
)


class Site:
    url: str
    logfile: str
    lines: list[str]

    def __init__(self, url: str):
        _up = urlparse(url)

        self.url = url
        self.logfile = join(
            dirname(abspath(__file__)), urlparse(url).netloc + '.log'
        )
        if not os.path.exists(self.logfile):
            open(self.logfile, 'w').close()

        self.logger = logging.getLogger(urlparse(url).netloc)

        with open(self.logfile, 'r') as f:
            self.lines = f.readlines()

    def poll(self):
        start = time()

        try:
            r = requests.get(self.url)
            end = int((time() - start) * 1000)
            _logmsg = f'{r.status_code} {end}ms'

        except requests.exceptions.RequestException as e:
            print('Error:', e)
            end = int((time() - start))
            _logmsg = f'-1 {end}ms'

        _logmsg = f'{time()} {_logmsg}'

        with open(self.logfile, 'a') as f:
            f.write(_logmsg + '\n')
        self.lines.append(_logmsg)
        return _logmsg

    def get_stats(self):
        _avgs = {'error': 0, 'ok': 0, 'notok': 0, 'avg': 0}
        latencies = []
        for line in self.lines:
            l = line.split()

            if l[1] == '-1':
                _avgs['error'] += 1
            elif l[1] == '200':
                _avgs['ok'] += 1
                latencies.append(int(l[2][:-2]))
            else:
                _avgs['notok'] += 1
                latencies.append(int(l[2][:-2]))

        _avgs['avg'] = round(sum(latencies) / len(self.lines), 2)
        return _avgs


def main():
    sites = [Site(url) for url in SITE_URLS]

    for site in sites:
        print(site.poll())

    stats = {site.url: site.get_stats() for site in sites}
    print(stats)

    if sys.argv[1]:
        with open(sys.argv[1], 'w') as f:
            f.write(f'const stats = {json.dumps(stats)};')


if __name__ == "__main__":
    main()
