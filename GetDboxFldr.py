
import json
import os

fn = r'%s\AppData\Roaming\Dropbox\info.json' % os.environ['UserProfile']
with open(fn) as f:
    d = json.load(f)

dbox_fldr = d['personal']['path']

print dbox_fldr
