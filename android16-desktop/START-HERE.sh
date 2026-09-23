#!/bin/bash
# Prepares this folder and checks the computer can run the virtual machine.
cd "$(dirname "$0")"
echo "==============================================================="
echo "  Android 16 - setting up"
echo "==============================================================="
echo

if ls *.part000 >/dev/null 2>&1; then
    echo "[1/3] Joining the downloaded parts..."
    for base in $(ls *.part000 | sed 's/\.part000$//'); do
        cat "$base".part* > "$base" && rm -f "$base".part*
        echo "      $base"
    done
else
    echo "[1/3] No split parts to join - skipping."
fi
echo

echo "[2/3] Checking the files are undamaged..."
MF=$(ls *.mf 2>/dev/null | head -1)
if [ -n "$MF" ]; then
    if sed 's/^SHA256(\(.*\))= \(.*\)$/\2  \1/' "$MF" | sha256sum -c - >/tmp/_a16chk 2>&1; then
        echo "      all files OK"
    else
        echo "      *** SOME FILES ARE DAMAGED ***"
        grep -v ': OK$' /tmp/_a16chk | head -5
        echo
        echo "      Download or copy this folder again before continuing."
        rm -f /tmp/_a16chk; exit 1
    fi
    rm -f /tmp/_a16chk
else
    echo "      no manifest found - skipping"
fi
echo

echo "[3/3] Checking this computer can run virtual machines..."
if grep -qE '^flags.*(vmx|svm)' /proc/cpuinfo 2>/dev/null; then
    echo "      hardware virtualization: available"
else
    echo "      *** hardware virtualization NOT available ***"
    echo "      Turn on Intel VT-x / AMD-V in the BIOS, or the virtual"
    echo "      machine will not start (or will be extremely slow)."
fi
echo
echo "==============================================================="
echo "  Ready. Now open the virtual machine:"
echo
echo "  VMware:      File > Open...            and choose the .ovf file"
echo "  VirtualBox:  File > Import Appliance...and choose the .ovf file"
echo
echo "  VirtualBox users: after importing, open Settings and set"
echo "     System  > Motherboard > Enable EFI          (tick it)"
echo "     Display > Screen > Graphics Controller: VMSVGA"
echo "  Without those two the machine will not boot."
echo
echo "  See README.txt for the rest."
echo "==============================================================="
