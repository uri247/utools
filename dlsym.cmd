if .%1 == . goto :usage
if .%1 == .-p goto :process

:image
    for /f "tokens=*" %%x in ('where.exe %1') do symchk /s srv*c:\local\symbols*http://msdl.microsoft.com/download/symbols /op /oi /od /ob /os "%%x"
    goto :end

:process
    symchk /s srv*c:\local\symbols*http://msdl.microsoft.com/download/symbols /op /oi /od /ob /os /ip %2
    goto :end

:usage
    @echo dlsym ^<image^>
    @echo dlsym -p ^<process^>
    goto :end

:end



