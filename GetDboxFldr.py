import json
import os


def old_method():
    try:
        fn = os.path.join(os.environ['APPDATA'], 'Dropbox', 'info.json')
        with open(fn) as f:
            d = json.load(f)
        return d['personal']['path']
    except IOError:
        return None


def new_method():
    fn = os.path.join(os.environ['LOCALAPPDATA'], 'Dropbox', 'host.db')
    with open(fn, 'r') as f:
        data = f.read()
    return data.split()[1].decode('base64')


def main():
    dbox_folder = None

    if dbox_folder is None:
        dbox_folder = old_method()

    if dbox_folder is None:
        dbox_folder = new_method()

    if dbox_folder is None:
        dbox_folder = 'no dropbox'

    print dbox_folder

if __name__ == '__main__':
    main()
