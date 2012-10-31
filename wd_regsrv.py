r"""A utility to cleanup the WatchDox client installation and register with a new server

This utility will:
- Delete the entire %AppData%\WatchDox folder
- Set the one-time registry key with the server (After asking the user which server he wants to connect 
"""

import _winreg
import os
import shutil

servers = [
    ('qa', 'qa.watchdox.com'),
    ('srv30', 'srv30.watchdox.com')
]


def getServerFromUser():
    "propmt the user list of servers, and get the server he wants to install"

    print "Select the server that you want to register\n"
    for i,srvtpl in enumerate(servers):
        short_name, server_name = srvtpl
        print "{0:-2}. {1}({2})".format(i, server_name, short_name)
    print "{0:2}. Cancel".format( len(servers) )

    print '\n\n'
    choice = raw_input("Your choise: ")
    try:
        choice = int(choice)
    except:
        print "not a choice"
        choice = len(servers)
    
    if choice == len(servers):
        quit()

    return servers[choice]


def setRegistry():
    regkey = _winreg.OpenKey( _winreg.HKEY_CURRENT_USER, r'Software\WatchDox\OfficePlugin', 0, _winreg.KEY_WRITE )
    _winreg.SetValueEx( regkey, 'ServerURL_Hidden', 0, _winreg.REG_SZ, server_name )

def cleanFiles():
    adata = os.environ['APPDATA']
    wddata = adata + 'WatchDox'
    shutil.rmtree( wddata )
        
if __name__ == '__main__':
    short_name, server_name = getServerFromUser()
    setRegistry()
    cleanFiles()
    
