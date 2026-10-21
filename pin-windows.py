#!/usr/bin/python3
"""Enforce app workspace assignments without launching any apps."""
import fcntl
import os
from pathlib import Path
import subprocess
import sys

AERO = '/opt/homebrew/bin/aerospace'
PINS = {'com.openai.codex': '3', 'com.mitchellh.ghostty': '4',
        'com.google.Chrome': '2', 'com.apple.finder': '4',
        'com.hnc.Discord': '5'}
env = {k: v for k, v in os.environ.items() if k not in ('AEROSPACE_WINDOW_ID', 'AEROSPACE_WORKSPACE')}
def run(*args):
    return subprocess.check_output([AERO, *args], text=True, env=env, stderr=subprocess.DEVNULL).strip()
def move(wid, target):
    run('move-node-to-workspace', '--window-id', wid, target)
try:
    if len(sys.argv) == 3 and sys.argv[1] == 'move':
        row = run('list-windows', '--focused', '--format', '%{window-id} %{app-bundle-id} %{workspace}')
        if row:
            wid, app, ws = row.split()
            target = PINS.get(app, sys.argv[2])
            if ws != target:
                move(wid, target)
    else:
        # Concurrent focus notifications share one short-lived sweep.
        with (Path(__file__).parent / '.pin-windows.lock').open('w') as lock:
            try:
                fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
            except BlockingIOError:
                sys.exit(0)
            for row in run('list-windows', '--all', '--format', '%{window-id} %{app-bundle-id} %{workspace}').splitlines():
                wid, app, ws = row.split()
                target = PINS.get(app)
                if target and target != ws:
                    move(wid, target)
except subprocess.CalledProcessError:
    # Windows may close while a focus event is being handled.
    pass
