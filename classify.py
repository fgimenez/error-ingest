#!/usr/bin/env python3

import json
import subprocess
import sys

def run(input_file):
    with open(input_file, encoding='utf-8') as data_file:
        data = json.load(data_file)

    for item in data['data']:
        output = subprocess.check_output([
            'mongo',
            'report',
            '--eval',
            'db.errors.insert({});'.format(item)
        ])
        print(output)

if __name__ == '__main__':
    if len(sys.argv) > 1:
        sys.exit(run(sys.argv[1]))
    else:
        print("Usage: classify.py json_file")
