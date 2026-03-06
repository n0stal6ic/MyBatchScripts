:: ===============================================================================
:: ======================= THIS SCRIPT WAS DEVELOPED BY =========================
:: ===============================================================================
:: n0stal6ic
:: ===============================================================================
:: ================ If you are reading this, hellooooo hiiiiiiiiii ===============
:: ===============================================================================
::
:: -------------------------------------------------- Setting up the window
@echo off
title MediaDL
color B
mode con cols=40 lines=3
cls
:: -------------------------------------------------- Checks for libraries
:checkifexistdir
if exist ytdir.yt (
	set /p ytdir=<ytdir.yt
	attrib +r +h +s ytdir.yt
    goto direxists
) else (
    set ytdir=C:\youtube-dl\
	if not exist C:\youtube-dl\ goto ytdlni
	goto direxists
)
:direxists
cd %ytdir%
if not exist %ytdir% goto ytdlni
color 0a
goto settingscheck
:: -------------------------------------------------- Checks for user settings
:settingscheck
set downloader=yt-dlp.exe
set downloaddir=%USERPROFILE%\Desktop
set batfiledir=%cd%
set "forceytdlp=0"
set "forceytdl=0"
set "embedthumb=0"
set "downloadthumb=0"
set "embedsubs=0"
set "downloadsubs=0"
set "addmeta=0"
set "customsettings="
:: fix below please
::set iosqualityspoof=--extractor-args "youtube:player_client=default,ios"
::set albumart=--embed-thumbnail
::set albumartwrite=--write-thumbnail
::set addmeta=--add-metadata
set cookies=--cookies-from-browser firefox
goto start
:: -------------------------------------------------- Starts the introduction
:startcls
cls
:start
mode con cols=50 lines=5
color 0a
echo Paste URL:
echo.
set /p url="> "
goto formatdownload
:: -------------------------------------------------- Refresh after command
:formatdownloadcls
cls
:: -------------------------------------------------- The second page
:formatdownload
mode con cols=40 lines=15
color 0a
cls
echo What would you like to download?
echo.
echo [O] Original
echo [V] Video Only
echo [A] Audio Only
echo [P] YT Playlist ID
echo [C] Custom Command
echo.
echo [S] Settings
echo [X] Clear Cache
echo [D] Factory Reset
echo.
set /p input= "> " 
if %input%==O goto downloadboth
if %input%==V goto downloadvideo
if %input%==A goto downloadaudio
if %input%==P goto downloadplaylist
if %input%==o goto downloadboth
if %input%==v goto downloadvideo
if %input%==a goto downloadaudio
if %input%==p goto downloadplaylist
if %input%==C goto custom
if %input%==c goto custom
if %input%==D goto uninstallytdl
if %input%==d goto uninstallytdl
if %input%==X goto clearcache
if %input%==x goto clearcache
if %input%==s goto settings
if %input%==S goto settings
if %input%==1 goto credits
if %input%==stop goto exit
if %input%==quit goto exit
if %input%==exit goto exit
cls
color 4
echo Invalid Input...
timeout 2 >nul
goto formatdownloadcls
exit
:: -------------------------------------------------- Settings page
:downloadoptions
:settings
cls
mode con cols=40 lines=15
color 0a

