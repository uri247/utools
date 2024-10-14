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
Set-Alias -Name catoenv -Value "$env:USERPROFILE/virtualenvs/cato/Scripts/activate.ps1"
Set-Alias -Name wbg64 -Value "C:\Program Files (x86)\Windows Kits\10\Debuggers\x64\windbg.exe"
Set-Alias -Name wbg32 -Value "C:\Program Files (x86)\Windows Kits\10\Debuggers\x86\windbg.exe"
Set-Alias -Name pc -Value "C:\ThirdParty\Protobuf\v3.6.1\vs2019\x64\debug\bin\protoc.exe"
Set-Alias -Name lex -Value "$HOME\bin\LogExpert.1.9.0\LogExpert.exe"
Set-Alias -Name ll -Value Get-ChildItem
Set-Alias -Name tf -Value "C:\usr\terraform-1.8.5\terraform.exe"

Set-Alias -Option AllScope -Name cd -Value "Push-Location"
Set-Alias -Option AllScope -Name e -Value "Pop-Location"


function ws         { Set-Location $env:USERPROFILE\ws }
function ep         { Set-Location $env:USERPROFILE\ws\endpoint }
function wincli     { Set-Location $env:USERPROFILE\ws\endpoint\sdp\win }
function adata      { Set-Location $env:APPDATA }
function ldata      { Set-Location $env:LOCALAPPDATA }
function cut        { Set-Location $HOME/cut }
function utoo       { Set-Location $HOME/utools }
function dbox       { Set-Location $HOME/dropbox }
function bt         { Set-Location $HOME/dropbox/bt }
function msh        { Set-Location $HOME/dropbox/Media.Share }
function demdemo    { Set-Location $HOME/cutting/demdemo }
function catoprog   { Set-Location "${env:ProgramFiles(x86)}\Cato Networks\Cato Client" }
function DbgDir     { Set-Location "$HOME/ws/endpoint/sdp/win/Product/Debug/x64" }


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
    
function jh {
    cato_knock_windows
    ssh uri.london@jh
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

function Set-Java(
    [parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [ValidateSet('8', '11', '17')]
    [string]$javaVer)
{
    if ($javaVer -eq '8') {
        $javaHome = "C:\Program Files\Eclipse Adoptium\jdk-8.0.345.1-hotspot"
        $javaOpts = $null
    }
    elseif ($javaVer -eq '11') {
        $javaHome = "C:\Program Files\Eclipse Adoptium\jdk-11.0.16.8-hotspot"
        $javaOpts = $null
    }
    else {
        $javaHome = "C:\Program Files\Eclipse Adoptium\jdk-17.0.7.7-hotspot"
        $javaOpts = 
            '--add-exports=java.base/sun.nio.ch=ALL-UNNAMED',
            '--add-opens=java.base/java.lang=ALL-UNNAMED',
            '--add-opens=java.base/java.lang.reflect=ALL-UNNAMED',
            '--add-opens=java.base/java.io=ALL-UNNAMED',
            '--add-exports=jdk.unsupported/sun.misc=ALL-UNNAMED',
            '--add-opens=java.base/sun.net.util=ALL-UNNAMED',
            '--add-opens=java.base/java.util=ALL-UNNAMED'
    }

    $env:JAVA_HOME = $javaHome
    $env:JAVA_OPTS = $javaOpts -join ' '

    $p = $env:Path.trim(';') -split ';' | Where-Object { $_ -notlike '*jdk-*' }
    $p += "$env:JAVA_HOME\bin"
    $env:Path = $p -join ';'

    echo "JAVA_HOME: $env:JAVA_HOME"
    echo "JAVA_OPTS: $env:JAVA_OPTS"
    java -version
}

function setPython ([string]$python_home) {
    $p = $env:Path.trim(';') -split ';' | Where-Object { $_ -notlike '*Python*' }
    $p += Join-Path "$python_home" Scripts
    $p += "$python_home"
    $env:Path = $p -join ';'
    python --version
}

function Set-Python27 {
    setPython 'C:\usr\Python27'
}
 
function Set-Python39 {
    setPython 'C:\Program Files\Python39'
}

function IPythonCut {
    & "$HOME/virtualenvs/cut/Scripts/ipython.exe"
}

function Enter-Dev {
    $v = Get-VSSetupInstance | Select-VSSetupInstance -Latest
    Import-Module "$($v.InstallationPath)/Common7/Tools/Microsoft.VisualStudio.DevShell.dll"
    Enter-VsDevShell -InstanceId $v.InstanceId -SkipAutomaticLocation

    New-Item -Path Function:\global:prompt -Force -Value {
        "(vs) [] $($executionContext.SessionState.Path.CurrentLocation)$('>' * ($nestedPromptLevel + 1)) "
    }.GetNewClosure() | Out-Null
}

function Cato-Ju {
    if (Test-Path -PathType Container -Path "$HOME/Dropbox/Stuff/Ju") {
        Set-Location "$HOME/Dropbox/Stuff/Ju"
    }
    elseif (Test-Path -PathType Container -Path "$HOME/Dropbox/CatoStuff/Ju") {
        Set-Location "$HOME/Dropbox/CatoStuff/Ju"
    }
    & "$HOME/virtualenvs/cut/Scripts/jupyter.exe" lab
}

function Enter-Auto {
    $work_dir = $(Resolve-Path "$HOME/work").Path
    $play_dir = $(Resolve-Path "$work_dir/play-1.7.1").Path
    Set-Java 17
    $env:Path = ($env:Path -split ';' | where { $_ -notmatch 'play-\d*\.\d*\.\d*' }) + $play_dir -join ';'
    cd $work_dir
}

function Cleanup-Sdp {
    if ($CATO_ENDPOINT_HOME -eq $null) {
        echo "not in endpoint shell"
        return;
    }
    Set-Location $CATO_ENDPOINT_HOME
    Cleanup-Client
    rm -ErrorAction Ignore -Recurse -Force `
      .\sdp\win\ARM64\,
      .\sdp\win\Debug\,
      .\sdp\win\Installer\CustomActions\CatoInstallerCustomAction\x64\,
      .\sdp\win\Product\,
      .\sdp\win\Tools\DebugCustomActions\x64\,
      .\sdp\win\Tools\DevicePostureValidation\LibWaAPIBase\x64\,
      .\sdp\win\externals\,
      .\sdp\win\projects\x64\,
      .\sdp\win\proto-ipc\generated\,
      .\sdp\win\x64\
}
    
function Find-Alias([string]$cmd)
{
    Get-Alias | ? Definition -like $cmd
}

function Lex-LastVpn {
    $f = (dir ".\cato_vpn_*.log" | sort Name)[-1]
    echo "opening $f"
    lex $f
}

function Get-MyPublicIP {
    curl.exe -k https://ipecho.net/plain
}

echo "Welcome to Uri Shell"
