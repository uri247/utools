import json
import os
import base64


def old_method():
    try:
        fn = os.path.join(os.environ['APPDATA'], 'Dropbox', 'info.json')
        with open(fn) as f:
            d = json.load(f)
        return d['personal']['path']
    except IOError:
        return None


def new_method():
    try:
        fn = os.path.join(os.environ['LOCALAPPDATA'], 'Dropbox', 'host.db')
        with open(fn, 'r') as f:
            data = f.read()
        dir_encoded = data.split()[1]
        dir = base64.b64decode(dir_encoded).decode('utf-8')
        return dir
    except FileNotFoundError:
        return None


def main():
    dbox_folder = None

    if dbox_folder is None:
        dbox_folder = old_method()

    if dbox_folder is None:
        dbox_folder = new_method()

    if dbox_folder is None:
        dbox_folder = 'no dropbox'

    print(dbox_folder)

if __name__ == '__main__':
    main()
