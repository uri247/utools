import json
import os

fn = r'%s\AppData\Roaming\Dropbox\info.json' % os.environ['UserProfile']

if os.path.isfile(fn):
    with open(fn) as f:
        d = json.load(f)
    dbox_fldr = d['personal']['path']

else:
    dbox_fldr = 'no dropbox'

print dbox_fldr
