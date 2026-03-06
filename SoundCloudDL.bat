@echo off
title SoundCloud Downloader
color 6
mode con cols=40 lines=3
::----------------------------------------------------- BLAH BLAH
set albumart=--embed-thumbnail
set albumartwrite=--write-thumbnail
set addmeta=--add-metadata
set downloader=yt-dlp.exe
set downloaddir=%USERPROFILE%\Desktop
set batfiledir=%cd%
set cookies=soundcloud.com_cookies
::----------------------------------------------------- START
echo Pase URL
set /p url="> "
%downloader% -f bestaudio --cookies %cookies% %addmeta% %albumart% %albumwrite% -o "~/Desktop/%%(title)s.%%(ext)s" %url% 
:exit
exit