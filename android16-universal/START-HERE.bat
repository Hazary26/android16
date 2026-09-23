@echo off
REM Prepares this folder and checks the computer can run the virtual machine.
cd /d "%~dp0"
echo ===============================================================
echo   Android 16 - setting up
echo ===============================================================
echo.

echo [1/3] Joining the downloaded parts...
if exist "android16-universal-disk1.vmdk.gz.part000" (
    copy /b "android16-universal-disk1.vmdk.gz.part*" "android16-universal-disk1.vmdk.gz" >nul
    del "android16-universal-disk1.vmdk.gz.part*"
    echo       android16-universal-disk1.vmdk.gz
)
if exist "android16-universal-disk2.vmdk.gz.part000" (
    copy /b "android16-universal-disk2.vmdk.gz.part*" "android16-universal-disk2.vmdk.gz" >nul
    del "android16-universal-disk2.vmdk.gz.part*"
    echo       android16-universal-disk2.vmdk.gz
)
if not exist "android16-universal-disk1.vmdk.gz" echo       Nothing to join - skipping.
echo.

echo [2/3] Checking the files are undamaged...
for %%F in ("android16-universal-disk1.vmdk.gz" "android16-universal-disk2.vmdk.gz") do (
    echo       %%~nxF
    certutil -hashfile "%%~F" SHA256 ^| findstr /v "hash CertUtil"
)
echo       Compare the values above with those in android16-universal.mf
echo.

echo [3/3] Checking Windows will allow virtual machines...
powershell -NoProfile -Command "if ((Get-ComputerInfo -Property HyperVisorPresent).HyperVisorPresent) { Write-Host '      *** Hyper-V is ON - VirtualBox and VMware will fail or crawl ***'; Write-Host '      Run this in an Administrator Command Prompt, then reboot:'; Write-Host '          bcdedit /set hypervisorlaunchtype off' } else { Write-Host '      Hyper-V is off - good' }" 2>nul
echo.
echo ===============================================================
echo   Ready. Now open the virtual machine:
echo.
echo   VMware:      File ^> Open...             and choose the .ovf file
echo   VirtualBox:  File ^> Import Appliance... and choose the .ovf file
echo.
echo   VirtualBox users: after importing, open Settings and set
echo      System  ^> Motherboard ^> Enable EFI          (tick it)
echo      Display ^> Screen ^> Graphics Controller: VMSVGA
echo   Without those two the machine will not boot.
echo.
echo   See README.txt for the rest.
echo ===============================================================
pause
