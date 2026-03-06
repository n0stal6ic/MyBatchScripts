@echo off
setlocal

set SRC="%USERPROFILE%\AppData\Local\openvr"
set DESKTOP="%USERPROFILE%\Desktop\openvr"

echo ================================
echo     OpenVR Move Utility
echo ================================
echo.
echo 1. Move OpenVR to Desktop
echo 2. Move OpenVR back to AppData\Roaming
echo.
set /p choice="Select an option (1 or 2): "

if "%choice%"=="1" goto move_to_desktop
if "%choice%"=="2" goto move_back
echo Invalid choice.
pause
exit

:move_to_desktop
if exist %SRC% (
    echo Moving OpenVR to Desktop...
    move %SRC% %DESKTOP%
    echo Done!
) else (
    echo OpenVR folder not found in AppData\Local.
)
pause
exit

:move_back
if exist %DESKTOP% (
    echo Moving OpenVR back to AppData\Local...
    move %DESKTOP% %SRC%
    echo Done!
) else (
    echo OpenVR folder not found on Desktop.
)
pause
exit
