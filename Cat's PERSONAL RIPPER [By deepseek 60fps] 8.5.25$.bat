@echo off
title Windows 11 Optimizer
color 0A
setlocal enabledelayedexpansion

:: Check for Admin privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Please run this script as Administrator!
    timeout /t 3 >nul
    exit
)

echo Starting optimization process...
echo --------------------------------------------

:: 1. Power Settings (High Performance)
echo Applying High Performance power plan...
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul

:: 2. Visual Effects Optimization
echo Optimizing visual effects...
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v DragFullWindows /t REG_SZ /d 0 /f >nul
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 0 /f >nul
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ListviewAlphaSelect /t REG_DWORD /d 0 /f >nul
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAnimations /t REG_DWORD /d 0 /f >nul
SystemPropertiesPerformance.exe -adjustforbestperf

:: 3. Background Services
echo Optimizing background services...
sc config SysMain start= disabled >nul
sc stop SysMain >nul
sc config DiagTrack start= disabled >nul
sc stop DiagTrack >nul

:: 4. Network Throttling
echo Disabling network throttling...
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Psched" /v NonBestEffortLimit /t REG_DWORD /d 0 /f >nul

:: 5. Memory Management
echo Optimizing memory management...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v DisablePagingExecutive /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v IoPageLockLimit /t REG_DWORD /d 0 /f >nul

:: 6. Storage Optimization
echo Running storage maintenance...
cleanmgr /sagerun:1 >nul
timeout /t 2 >nul

echo Optimizing drives...
for /f "tokens=2" %%d in ('wmic logicaldisk get caption^, drivetype ^| findstr /r "2$"') do (
    defrag.exe /O /U /V %%d >nul
)

:: 7. Startup Optimization
echo Cleaning startup programs...
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /va /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /va /f >nul 2>&1

:: 8. System Reset
echo Performing final optimizations...
ipconfig /flushdns >nul
netsh winsock reset >nul
netsh int ip reset >nul

:: 9. GPU Acceleration
echo Enabling GPU acceleration...
setx /M MMT_GPU_PREFERENCE HIGH
setx /M DXGI_GPU_PREFERENCE HIGH

echo --------------------------------------------
echo Optimization complete! Recommended actions:
echo 1. Reboot your computer
echo 2. Update drivers regularly
echo 3. Keep Windows updated
echo 4. Maintain >15%% free disk space
echo 5. Avoid resource-heavy startup programs

timeout /t 10 >nul