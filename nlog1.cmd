
:set_local
    setlocal


:verify_arg
    if .%1 == . goto :usage
    if .%2 == . goto :usage
    if .%3 == . goto :usage

:set
    set _log=%1
    set _l=%2
    set _th=%3
    set _off_do=%4
    set _ole_wnd=%5

:filter
    copy /y %_log% %_l%

    perl -pe "s/2012.*?\|/time|/" %_l% >x
    move /y x %_l%

    perl -pe "s/th=%_th%/th=T0/" %_l% >x
    move /y x %_l%

    perl -pe "s/total time=[0-9:\.]*/total time=---/" %_l% >x
    move /y x %_l%

    perl -pe "s/%_off_do%/off-do/" %_l% >x
    move /y x %_l%

    perl -pe "s/%_ole_wnd%/ole-wnd/" %_l% >x
    move /y x %_l%

    goto :end


:usage
    echo usage: NLOG1 _log _l _th _off_do _ole_wnd
    goto :end

:end
    endlocal






