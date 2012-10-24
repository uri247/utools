import os
import re

def run_cmd(cmd):
    h = os.popen( cmd, 'r' )
    return list( h.readlines() )

def get_mac():
    lines = run_cmd( 'ipconfig /all' )
    state = 0
    mac = None
    rx0 = re.compile('Connection-specific.*watchdox.com')
    rx1 = re.compile('.*Physical Address.*: (.*)$')
    for ln in lines:
        if state == 0:
            if rx0.search(ln):
                state = 1
        elif state == 1:
            res = rx1.match(ln)
            if( res ):
                state = 2
                mac = res.groups()[0]
        elif state == 2:
            break
    return mac


def get_intf(mac):
    mac = ' '.join(mac.lower().split('-'))
    rx0 = re.compile('Interface List')
    rx1 = re.compile(' *(\d+)\.*' + mac + ' *\..*')
    lines = run_cmd('route print')
    state = 0
    for ln in lines:
        if state == 0:
            if rx0.search(ln):
                state = 1
        elif state == 1:
            res = rx1.match(ln)
            if res:
                state = 2
                intf = res.groups()[0]
        elif state == 2:
            break
    return intf



if __name__ == '__main__':
    mac = get_mac()
    print mac
    intf = get_intf(mac)
    print intf



