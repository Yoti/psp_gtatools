@echo off
title vag2wav batch
for %%i in (*.vag) do (
mfaudio.exe /OTWAVU "%%~nxi" "%%~ni.WAV"
del /q "%%i"
echo %%i done!
)
pause