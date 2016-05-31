@echo off
title RawScan Batch Add-on
if exist *.RAD goto stop
if exist *.OLS goto stop
if exist *.FLS goto stop
if exist *.DiR goto stop
for %%i in (*.RAW) do (
rawscan.exe "%%i" debug
ren "%%~nxi" "%%~ni.RAD"
)
goto end
:stop
echo  Please delete all RAD/xLS/DiR first!
pause
exit
:end
pause