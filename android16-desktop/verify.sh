#!/bin/bash
# Check that every file in this folder arrived undamaged.
#
# Large files copied over a network or a USB stick can be corrupted without
# any error being shown. The .mf file next to this script holds a SHA256
# checksum of each file, so they can be checked afterwards.
#
# Run it inside this folder:   bash verify.sh
cd "$(dirname "$0")"
MF=$(ls *.mf 2>/dev/null | head -1)
if [ -z "$MF" ]; then echo "No .mf manifest found here."; exit 1; fi

echo "Checking files against $MF ..."
echo
sed "s/^SHA256(\(.*\))= \(.*\)$/\2  \1/" "$MF" | sha256sum -c -
RC=$?
echo
if [ $RC -eq 0 ]; then
    echo "All files are intact. You can import the .ovf now."
else
    echo "One or more files are damaged. Copy them again - if you used"
    echo "rsync, running the same command again repairs only the bad parts."
fi
exit $RC
