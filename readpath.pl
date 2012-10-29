
@_ = `reg query "HKLM\\SYSTEM\\CurrentControlSet\\Control\\Session Manager\\Environment" /v Path`;
$_ = @_[2];
s/^ *//;
chomp;
@_ = split /    /;
$_ = $_[2];
@_ = split /;/;
print "$_;\n" for (@_) ;

