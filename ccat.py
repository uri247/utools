import sys
from Tkinter import Tk
import os


fname = sys.argv[1]
print fname

os.system( 'vim ' + fname );

f = open( fname, 'r' )
txt = f.read()
path = ''.join(txt.splitlines())

# Write search path to clipboard using Tk
r = Tk()
r.withdraw()
r.clipboard_clear()
r.clipboard_append(path)
r.destroy()


# Open the System control panel
os.system( 'sysdm.cpl' )


