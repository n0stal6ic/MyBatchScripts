:: www.nostalgic.cc
@echo off
title Music2YT
color 0a

:audio
cls
mode con cols=60 lines=8
echo.
echo  Enter Audio File.
echo  (drag and drop or type filename)
echo.
set /p Audio="> "
if "%Audio%"=="" goto audio

:image
cls
mode con cols=60 lines=8
echo.
echo  Enter Image File.
echo  (drag and drop or type filename)
echo.
set /p Image="> "
if "%Image%"=="" goto image

:quality
cls
mode con cols=60 lines=10
echo.
echo  [1] Lossless  (PNG/MKV, best quality)
echo  [2] Lossy     (H.264/MKV, smaller file)
echo.
set /p Quality="> "
if "%Quality%"=="1" goto framerate
if "%Quality%"=="2" goto framerate
echo  Invalid choice.
goto quality

:framerate
cls
mode con cols=60 lines=12
echo.
echo  Framerate?
echo  (Default: 1)
echo  (Topic channels use 25)
echo.
set /p FPS="> "
if "%FPS%"=="" set FPS=1
if "%Quality%"=="1" goto lossless
if "%Quality%"=="2" goto lossy_route

:lossy_route
cls
mode con cols=60 lines=10
echo.
echo  [1] CRF Mode     (quality-based, recommended)
echo  [2] Bitrate Mode (MB-based)
echo.
set /p LossyRoute="> "
if "%LossyRoute%"=="1" goto lossy_crf
if "%LossyRoute%"=="2" goto lossy_bitrate
echo  Invalid choice, try again.
goto lossy_route

:lossy_crf
cls
mode con cols=60 lines=10
echo.
echo  CRF Value?
echo  (Lower = better quality, larger file)
echo  (Default: 17, Range: 0-51)
echo.
set /p CRF="> "
if "%CRF%"=="" set CRF=17
goto run_lossy_crf

:lossy_bitrate
cls
mode con cols=60 lines=10
echo.
echo  Bitrate in Mbps?
echo  (Default: 15)
echo.
set /p VBV="> "
if "%VBV%"=="" set VBV=15
goto run_lossy_bitrate

:run_lossy_crf
cls
echo.
echo  Encoding...
ffmpeg -loop 1 -i %Image% -i %Audio% -c:v libx264 -crf %CRF% -tune stillimage -pix_fmt yuv444p -r %FPS% -c:a copy -shortest "%Audio%-Music2YT".mkv
goto exit

:run_lossy_bitrate
cls
echo.
echo  Encoding...
set /a BUFSIZE=%VBV%*2
ffmpeg -loop 1 -i %Image% -i %Audio% -c:v libx264 -b:v %VBV%M -maxrate %VBV%M -bufsize %BUFSIZE%M -tune stillimage -pix_fmt yuv444p -r %FPS% -c:a copy -shortest "%Audio%-Music2YT".mkv
goto exit

:lossless
cls
echo.
echo  Encoding...
ffmpeg -loop 1 -i %Image% -i %Audio% -c:v png -pix_fmt yuv444p -r %FPS% -c:a copy -shortest "%Audio%-Music2YT".mkv
goto exit

:exit
echo.
echo  Done.
pause
exit