# Uri's PowerShell profile
#
# Use this file by creating a symbolic link from where PowerShell is looking for it, to this file:
#
# New-Item -Type SymbolicLink -Path $PROFILE.CurrentUserAllHosts -Value $HOME\utools\profile.ps1

Set-Alias -Name tl -Value tasklist
Set-Alias -Name tk -Value taskkill


Set-Alias -Name ww -Value "$env:ProgramFiles\Microsoft Office\root\Office16\WINWORD.EXE"
Set-Alias -Name xl -Value "$env:ProgramFiles\Microsoft Office\root\Office16\EXCEL.EXE"
Set-Alias -Name pp -Value "$env:ProgramFiles\Microsoft Office\root\Office16\POWERPNT.EXE"
Set-Alias -Name ol -Value "$env:ProgramFiles\Microsoft Office\root\Office16\OUTLOOK.EXE"

Set-Alias -Name cutenv -Value "$env:USERPROFILE/virtualenvs/cut/Scripts/activate.ps1"
Set-Alias -Name wbg64 -Value "C:\Program Files (x86)\Windows Kits\10\Debuggers\x64\windbg.exe"
Set-Alias -Name wbg32 -Value "C:\Program Files (x86)\Windows Kits\10\Debuggers\x86\windbg.exe"
Set-Alias -Name pc -Value "C:\ThirdParty\Protobuf\v3.6.1\vs2019\x64\debug\bin\protoc.exe"
Set-Alias -Name lex -Value "$HOME\bin\LogExpert.1.9.0\LogExpert.exe"
Set-Alias -Name ll -Value Get-ChildItem

Set-Alias -Option AllScope -Name cd -Value "Push-Location"
Set-Alias -Option AllScope -Name e -Value "Pop-Location"


function ws         { Set-Location $env:USERPROFILE\ws }
function wincli     { Set-Location $env:USERPROFILE\ws\wincli\windowsclient }
function adata      { Set-Location $env:APPDATA }
function ldata      { Set-Location $env:LOCALAPPDATA }
function utoo       { Set-Location $HOME/utools }
function dbox       { Set-Location $HOME/dropbox }
function bt         { Set-Location $HOME/dropbox/bt }
function msh        { Set-Location $HOME/dropbox/Media.Share }


function als () {
    vim $PROFILE.CurrentUserAllHosts
}

function refresh-env {
    . $PROFILE.CurrentUserAllHosts
}

function srv-env {
    . $HOME/ws/srv/server-team-env-setup/srv-env.ps1
}

function cli-env {
    echo "Line: $($MyInvocation.Line)"
    echo "Name: $($MyInvocation.InvocationName)"
    if (($MyInvocation.Line) -and ($MyInvocation.InvocationName -ne '.')) {
        Write-Error "ERROR: This script must invoked with 'dot sourcing'"
        Break
    }
    . $HOME/ws/wincli/windowsclient/tools/scripts/env.ps1
}

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
    Get-ChildItem -Recurse -ErrorAction Continue -Filter $pattern | select FullName
}

function k2svc ($cmd) {
    switch ($cmd) {
        "status" { Get-Service CatoNetworksVPNService }
        "start" { Start-Service CatoNetworksVPNService }
        "stop" { Stop-Service CatoNetworksVPNService }
    }
}

function kdten {
    Start-Process -FilePath "C:\Program Files (x86)\Windows Kits\10\Debuggers\x64\windbg.exe" -ArgumentList "-k com:pipe,port=\\.\pipe\kd1,resets=0,reconnect"
}
    
function bash {
    c:\usr\cygwin64\bin\bash.exe --login
}

function k2key {
    $env:GIT_SSH_COMMAND="ssh -i C:/Users/uri/Dropbox/CatoStuff/KeyStore/uri.london@katonetworks.com/id_rsa"
    Write-Output "GIT_SSH_COMMAND set to: '$env:GIT_SSH_COMMAND'"
}

function ttvfix {
    & C:\Users\uri\virtualenvs\cut\Scripts\python.exe C:\Users\uri\deep-cut\PyGames\ttvfix.py
}
    
function k2gui {
    C:\users\UriLondon\ws\wincli\windowsclient\Product\Debug\CatoClient.exe
}

function glog {
    # & git log -20 --pretty=oneline --abbrev-commit
    & git log -8 --pretty=oneline
}

function vihosts {
    & vim "$env:SystemRoot\System32\drivers\etc\hosts"
}

function Get-TrustedHosts {
    Get-Item WSMan:\localhost\Client\TrustedHosts
}

function Add-TrustedHosts ($host) {
    Set-Item WSMan:\localhost\Client\TrustedHosts -Value $host -Concatenate
}

function save-barbafile {
    Write-Host "Insert password for automation user: "
    $ss = Read-Host -AsSecureString
    $enc = ConvertFrom-SecureString -SecureString $ss
    $enc | Set-Content auto-passwd.txt
}

function read-barbafile {
    $enc = Get-Content .\auto-passwd.txt
    $ss = $enc | ConvertTo-SecureString
    $cred =  New-Object System.Managemwent.Automation.PSCredential -ArgumentList@('Administrator', $ss)
    return $cred
}
    
function Set-Python27 {
    $p = $env:Path.Trim(';') -split ';' | Where-Object { $_ -notmatch 'python' }
    $p += "C:/usr/Python27/Scripts"
    $p += "C:/usr/Python27"
    $env:Path = $p -join ';'
}

function sess-udc {
    # $cred = Get-Credential -UserName Administrator
    $cred = read-barbafile
    $sess = New-PSSession -Credential $cred -ComputerName u-dc
    return $sess
}

echo "Welcome to Uri Shell"
