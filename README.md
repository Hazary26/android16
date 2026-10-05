# Android 16 (LineageOS 23.2) – virtual machines

Android 16 that runs as a virtual phone on your computer, in **VMware Workstation** or **Oracle VirtualBox**
(Windows, Linux, Intel Macs). Google Play Store, Google services and ARM app support are included.

> **Latest build: [v2.0 (2026-10-05)](../../releases/tag/v2.0).** Use this one. v1.0 is the older build.

---

## 1. Choose a version

| Version | Memory / CPU | Best for |
|---|---|---|
| **Desktop** | 12 GB RAM, 8 cores | PCs with **16 GB RAM or more**. Needs VMware Workstation 17.5+ or VirtualBox 7+. |
| **Universal** | 4 GB RAM, 2 cores | PCs with **8 GB RAM**, and older VMware, VMware Player and ESXi |

## 2. Choose a format

Both formats contain the same Android. Pick whichever you find easier:

| Format | What you get | How to install |
|---|---|---|
| **OVA** (easiest) | One single `.ova` file (13 GB) | Open it in VMware or VirtualBox, and it's done |
| **Folder** | `.ovf` + two `.vmdk.gz` disks (13 GB) + scripts | Run `INSTALL-AND-RUN`, which installs and starts it automatically |

GitHub only allows files up to 2 GB, so on the [release page](../../releases/tag/v2.0) the big files are split into
pieces called `.part000`, `.part001`, and so on. You download **all** the pieces of the file you want and join them back
together (Step 4).

---

## 3. Download

Go to **[Releases → v2.0](../../releases/tag/v2.0)** and open **Assets**.

**For the OVA**, download all 7 pieces of one file:

| Desktop | Universal |
|---|---|
| `android16-desktop.ova.part000` … `part006` | `android16-universal.ova.part000` … `part006` |

…plus the matching manual from this repo: [`android16-desktop_OVA/README.txt`](android16-desktop_OVA/README.txt)
or [`android16-universal_OVA/README.txt`](android16-universal_OVA/README.txt).

**For the folder version:**
1. Download this repo: green **Code** button → **Download ZIP** → extract it.
2. From the release, download all 7 disk pieces for your version, and put them in its folder
   (`android16-desktop/` or `android16-universal/`):
   - `android16-<version>-disk1.vmdk.gz.part000`, `part001`
   - `android16-<version>-disk2.vmdk.gz.part000` … `part004`

`SHA256SUMS.txt` in the release has a checksum for every piece, if you want to check your download.

## 4. Join the pieces

**Folder version:** skip this step. `INSTALL-AND-RUN` joins the pieces itself.

**OVA:** open a terminal in the folder with the pieces and run the command for your system
(shown for Desktop; replace `desktop` with `universal` if needed):

- **Windows** (Command Prompt):
  ```
  copy /b android16-desktop.ova.part000+android16-desktop.ova.part001+android16-desktop.ova.part002+android16-desktop.ova.part003+android16-desktop.ova.part004+android16-desktop.ova.part005+android16-desktop.ova.part006 android16-desktop.ova
  ```
- **Linux / Mac:**
  ```bash
  cat android16-desktop.ova.part* > android16-desktop.ova
  ```

When it's done, you can delete the `.part` files.

## 5. Install and start

**OVA:**
- **VMware:** *File → Open…* → select the `.ova` → *Import* → press Play.
- **VirtualBox:** *File → Import Appliance…* → select the `.ova` → *Finish* → *Start*.

All settings come from the `.ova`, so you don't need to change anything. The OVA manual (`README.txt`) has full
step-by-step instructions and troubleshooting.

**Folder version:**
- **Windows:** double-click `INSTALL-AND-RUN.bat`
- **Linux:** `bash INSTALL-AND-RUN.sh`

It joins the pieces, checks them for damage, imports the VM into VirtualBox or VMware, and starts it.
For details, see `README.txt` in the folder.

## 6. First start

The first boot takes 1–3 minutes. Unlock by dragging upward on the lock screen, then open the **Play Store** and sign in
with your Google account. Use the mouse like a finger: click to tap, click-and-drag to swipe.

**Always shut down from inside Android** (power menu → *Power off*), or with *Shut Down Guest* (VMware) or *ACPI Shutdown* (VirtualBox).
Closing the window while Android runs can damage the virtual disk.

---

## Requirements

- 64-bit Intel or AMD PC. **Apple Silicon Macs (M1–M4) are not supported.**
- Hardware virtualization (VT-x / AMD-V) turned on in the BIOS
- Windows: Hyper-V turned off (`bcdedit /set hypervisorlaunchtype off`, then restart)
- About 35 GB of free disk space (13 GB download plus about 20 GB once imported)
- VMware Workstation 17.5+ or VirtualBox 7.0+ (both are free)
