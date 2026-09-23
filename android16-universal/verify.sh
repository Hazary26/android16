#!/bin/bash
cd "$(dirname "$0")"
MF=$(ls *.mf 2>/dev/null | head -1)
if [ -z "$MF" ]; then echo "No .mf manifest found here."; exit 1; fi
echo "Checking files against $MF ..."
echo
sed "s/^SHA256(\(.*\))= \(.*\)$/\2  \1/" "$MF" | sha256sum -c -
RC=$?
echo
if [ $RC -eq 0 ]; then echo "All files are intact. You can import the .ovf now."; else echo "One or more files are damaged. Copy them again."; fi
exit $RC
