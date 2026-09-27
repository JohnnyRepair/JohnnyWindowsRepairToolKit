@echo off
title Updating Repair Toolkit...
color 0A

:: Wait 2 seconds for main script to close completely
timeout /t 2 >nul

set "SOURCE_FILE=%~1"
set "TARGET_FILE=%~2"

echo Replacing main script with updated version...
copy /y "%SOURCE_FILE%" "%TARGET_FILE%" >nul
del /f /q "%SOURCE_FILE%" >nul 2>&1

echo Update completed successfully!
echo Launching updated Toolkit...
timeout /t 1 >nul

start "" "%TARGET_FILE%"
exit /b