import _winreg

servers = [
    ('qa', 'qa.watchdox.com'),
    ('srv30', 'srv30.watchdox.com')
]

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

short_name, server_name = servers[choice]

regkey = _winreg.OpenKey( _winreg.HKEY_CURRENT_USER, r'Software\WatchDox\OfficePlugin', 0, _winreg.KEY_WRITE )
_winreg.SetValueEx( regkey, 'ServerURL_Hidden', 0, _winreg.REG_SZ, server_name )

