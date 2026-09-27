@echo off
setlocal EnableExtensions

:: Auto-elevate to Admin
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting Administrative Privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: Ensure script directory is set
cd /d "%~dp0"

mode con: cols=95 lines=37
title Johnny's Windows Repair Tool
color F1

:: ===============================================================================
:: VERSION SETTING (YYYY.MM.DD)
:: ===============================================================================
set "REV_DATE=2026.09.27"

:: Convert YYYY.MM.DD to "Month DD YYYY"
for /f "tokens=1-3 delims=." %%a in ("%REV_DATE%") do (
    set "M_NUM=%%b"
    set "D_NUM=%%c"
    set "Y_NUM=%%a"
)

if "%M_NUM%"=="01" set "M_NAME=January"
if "%M_NUM%"=="02" set "M_NAME=February"
if "%M_NUM%"=="03" set "M_NAME=March"
if "%M_NUM%"=="04" set "M_NAME=April"
if "%M_NUM%"=="05" set "M_NAME=May"
if "%M_NUM%"=="06" set "M_NAME=June"
if "%M_NUM%"=="07" set "M_NAME=July"
if "%M_NUM%"=="08" set "M_NAME=August"
if "%M_NUM%"=="09" set "M_NAME=September"
if "%M_NUM%"=="10" set "M_NAME=October"
if "%M_NUM%"=="11" set "M_NAME=November"
if "%M_NUM%"=="12" set "M_NAME=December"

:: Remove leading zero from day if present
if "%D_NUM:~0,1%"=="0" set "D_NUM=%D_NUM:~1%"

set "CURRENT_REV=%M_NAME% %D_NUM% %Y_NUM%"

:: ===============================================================================
:: SPLASH SCREEN
:: ===============================================================================
cls
echo.
echo  ===============================================================================
echo.
echo      #####   ####  #    # #    # #    # #   # #    #  ####  
echo        #    #    # #    # ##   # #    #  # #  #   #  #      
echo        #    #    # ###### # #  # ######   #   ####    ####  
echo        #    #    # #    # #  # # #    #   #   #  #        # 
echo   #    #    #    # #    # #   ## #    #   #   #   #  #    # 
echo    ####      ####  #    # #    # #    #   #   #    #  ####  
echo.
echo                         WINDOWS REPAIR TOOLKIT
echo.
echo                    Revision : %CURRENT_REV%
echo.
echo  ===============================================================================
echo.
echo                    Loading diagnostic tools, please wait...
timeout /t 3 >nul

:MENU
cls
echo ===============================================================================
echo                           JOHNNY'S WINDOWS REPAIR TOOL
echo                             Revision : %CURRENT_REV%
echo ===============================================================================
echo  1. System Info                     - Displays system specs
echo  2. SFC Scan                        - Fixes system files
echo  3. DISM Repair                     - Fixes Windows Component Store corruption
echo  4. DISM Component Store Cleanup    - Reclaims disk space from old updates
echo  5. Disk Check (Safe Live Scan)     - Non-intrusive drive health check
echo  6. Disk Check (Full Scan on Reboot)- Schedules deep sector repair for restart
echo  7. DNS Reset                       - Flushes local DNS cache for web fixes
echo  8. Winsock Reset                   - Resets network socket configuration
echo  9. Network Adapter Reset           - Restarts all network adapters
echo 10. Clear Temp and Junk Files       - Deletes temp files and cache logs
echo 11. Reset Windows Update Services   - Clears update cache to fix stuck updates
echo 12. Rebuild Icon Cache              - Fixes broken or missing desktop icons
echo 13. Reset Power Plans               - Restores default Windows power settings
echo 14. Battery Report                  - Generates detailed laptop battery log
echo 15. Recovery Info                   - Checks Windows Recovery Environment
echo 16. Reliability Monitor             - Visual timeline of system crashes
echo 17. Performance Report              - Generates 60-second system diagnostic
echo 18. Open Hidden Apps Folder         - Displays all installed apps and shortcuts
echo 19. System Restore                  - Launches Windows restore point wizard
echo 20. Memory Test                     - Schedules Windows RAM diagnostic test
echo 21. Advanced Recovery               - Opens Windows Recovery Settings app
echo 22. Windows Update                  - Opens Windows Update Settings app
echo 23. WinGet: Update All Apps         - Updates all installed software packages
echo 24. WinGet: Search and Install      - Finds and installs apps
echo 25. Export Installed Drivers List   - Saves driver details to Temp CSV
echo 26. Generate Full Repair Report     - Saves detailed diagnostic logs to Desktop
echo  Q. Exit                            - Close the toolkit
echo ===============================================================================
set /p n=Select an option: 

