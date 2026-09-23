Android 16 (LineageOS 23.2) - virtual machine
=============================================

12 GB RAM / 8 CPU cores
Google Play Store and Google services included.
ARM app translation included, so ARM-only apps run too.


CHECK THE COPY FIRST
--------------------
After copying this folder from a USB drive or over a network, run:

    bash verify.sh

Every line should say OK. Large files can be damaged in transit with
no error shown, and a damaged disk shows up later as a confusing
import failure. This takes a few seconds and rules that out.


WHAT TO COPY
------------
Copy this ENTIRE FOLDER. All of these files are needed:

  android16-desktop.ovf              the description of the machine (small text file)
  android16-desktop-disk1.vmdk.gz    Android itself
  android16-desktop-disk2.vmdk.gz    apps and data
  android16-desktop.mf               checksums, used to detect a damaged copy
  verify.sh           checks the files against those checksums

Opening the .ovf on its own will not work - it only points at the disk
files, which must sit beside it in the same folder.


VMWARE WORKSTATION / PLAYER
---------------------------
  File -> Open...  ->  select  android16-desktop.ovf
  Choose where to store it, wait for the import, then press Play.
  Nothing else to change. Requires VMware Workstation 17.5 or newer.


ORACLE VIRTUALBOX
-----------------
  File -> Import Appliance...  ->  select  android16-desktop.ovf  ->  Import

  Then, BEFORE starting it, change two settings or it will not boot:

    Settings -> System -> Motherboard  ->  tick "Enable EFI"
    Settings -> Display -> Screen      ->  Graphics Controller: VMSVGA

  Recommended as well:
    Settings -> Display -> Video Memory: 128 MB
    Settings -> Input/Motherboard -> Pointing Device: USB Tablet


USING IT
--------
The window is small at first - that is the bootloader. It becomes a
phone screen once Android starts. First boot takes a few minutes.

To install apps: open Play Store and sign in with a Google account.

Messenger: install it from APKMirror, choosing an x86_64 build. The
Play Store version is built for ARM phones only and will close itself
on this machine.


SHUTTING DOWN - PLEASE READ
---------------------------
Shut Android down from inside it (power menu -> Power off), or use
  VMware:     VM -> Power -> Shut Down Guest
  VirtualBox: Machine -> ACPI Shutdown

Avoid "Power Off" or closing the window while it runs. That is the
equivalent of pulling the plug and can damage the virtual disk, after
which the machine refuses to start.


SOUND
-----
The sound card and driver are present and detected. Audio output was
not listened to during testing, because the machine it was built on
had no speakers connected. If sound does not play, check the host's
audio settings first - the virtual machine side is configured.
