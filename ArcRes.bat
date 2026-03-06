@echo off
setlocal enabledelayedexpansion

:: Check if ffmpeg is available
where ffmpeg >nul 2>nul
if %errorlevel% neq 0 (
    echo.
    echo [ERROR] FFmpeg is not found in your system's PATH.
    echo Please install FFmpeg and add its 'bin' directory to your PATH environment variable.
    echo You can download it from: https://ffmpeg.org/download.html
    echo.
    pause
    exit /b
)

:MAIN_MENU
cls
title Stream Archiver and Restreamer
echo ==============================================
echo      Stream Archiver and Restreamer Tool
echo ==============================================
echo.
echo Please enter the full URL of the .m3u8 stream:
echo.
set /p "stream_url="
if "%stream_url%"=="" (
    echo [ERROR] No URL entered. Please try again.
    pause
    goto MAIN_MENU
)

:ACTION_MENU
cls
title Stream Archiver and Restreamer - Action Selection
echo ==============================================
echo      Stream Archiver and Restreamer Tool
echo ==============================================
echo.
echo Selected Stream URL:
echo %stream_url%
echo.
echo Please choose an action:
echo.
echo [1] Archive Stream (Record to MP4)
echo [2] Archive for a Specific Duration (in minutes)
echo [3] Restream an Existing Archive
echo [4] Enter a New Stream URL
echo [5] Exit
echo.
set /p "choice=Enter your choice (1-5): "

if "%choice%"=="1" goto ARCHIVE_STREAM
if "%choice%"=="2" goto ARCHIVE_TIMED
if "%choice%"=="3" goto RESTREAM_MENU
if "%choice%"=="4" goto MAIN_MENU
if "%choice%"=="5" goto END_SCRIPT
echo [ERROR] Invalid choice. Please select an option from 1 to 5.
pause
goto ACTION_MENU

:ARCHIVE_STREAM
cls
title Archiving Stream...
echo ==============================================
echo         Archiving Stream to MP4 File
echo ==============================================
echo.
echo This will record the stream until you stop it.
echo Press CTRL+C in this window to stop recording and save the file.
echo.
set /p "output_file=Enter a name for the output file (e.g., my_archive.mp4): "
if "%output_file%"=="" set "output_file=stream_archive_%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%%time:~6,2%.mp4"
echo.
echo Starting archive...
echo Command: ffmpeg -i "%stream_url%" -c copy -bsf:a aac_adtstoasc "%output_file%"
echo.
ffmpeg -i "%stream_url%" -c copy -bsf:a aac_adtstoasc "%output_file%"
echo.
echo [INFO] Archiving complete. File saved as: %output_file%
pause
goto ACTION_MENU

:ARCHIVE_TIMED
cls
title Archiving Stream (Timed)...
echo ==============================================
echo         Archiving Stream (Timed)
echo ==============================================
echo.
set /p "duration=Enter the duration to record in minutes: "
if "%duration%"=="" (
    echo [ERROR] No duration entered.
    pause
    goto ACTION_MENU
)
set /a "duration_sec=%duration% * 60"
set /p "output_file=Enter a name for the output file (e.g., timed_archive.mp4): "
if "%output_file%"=="" set "output_file=timed_archive_%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%%time:~6,2%.mp4"
echo.
echo Starting archive for %duration% minutes...
echo Command: ffmpeg -i "%stream_url%" -t %duration_sec% -c copy -bsf:a aac_adtstoasc "%output_file%"
echo.
ffmpeg -i "%stream_url%" -t %duration_sec% -c copy -bsf:a aac_adtstoasc "%output_file%"
echo.
echo [INFO] Archiving complete. File saved as: %output_file%
pause
goto ACTION_MENU

:RESTREAM_MENU
cls
title Restreaming Existing Archive
echo ==============================================
echo        Restreaming an Existing Archive
echo ==============================================
echo.
echo This option will convert an MP4 file into a new HLS stream
echo and start a simple web server to serve it.
echo.
echo [IMPORTANT] You will need Python 3 installed for the web server.
echo.
set /p "archive_file=Enter the full path to your archived MP4 file: "
if not exist "%archive_file%" (
    echo [ERROR] File not found: %archive_file%
    pause
    goto ACTION_MENU
)

:: Create a subfolder for the stream assets
for %%F in ("%archive_file%") do set "filename=%%~nF"
set "stream_folder=%filename%_stream"
if exist "%stream_folder%" rd /s /q "%stream_folder%"
mkdir "%stream_folder%"

echo.
echo Converting "%archive_file%" to HLS format...
echo This may take a few minutes depending on the file size and length.
echo.
ffmpeg -i "%archive_file%" -c:v libx264 -c:a aac -hls_time 10 -hls_playlist_type vod -hls_segment_filename "%stream_folder%\segment_%%03d.ts" "%stream_folder%\playlist.m3u8"

if %errorlevel% neq 0 (
    echo.
    echo [ERROR] FFmpeg failed to convert the file. Please check for errors.
    pause
    goto ACTION_MENU
)

echo.
echo [SUCCESS] Conversion complete.
echo.
echo Starting a simple Python web server on port 8000...
echo The stream will be available at the following URL:
echo.
echo http://localhost:8000/playlist.m3u8
echo.
echo Open this URL in VLC or a compatible player to view your restream.
echo Press CTRL+C in this window to stop the server.
echo.
cd /d "%stream_folder%"
python -m http.server 8000

echo.
echo [INFO] Web server stopped.
pause
goto ACTION_MENU

:END_SCRIPT
cls
echo.
echo Thank you for using the Stream Tool. Goodbye!
echo.
exit /b