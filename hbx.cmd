setlocal

:set_vars
  set _prog="c:\Program Files\Handbrake\HandBrakeCLI.exe"
  set _dl=C:\Users\uri\Downloads
  set _t=c:\t
  set _flags= ^
    -t 1 -c 1 -f mp4 -4 -w 624 --loose-anamorphic -e x264 -q 20 -r 29.97 --pfr -a 1 -E faac ^
    -B 160 -6 dpl2 -R Auto -D 0 --gain=0 --audio-copy-mask none --audio-fallback ffac3 --verbose=1


:check_param
  if .%1 == . goto no_param


:hb
  %_prog% -i "%~f1" -o "%_t%\%~n1.mp4" %_flags%
  goto end

:no_param
  echo You need to give source file
  goto end

:end
  endlocal


