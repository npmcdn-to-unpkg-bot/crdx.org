@echo off
setlocal

echo Searching for PhpStorm.exe...
where PhpStorm.exe

if errorlevel 1 goto :notfound

echo Launching "PhpStorm.exe %CD%"...
start "" "PhpStorm.exe" %CD%
goto :eof

:notfound
echo It's probably not in the path.
pause
