for /f %%x in ('where.exe %1') do symchk /s srv*c:\local\symbols*http://msdl.microsoft.com/download/symbols /op /oi /od /ob /os %%x


