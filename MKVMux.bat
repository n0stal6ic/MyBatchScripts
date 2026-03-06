@echo off
setlocal EnableExtensions EnableDelayedExpansion

echo ================================
echo   FFmpeg MKV Mux Script
echo ================================
echo.

set /p "video=Enter path to VIDEO file (mp4): "
set /p "audio=Enter path to AUDIO file (aac/m4a): "
set /p "subs=Enter path to SUBTITLE file (srt): "
set /p "output=Enter output MKV filename (without .mkv): "

echo.
echo Muxing files...
echo.

ffmpeg -y ^
 -i "%video%" ^
 -i "%audio%" ^
 -i "%subs%" ^
 -map 0:v:0 ^
 -map 1:a:0 ^
 -map 2:s:0 ^
 -c:v copy ^
 -c:a copy ^
 -c:s srt ^
 "%output%.mkv"

echo.
if errorlevel 1 (
    echo ERROR: Muxing failed.
) else (
    echo SUCCESS: Created "%output%.mkv"
)

echo.
pause