echo Settings (toggle to enable/disable):
echo ------------------------------------
echo [Y] Force YT-DLP         [%forceytdlp%]
echo [2] Force YouTube-DL     [%forceytdl%]
echo [A] Embed Album Art      [%embedthumb%]
echo [R] Download Album Art   [%downloadthumb%]
echo [S] Embed Subtitles      [%embedsubs%]
echo [X] Download Subtitles   [%downloadsubs%]
echo [M] Add Metadata         [%addmeta%]
echo.
echo [Z] Reset
echo [Q] Back
echo.
set /p inputs="> "
if /I "%inputs%"=="Y" set /a forceytdlp^=1 & goto updatesettings
if /I "%inputs%"=="2" set /a forceytdl^=1 & goto updatesettings
if /I "%inputs%"=="A" set /a embedthumb^=1-embedthumb & goto updatesettings
if /I "%inputs%"=="R" set /a downloadthumb^=1-downloadthumb & goto updatesettings
if /I "%inputs%"=="S" set /a embedsubs^=1-embedsubs & goto updatesettings
if /I "%inputs%"=="X" set /a downloadsubs^=1-downloadsubs & goto updatesettings
if /I "%inputs%"=="M" set /a addmeta^=1-addmeta & goto updatesettings
if /I "%inputs%"=="Z" (
    set forceytdlp=0
    set forceytdl=0
    set embedthumb=0
    set downloadthumb=0
    set embedsubs=0
    set downloadsubs=0
    set addmeta=0
	set "customsettings="
    goto updatesettings
)
if /I "%inputs%"=="Q" goto formatdownloadcls
color 4
echo Invalid input...
timeout /t 2 >nul
goto settings
:updatesettings
set "customsettings="
if "%addmeta%"=="1" set "customsettings=%customsettings% --add-metadata"
if "%embedthumb%"=="1" set "customsettings=%customsettings% --embed-thumbnail"
if "%downloadthumb%"=="1" set "customsettings=%customsettings% --write-thumbnail"
if "%embedsubs%"=="1" set "customsettings=%customsettings% --embed-subs"
if "%downloadsubs%"=="1" set "customsettings=%customsettings% --write-subs"
goto settings
:: -------------------------------------------------- Format Download Commands
:downloadaudio
mode con cols=54 lines=5
cls
echo Downloading Audio...
timeout 1 >nul
%downloader% %cookies% -f bestaudio %albumart% -o "~/Desktop/%%(title)s.%%(ext)s" %customsettings% %url% 
goto finished
:downloadvideo
mode con cols=54 lines=5
cls
echo Downloading Video...
timeout 1 >nul
%downloader% %cookies% -f bestvideo -o "~/Desktop/%%(title)s.%%(ext)s" %customsettings% %url%
goto finished
:downloadplaylist
mode con cols=54 lines=5
cls
echo Downloading Playlist...
timeout 1 >nul
%downloader% %cookies% -i -f bestvideo+bestaudio -o "~/Desktop/%%(title)s.%%(ext)s" --yes-playlist %customsettings% %url%
goto finished
:downloadboth
mode con cols=54 lines=5
cls
echo Downloading Original...
timeout 1 >nul
%downloader% %cookies% -f bestvideo+bestaudio -o "~/Desktop/%%(title)s.%%(ext)s" %customsettings% %url%
goto finished
:: -------------------------------------------------- If null selection
:wip
cls
color 4
echo This is a WIP!
echo Please try again later.
timeout 2 >nul
goto startcls
:: -------------------------------------------------- If input is invalid
:invalidinput
cls
color 4
echo Invalid Input...
timeout 3 >nul
goto startcls
:: -------------------------------------------------- Finished the download
:finished
mode con cols=15 lines=2
cls
color 0a
echo Done!
timeout 2 >nul
goto formatdownloadcls
:: -------------------------------------------------- Custom Commands
:custom
cls
mode con cols=60 lines=15
color 0a
echo Custom FFMPEG Converter
echo.
set "filepath="
for %%F in ("%USERPROFILE%\Desktop\*.mp4" "%USERPROFILE%\Desktop\*.mkv" "%USERPROFILE%\Desktop\*.webm" "%USERPROFILE%\Desktop\*.m4a" "%USERPROFILE%\Desktop\*.opus" "%USERPROFILE%\Desktop\*.aac") do (
    set "candidate=%%~fF"
    call :checkLatest
)
if not defined filepath (
    color 4
    echo File not found.
    timeout 3 >nul
    goto formatdownloadcls
)
echo Selected: %filepath%
echo.
echo Choose output type:
echo [1] Convert to MP4 (H.264 / AAC)
echo [2] Convert to MKV (H.265 / AAC)
echo [3] Convert to MP3
echo [4] Convert to OGG
echo [5] Custom FFmpeg Command
echo.
set /p choice="> "
if "%choice%"=="5" (
    echo Enter full FFmpeg command. Use %%filepath%% for input:
    set /p ffcustom="ffmpeg "
    call ffmpeg %ffcustom:"=%filepath%"%
    goto formatdownloadcls
)
echo.
echo Select audio bitrate:
echo [1] 128k
echo [2] 192k
echo [3] 256k
echo [4] 320k
echo [5] Lossless (Copy stream)
echo.
set /p bitrate="> "
set "abitrate="
set "vcodec="
set "acodec="
set "lossless=0"
if "%bitrate%"=="1" set "abitrate=128k"
if "%bitrate%"=="2" set "abitrate=192k"
if "%bitrate%"=="3" set "abitrate=256k"
if "%bitrate%"=="4" set "abitrate=320k"
if "%bitrate%"=="5" set "lossless=1"
set "outfile=%filepath%.converted"
if "%choice%"=="1" (
    if "%lossless%"=="1" (
        ffmpeg -i "%filepath%" -c:v copy -c:a copy "%outfile%.mp4"
    ) else (
        ffmpeg -i "%filepath%" -c:v libx264 -crf 23 -preset slow -c:a aac -b:a %abitrate% "%outfile%.mp4"
    )
)
if "%choice%"=="2" (
    if "%lossless%"=="1" (
        ffmpeg -i "%filepath%" -c:v copy -c:a copy "%outfile%.mkv"
    ) else (
        ffmpeg -i "%filepath%" -c:v libx265 -crf 28 -preset medium -c:a aac -b:a %abitrate% "%outfile%.mkv"
    )
)
if "%choice%"=="3" (
    if "%lossless%"=="1" (
        ffmpeg -i "%filepath%" -vn -c:a copy "%outfile%.mp3"
    ) else (
        ffmpeg -i "%filepath%" -vn -c:a libmp3lame -b:a %abitrate% "%outfile%.mp3"
    )
)
if "%choice%"=="4" (
    if "%lossless%"=="1" (
        ffmpeg -i "%filepath%" -vn -c:a copy "%outfile%.ogg"
    ) else (
        ffmpeg -i "%filepath%" -vn -c:a libvorbis -b:a %abitrate% "%outfile%.ogg"
    )
)
echo.
echo Done! File saved to Desktop.
timeout 3 >nul
goto formatdownloadcls
:checkLatest
for %%T in ("%candidate%") do (
    set "currfile=%%~fT"
    set "currtime=%%~tT"
)
if not defined filepath (
    set "filepath=%currfile%"
    set "filetime=%currtime%"
    goto :eof
)
setlocal enabledelayedexpansion
for %%a in ("%currtime%") do set "t1=%%~ta"
for %%b in ("%filetime%") do set "t2=%%~tb"
if "!t1!" GTR "!t2!" (
    endlocal
    set "filepath=%currfile%"
    set "filetime=%currtime%"
) else (
    endlocal
)
goto :eof
:: -------------------------------------------------- Instalation of Libraries
:ytdlni
mode con cols=40 lines=8
cls
color 4
title Installation Wizard
echo Brand New Installation Setup
echo.
echo [1] Auto Install
echo [2] Manual Install
echo [3] Set Custom Directory
echo.
timeout 1 >nul
set /p ytdlzip= "> " 
cls
mode con cols=82 lines=10
echo Downloading...
if %ytdlzip%==1 goto dlzip
if %ytdlzip%==2 start https://ffmpeg.org/download.html
if %ytdlzip%==2 start https://github.com/yt-dlp/yt-dlp
if %ytdlzip%==2 start https://youtube-dl.org/
if %ytdlzip%==3 goto newdirloc
exit
:enddlzip
timeout 2 >nul
cls
exit
:dlzip
md C:\youtube-dl
md C:\youtube-dl\settings
cls
echo Installing Required Libraries...
powershell -command "start-bitstransfer -source https://files.catbox.moe/91vymd.bin -destination C:\youtube-dl\ffmpeg.exe"
powershell -command "start-bitstransfer -source https://github.com/ytdl-org/youtube-dl/releases/download/2021.12.17/youtube-dl.exe -destination C:\youtube-dl\youtube-dl.exe"
powershell -command "start-bitstransfer -source https://github.com/yt-dlp/yt-dlp/releases/download/2025.03.31/yt-dlp.exe -destination C:\youtube-dl\yt-dlp.exe"
attrib -r -h -s ytdir.yt
cls
del ytdir.yt
cls
goto enddlzip
:: -------------------------------------------------- Set new directory for libraries
:newdirloc
cls
color 0a
mode con cols=45 lines=5
echo Set your new directory!
echo (C:\Folder1\)
echo.
set /p ytdir= "> "
echo %ytdir% >> ytdir.yt
timeout 1 >nul
cls
echo New Directory Set!
attrib +r +h +s ytdir.yt
timeout 3 >nul
cls
goto checkifexistdir
:: -------------------------------------------------- Clear program cache
:clearcache
cls
cd /D "%~dp0"
cls
attrib -r -h -s ytdir.yt
cls
echo Clearing...
timeout 2 >nul
del ytdir.yt
goto cleared
:: -------------------------------------------------- Uninstalling libraries
:uninstallytdl
cls
echo Uninstalling assets...
echo Please Wait...
timeout 4 >nul
@RD /S /Q "C:\youtube-dl"
cls
@RD /S /Q "C:\ffmpeg"
cls
@RD /S /Q "%ytdir%"
cls
echo Clearing Cache...
timeout 3 >nul
attrib -r -h -s ytdir.yt
del ytdir.yt
cls
echo Uninstalled!
timeout 3 >nul
exit
:cleared
cls
color 0a
echo Cleared!
timeout 3 >nul
cls
goto formatdownload
:: -------------------------------------------------- Exit the app
:exit
timeout 2 >nul
exit
:fastexit
exit
