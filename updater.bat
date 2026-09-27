@echo off
title Updating Johnny's Windows Repair Tool...
color 0A

:: Give the main script process 2 seconds to release its file lock
timeout /t 2 >nul

set "SOURCE_FILE=%TEMP%\latest_repair_tool.bat"
set "TARGET_FILE=%~dp0JohnnysRepairToolKit.bat"

echo Overwriting main script with the latest version...
if not exist "%SOURCE_FILE%" (
    echo Error: Downloaded temp file not found at %SOURCE_FILE%!
    pause
    exit /b
)

copy /y "%SOURCE_FILE%" "%TARGET_FILE%"
if %errorlevel% neq 0 (
    echo.
    echo ERROR: Could not overwrite file. Permission denied or file in use.
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
