#!/bin/bash
# Installs Android 16 and starts it. Nothing to choose, nothing to configure.
cd "$(dirname "$0")"
OVF=$(ls *.ovf 2>/dev/null | head -1)
NAME="${OVF%.ovf}"

echo "==============================================================="
echo "  Android 16 - install and run"
echo "==============================================================="
echo

# --- join split parts, if this came from a split download -------------
if ls *.part000 >/dev/null 2>&1; then
    echo "Joining downloaded parts..."
    for b in $(ls *.part000 | sed 's/\.part000$//'); do
        cat "$b".part* > "$b" && rm -f "$b".part*
    done
fi

# --- check the files are intact ---------------------------------------
MF=$(ls *.mf 2>/dev/null | head -1)
if [ -n "$MF" ]; then
    echo "Checking files..."
    if ! sed 's/^SHA256(\(.*\))= \(.*\)$/\2  \1/' "$MF" | sha256sum -c - >/dev/null 2>&1; then
        echo "  Some files are damaged. Please download this folder again."
        exit 1
    fi
fi

# --- check the computer can run virtual machines -----------------------
if ! grep -qE '^flags.*(vmx|svm)' /proc/cpuinfo 2>/dev/null; then
    echo
    echo "  This computer does not have hardware virtualization enabled."
    echo "  Turn on Intel VT-x / AMD-V in the BIOS and try again."
    exit 1
fi

# --- VirtualBox -------------------------------------------------------
if command -v VBoxManage >/dev/null 2>&1; then
    echo "Using VirtualBox."
    VBoxManage showvminfo "$NAME" >/dev/null 2>&1 && {
        echo "Already installed - starting it."
        VBoxManage startvm "$NAME" --type gui; exit 0; }

    echo "Installing (this takes a few minutes)..."
    VBoxManage import "$OVF" --vsys 0 --vmname "$NAME" || exit 1
    # Settings this image needs: it boots via EFI, and its graphics driver
    # binds to the VMSVGA device. The VirtualBox defaults do neither.
    VBoxManage modifyvm "$NAME" --firmware efi
    VBoxManage modifyvm "$NAME" --graphicscontroller vmsvga --vram 128
    VBoxManage modifyvm "$NAME" --mouse usbtablet
    VBoxManage modifyvm "$NAME" --nic1 nat --nictype1 82540EM
    echo "Starting..."
    VBoxManage startvm "$NAME" --type gui
    exit 0
fi

# --- VMware -----------------------------------------------------------
if command -v ovftool >/dev/null 2>&1 && command -v vmrun >/dev/null 2>&1; then
    echo "Using VMware."
    DEST="$HOME/$NAME"
    if [ ! -f "$DEST/$NAME.vmx" ]; then
        echo "Installing (this takes a few minutes)..."
        mkdir -p "$DEST"
        ovftool --acceptAllEulas --overwrite "$OVF" "$DEST/$NAME.vmx" || exit 1
    else
        echo "Already installed."
    fi
    echo "Starting..."
    vmrun -T ws start "$DEST/$NAME.vmx" gui 2>/dev/null || vmware -x "$DEST/$NAME.vmx" &
    exit 0
fi

echo "Neither VirtualBox nor VMware was found on this computer."
echo "Install one of them, then run this again:"
echo "   VirtualBox   https://www.virtualbox.org/"
echo "   VMware       https://www.vmware.com/products/workstation-player.html"
exit 1
