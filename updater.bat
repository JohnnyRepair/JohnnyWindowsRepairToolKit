@echo off
setlocal EnableExtensions

:: Auto-elevate to Admin
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting Administrative Privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: Ensure working directory is set to script location
cd /d "%~dp0"

title Updater - Johnny's Windows Repair Tool
color 0A

set "UPDATE_URL=https://raw.githubusercontent.com/JohnnyRepair/JohnnyWindowsRepairToolKit/main/JohnnysRepairToolKit.bat"
set "TARGET_FILE=%~dp0JohnnysRepairToolKit.bat"
set "TEMP_FILE=%TEMP%\latest_repair_tool.bat"

echo ===============================================================================
echo                UPDATING JOHNNY'S WINDOWS REPAIR TOOLKIT
echo ===============================================================================
echo.
echo Downloading the latest version from GitHub...

:: Download latest script from GitHub
curl.exe -s -L -f "%UPDATE_URL%" -o "%TEMP_FILE%"

if not exist "%TEMP_FILE%" (
    echo.
    echo ERROR: Failed to download update from GitHub. Check your connection.
    echo.
    pause
    exit /b
)

echo Overwriting main toolkit script...
copy /y "%TEMP_FILE%" "%TARGET_FILE%" >nul

if %errorlevel% neq 0 (
    echo.
    echo ERROR: Could not overwrite "%TARGET_FILE%".
    echo Make sure JohnnysRepairToolKit.bat is closed and try again.
    echo.
    pause
    exit /b
)

:: Clean up downloaded temp file
del /f /q "%TEMP_FILE%" >nul 2>&1

echo.
echo SUCCESS: Johnny's Windows Repair Tool has been updated!
echo.
echo Press any key to launch the updated Repair Tool...
pause >nul

start "" "%TARGET_FILE%"
exit /b
