# Uri's PowerShell profile
#
# Use this file by creating a symbolic link from where PowerShell is looking for it, to this file:
#
# New-Item -Type SymbolicLink -Path $PROFILE.CurrentUserAllHosts -Value C:\usr\utools\profile.ps1


Set-Alias -Name tl -Value tasklist
Set-Alias -Name tk -Value taskkill


Set-Alias -Name ww -Value "$env:ProgramFiles\Microsoft Office\root\Office16\WINWORD.EXE"
Set-Alias -Name xl -Value "$env:ProgramFiles\Microsoft Office\root\Office16\EXCEL.EXE"
Set-Alias -Name pp -Value "$env:ProgramFiles\Microsoft Office\root\Office16\POWERPNT.EXE"
Set-Alias -Name ol -Value "$env:ProgramFiles\Microsoft Office\root\Office16\OUTLOOK.EXE"

Set-Alias -Name cutenv -Value "$env:USERPROFILE/virtualenvs/cut/Scripts/activate.ps1"
Set-Alias -Name wbg64 -Value "C:\Program Files (x86)\Windows Kits\10\Debuggers\x64\windbg.exe"
Set-Alias -Name wbg32 -Value "C:\Program Files (x86)\Windows Kits\10\Debuggers\x86\windbg.exe"


function make-link ($target, $link) {
    New-Item -Path $link -ItemType SymbolicLink -Value $target
}

function chrm  { 
    Start-Process -NoNewWindow -FilePath "$env:ProgramFiles\Google\Chrome\Application\chrome.exe"
}

function uchrm { 
    Start-Process -NoNewWindow "$env:ProgramFiles\Google\Chrome\Application\chrome.exe" -ArgumentList "--user-data-dir=C:\Users\uri\.uchrm\"
}

function ff ($pattern) {
    Get-ChildItem -Name -Recurse -Filter $pattern
}
