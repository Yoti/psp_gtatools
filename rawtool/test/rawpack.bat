@echo off
title RawPack Batch Add-on
for %%i in (*.RAD) do rawpack.exe "%%i"
pause