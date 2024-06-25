reg.exe add "HKLM\SYSTEM\CurrentControlSet\services\Dnscache\Parameters" /v "MaxNegativeCacheTtl" /t "REG_DWORD" /d "0" /f
reg.exe add "HKLM\SYSTEM\CurrentControlSet\services\Dnscache\Parameters" /v "MaxCacheTtl" /t "REG_DWORD" /d "1" /f
Invoke-WebRequest "https://badmojr.gitlab.io/1hosts/Lite/hosts.win" -OutFile "C:\Windows\System32\drivers\etc\hosts"
ipconfig /flushdns