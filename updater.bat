@echo off
title Updating Johnny's Windows Repair Tool...
color 0A

:: Wait 2 seconds for main script process to release file lock
timeout /t 2 >nul

set "SOURCE_FILE=%~1"
set "TARGET_FILE=%~2"

if "%SOURCE_FILE%"=="" (
    echo Error: Source file argument missing.
    pause
    exit /b
)

if "%TARGET_FILE%"=="" (
    echo Error: Target file argument missing.
    pause
    exit /b
)

echo Overwriting main script with the latest version...
copy /y "%SOURCE_FILE%" "%TARGET_FILE%"
if %errorlevel% neq 0 (
    echo Error updating file! Permission denied or file in use.
    pause
    exit /b
)

del /f /q "%SOURCE_FILE%" >nul 2>&1

echo.
echo Update applied successfully!
echo Restarting main script...
timeout /t 2 >nul

powershell -Command "Start-Process '%TARGET_FILE%' -Verb RunAs"
exit /b