if "%n%"=="1" goto RUN_SYSINFO
if "%n%"=="2" goto RUN_SFC
if "%n%"=="3" goto RUN_DISMREPAIR
if "%n%"=="4" goto RUN_DISMCLEAN
if "%n%"=="5" goto RUN_CHKDSK_SAFE
if "%n%"=="6" goto RUN_CHKDSK_REBOOT
if "%n%"=="7" goto RUN_DNS
if "%n%"=="8" goto RUN_WINSOCK
if "%n%"=="9" goto RUN_NET_RESET
if "%n%"=="10" goto RUN_CLEAN_TEMP
if "%n%"=="11" goto RUN_RESET_WU
if "%n%"=="12" goto RUN_ICON_CACHE
if "%n%"=="13" goto RUN_POWER_RESET
if "%n%"=="14" goto RUN_BATTERY
if "%n%"=="15" goto RUN_RECOVERY
if "%n%"=="16" start "" perfmon /rel & goto MENU
if "%n%"=="17" goto RUN_PERF
if "%n%"=="18" start explorer.exe shell:AppsFolder & goto MENU
if "%n%"=="19" start "" rstrui.exe & goto MENU
if "%n%"=="20" start "" mdsched.exe & goto MENU
if "%n%"=="21" start "" ms-settings:recovery & goto MENU
if "%n%"=="22" start "" ms-settings:windowsupdate & goto MENU
if "%n%"=="23" goto RUN_WINGET_UPDATE
if "%n%"=="24" goto RUN_WINGET_SEARCH
if "%n%"=="25" goto RUN_DRIVERQUERY
if "%n%"=="26" goto REPORT
if /i "%n%"=="Q" exit
goto MENU

:RUN_SYSINFO
systeminfo
pause
goto MENU

:RUN_SFC
sfc /scannow
pause
goto MENU

:RUN_DISMREPAIR
DISM /Online /Cleanup-Image /RestoreHealth
pause
goto MENU

:RUN_DISMCLEAN
echo Cleaning up superseded Windows Update files...
DISM /Online /Cleanup-Image /StartComponentCleanup
pause
goto MENU

:RUN_CHKDSK_SAFE
chkdsk C: /scan
pause
goto MENU

:RUN_CHKDSK_REBOOT
echo Scheduling full disk check (fixes errors and scans bad sectors)...
chkdsk C: /f /r
echo.
echo CheckDisk has been scheduled for your next restart.
pause
goto MENU

:RUN_DNS
ipconfig /flushdns
pause
goto MENU

:RUN_WINSOCK
netsh winsock reset
echo Please restart your PC for network changes to take full effect.
pause
goto MENU

:RUN_NET_RESET
echo Restarting active network adapters...
powershell -Command "Get-NetAdapter | Disable-NetAdapter -Confirm:$false; Get-NetAdapter | Enable-NetAdapter -Confirm:$false"
pause
goto MENU

:RUN_CLEAN_TEMP
echo Cleaning Temp files...
del /q /f /s "%TEMP%\*" >nul 2>&1
del /q /f /s "C:\Windows\Temp\*" >nul 2>&1
del /q /f /s "C:\Windows\Prefetch\*" >nul 2>&1
echo Temp files cleared successfully!
pause
goto MENU

:RUN_RESET_WU
echo Stopping Windows Update services...
net stop wuauserv
net stop bits
echo Clearing update cache...
rd /s /q "%systemroot%\SoftwareDistribution"
echo Restarting services...
net start wuauserv
net start bits
echo Windows Update cache has been reset!
pause
goto MENU

:RUN_ICON_CACHE
echo Rebuilding Icon Cache...
ie4uinit.exe -show
taskkill /IM explorer.exe /F
del /A /Q "%localappdata%\IconCache.db"
del /A /F /Q "%localappdata%\Microsoft\Windows\Explorer\iconcache*"
start explorer.exe
echo Icon cache rebuilt!
pause
goto MENU

:RUN_POWER_RESET
echo Restoring default power plans...
powercfg -restoredefaultschemes
echo Power schemes reset to defaults.
pause
goto MENU

:RUN_BATTERY
powercfg /batteryreport
start "" "%USERPROFILE%\battery-report.html"
pause
goto MENU

:RUN_RECOVERY
reagentc /info
pause
goto MENU

:RUN_PERF
perfmon /report
pause
goto MENU

:RUN_WINGET_UPDATE
cls
echo Checking for software updates (including unknown versions)...
winget upgrade --all --include-unknown
pause
goto MENU

:RUN_WINGET_SEARCH
cls
set /p app=Enter application name to search: 
if "%app%"=="" goto MENU
winget search "%app%"
echo.
set /p install_app=Enter exact App ID or Name to install (leave blank to skip): 
if "%install_app%"=="" goto MENU
winget install "%install_app%"
pause
goto MENU

:RUN_DRIVERQUERY
cls
echo Exporting driver information to CSV...
driverquery /FO CSV > C:\Windows\Temp\drivers_1.csv
echo Export complete! Saved to C:\Windows\Temp\drivers_1.csv
start "" "C:\Windows\Temp"
pause
goto MENU

:REPORT
cls
echo Generating system reports... This may take several minutes.
set "R=%USERPROFILE%\Desktop\Windows_Repair_Report"
if not exist "%R%" mkdir "%R%"

echo [1/6] Getting System Info...
systeminfo > "%R%\SystemInfo.txt"

echo [2/6] Getting Network Info...
ipconfig /all > "%R%\Network.txt"

echo [3/6] Getting Recovery Status...
reagentc /info > "%R%\Recovery.txt"

echo [4/6] Verifying System Files...
sfc /verifyonly > "%R%\SFC.txt"

echo [5/6] Checking Health with DISM...
DISM /Online /Cleanup-Image /ScanHealth > "%R%\DISM.txt"

echo [6/6] Scanning Disk...
chkdsk C: /scan > "%R%\Disk.txt"

ver > "%R%\Windows.txt"

echo Done! Reports saved to Desktop.
start "" "%R%"
pause
goto MENU
