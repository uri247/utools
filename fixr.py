import os
import re

def run_cmd(cmd):
    h = os.popen( cmd, 'r' )
    return list( h.readlines() )

def get_mac():
    lines = run_cmd( 'ipconfig /all' )
    state = 0
    hmac = ''
    for ln in lines:
        if state == 0:
            if re.search('Connection-specific.*watchdox.com',ln):
                print ln,
                state = 1
        elif state == 1:
            res = re.match('.*Physical Address.*: (.*)$',ln)
            if( res ):
                print ln,
                state = 2
                hmac = res.groups()[0]
        elif state == 2:
            break;
    return hmac


print get_mac()
