param([string]$Variant)
Remove-Item -path C:\TwinCAT\3.1\Boot\* -Exclude *.db -recurse

Copy-Item -Path "C:\TwinCAT\3.1\Target\Resource\Variants\$Variant\TwinCAT RT (x64)\*" -Destination C:\TwinCAT\3.1\Boot -Recurse
Restart-Computer