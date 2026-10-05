@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"
set NAME=android16-desktop

echo ===============================================================
echo   Android 16 - install and run
echo ===============================================================
echo.

if exist "%NAME%-disk1.vmdk.gz.part000" (
    echo Joining downloaded parts...
    copy /b "%NAME%-disk1.vmdk.gz.part*" "%NAME%-disk1.vmdk.gz" >nul
    del "%NAME%-disk1.vmdk.gz.part*"
    copy /b "%NAME%-disk2.vmdk.gz.part*" "%NAME%-disk2.vmdk.gz" >nul
    del "%NAME%-disk2.vmdk.gz.part*"
)

powershell -NoProfile -Command "if ((Get-ComputerInfo -Property HyperVisorPresent).HyperVisorPresent) { exit 1 } else { exit 0 }" >nul 2>&1
if errorlevel 1 (
    echo   Hyper-V is switched on. VirtualBox and VMware cannot run
    echo   properly while it is.
    echo.
    echo   Open Command Prompt as Administrator, run:
    echo       bcdedit /set hypervisorlaunchtype off
    echo   then restart Windows and run this again.
    echo.
    pause
    exit /b 1
)

set VBOX=
if exist "%ProgramFiles%\Oracle\VirtualBox\VBoxManage.exe" set VBOX=%ProgramFiles%\Oracle\VirtualBox\VBoxManage.exe
if exist "%ProgramFiles(x86)%\Oracle\VirtualBox\VBoxManage.exe" set VBOX=%ProgramFiles(x86)%\Oracle\VirtualBox\VBoxManage.exe

if not "%VBOX%"=="" (
    echo Using VirtualBox.
    "%VBOX%" showvminfo "%NAME%" >nul 2>&1
    if not errorlevel 1 (
        echo Already installed - starting it.
        "%VBOX%" startvm "%NAME%" --type gui
        exit /b 0
    )
    echo Installing ^(this takes a few minutes^)...
    "%VBOX%" import "%NAME%.ovf" --vsys 0 --vmname "%NAME%"
    if errorlevel 1 goto :failed
    "%VBOX%" modifyvm "%NAME%" --firmware efi
    "%VBOX%" modifyvm "%NAME%" --graphicscontroller vmsvga --vram 128
    "%VBOX%" modifyvm "%NAME%" --mouse usbtablet
    "%VBOX%" modifyvm "%NAME%" --nic1 nat --nictype1 82540EM
    "%VBOX%" modifyvm "%NAME%" --audio-enabled=on --audio-controller=ac97 --audio-codec=ad1980 --audio-driver=default --audio-out=on
    echo Starting...
    "%VBOX%" startvm "%NAME%" --type gui
    exit /b 0
)

set OVFT=
if exist "%ProgramFiles%\VMware\VMware Workstation\OVFTool\ovftool.exe" set OVFT=%ProgramFiles%\VMware\VMware Workstation\OVFTool\ovftool.exe
if exist "%ProgramFiles(x86)%\VMware\VMware Workstation\OVFTool\ovftool.exe" set OVFT=%ProgramFiles(x86)%\VMware\VMware Workstation\OVFTool\ovftool.exe

if not "%OVFT%"=="" (
    echo Using VMware.
    if not exist "%USERPROFILE%\%NAME%\%NAME%.vmx" (
        echo Installing ^(this takes a few minutes^)...
        "%OVFT%" --acceptAllEulas --overwrite "%NAME%.ovf" "%USERPROFILE%\%NAME%\%NAME%.vmx"
        if errorlevel 1 goto :failed
    )
    echo Starting...
    start "" "%USERPROFILE%\%NAME%\%NAME%.vmx"
    exit /b 0
)

echo Neither VirtualBox nor VMware was found on this computer.
echo Install one of them, then run this again:
echo    VirtualBox   https://www.virtualbox.org/
echo    VMware       https://www.vmware.com/
pause
exit /b 1

:failed
echo.
echo Something went wrong during installation. See the messages above.
pause
exit /b 1
