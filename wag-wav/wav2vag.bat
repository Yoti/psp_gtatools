@echo off
title wav2vag batch
for %%i in (*.wav) do (
mfaudio.exe /OTVAGC "%%~nxi" "%%~ni.VAG"
del /q "%%i"
echo %%i done!
)
pause