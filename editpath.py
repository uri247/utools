import _winreg
import tempfile
import sys
import os
from Tkinter import Tk

#
# read path value from registry
#
pathpath = r"SYSTEM\\CurrentControlSet\\Control\\Session Manager\\Environment"
key = _winreg.OpenKey( _winreg.HKEY_LOCAL_MACHINE, pathpath )
path = _winreg.QueryValueEx( key, "Path" )[0]
fldrs = path.split(';')

#
# echo to the user
#
for fldr in fldrs:
    print fldr

#
# write to temp file
#
fname = tempfile.mktemp()
f = open( fname, 'w' )
for fldr in fldrs:
    f.write( fldr )
    f.write( '\n' )
f.close()

#
# spawn vi, and let the user edit
#
os.system( 'notepad ' + fname )

#
# read it back and echo to the user
#
f = open( fname, 'r' )
fldrs = f.read().splitlines()
print
for fldr in fldrs:
    print fldr

#
# copy to clipboard using Tk
#
path = ';'.join(fldrs)
r = Tk()
r.withdraw()
r.clipboard_clear()
r.clipboard_append(path)
r.destroy()

#
# Open the System control panel
#
os.system( 'sysdm.cpl' )

