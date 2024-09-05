
& "$HOME/virtualenvs/vmware/Scripts/python.exe" -c @"
import requests
import urllib3
from vmware.vapi.vsphere.client import create_vsphere_client
from com.vmware.vcenter_client import VM
from com.vmware.vcenter.vm_client import Power

session = requests.session()
session.verify = False
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)
client = create_vsphere_client(server='10.10.0.245', username='uri.london@vsphere.local', password='createFile64!', session=session)

vm_list = [vm for vm in client.vcenter.VM.list() if vm.name.startswith('wvpn-dev-')]
for v in vm_list:
    state = client.vcenter.vm.Power.get(v.vm).state
    print(f'{v.name}: {state}')
    if state == Power.State.POWERED_OFF:
        print(f'- powering on ...')
        client.vcenter.vm.Power.start(v.vm)
"@
