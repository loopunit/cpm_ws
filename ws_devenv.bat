REM "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\devenv.exe" .\
REM "C:\Program Files\Microsoft Visual Studio\2022\Preview\Common7\IDE\devenv.exe" .\
IF "%VSINSTALLDIR%"=="" (ECHO VSINSTALLDIR is not defined) ELSE ("%VSINSTALLDIR%\Common7\IDE\devenv.exe" .\)
