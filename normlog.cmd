
:set_local
    setlocal


:verify_arg
    if .%1 == . goto :usage
    if .%2 == . goto :usage


:set
    set _prefix=%1
    set _folder=%2
    set _ldecoder=c:\watchdox\trunk\WindowsPlugin\Debug\Log.Decoder.exe
    set _utf=c:\usr\MinGW\bin\iconv.exe -f unicodelittle -t utf-8

:copy
    copy %APPDATA%\WatchDox\WatchDoxEngine.log %_folder%\%_prefix%.engine.log
    copy %APPDATA%\WatchDox\WIRM.log %_folder%\%_prefix%.wirm.log
    pushd %_folder%
    %_ldecoder% %_prefix%.engine.log -s
    %_ldecoder% %_prefix%.wirm.log -s
    %_utf% %_prefix%.engine.ldecoded > %_prefix%.engine.txt
    %_utf% %_prefix%.wirm.ldecoded > %_prefix%.wirm.txt
    goto :end

:usage
    echo Usage: normlog prefix folder
    goto :end


:end
    endlocal
    
