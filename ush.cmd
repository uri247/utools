@echo off
rem 
rem  USH.CMD - Uri's Shell
rem 



:set_programfiles_on_x86
    if "%ProgramFiles(x86)%"=="" set ProgramFiles(x86)=%ProgramFiles%


:set_archname
    if "%PROCESSOR_ARCHITECTURE%"=="AMD64" set archname=x64
    if "%PROCESSOR_ARCHITECTURE%"=="x86" set archname=x86


:verify_java
    if "%JAVA_HOME%"==""                       echo WARNING: no JAVA settings && goto no_java
    if not exist "%JAVA_HOME%"                 echo ERROR: JAVA_HOME defined but %%^JAVA_HOME%% doesn't exist && goto error
    if not exist "%JAVA_HOME%\bin\javac.exe"   echo ERROR: JAVA_HOME doesn't point to a JDK distribution && goto error
    call javac -version >nul 2>&1
    if errorlevel 1                            echo ERROR: java compiler ^(javac.exe^) is not in path. && goto error

:no_java


:dbox
    for /f "delims=" %%x in ('GetDboxFldr.py') do set _ush_dboxfldr=%%x


:aliases
    doskey /macrofile=c:\usr\utools\aliases


:root
    cd /d c:\


:echo
    title Uri's Shell
    echo Welcome to Uri's Shell


:error
    exit /b 1


:end
    %1 %2 %3 %4 %5 %6 %7 %8 %9
    
