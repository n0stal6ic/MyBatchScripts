@echo off
title WinTV HVR-950Q → VRChat HLS Stream

REM ==========================
REM CONFIGURATION
REM ==========================

REM Path to ffmpeg.exe (update if needed)
set FFMPEG=C:\ffmpeg\bin\ffmpeg.exe

REM DirectShow device names
set VIDEO_DEVICE="WinTV HVR-950 Capture"
set AUDIO_DEVICE="Digital Audio Interface (WinTV HVR-950q USB Audio Device)"

REM Output directory
set OUTPUT_DIR=%~dp0hls

REM Stream name
set STREAM_NAME=stream

REM Video settings
set VIDEO_BITRATE=3000k
set VIDEO_PRESET=veryfast
set VIDEO_PROFILE=main

REM Audio settings
set AUDIO_BITRATE=128k

REM HLS settings
set HLS_TIME=4
set HLS_LIST_SIZE=6

REM ==========================
REM SETUP
REM ==========================

if not exist "%OUTPUT_DIR%" (
    mkdir "%OUTPUT_DIR%"
)

echo.
echo ==========================================
echo  Starting HLS stream from WinTV tuner
echo  Make sure WinTV is tuned to a channel!
echo ==========================================
echo.

REM ==========================
REM START STREAM
REM ==========================

"%FFMPEG%" ^
 -f dshow ^
 -i video=%VIDEO_DEVICE%:audio=%AUDIO_DEVICE% ^
 -vf "format=yuv420p" ^
 -c:v libx264 ^
 -preset %VIDEO_PRESET% ^
 -b:v %VIDEO_BITRATE% ^
 -tune zerolatency ^
 -c:a aac ^
 -b:a %AUDIO_BITRATE% ^
 -f hls ^
 -hls_time %HLS_TIME% ^
 -hls_list_size %HLS_LIST_SIZE% ^
 -hls_flags delete_segments ^
 "%OUTPUT_DIR%\%STREAM_NAME%.m3u8"

echo.
echo Stream stopped.
pause
