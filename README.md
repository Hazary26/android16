# Android 16 (LineageOS 23.2) – virtual machines

Two ready-to-run VM images, for VirtualBox or VMware:

- `android16-desktop/`
- `android16-universal/`

The disk images (~11.7 GB per VM) are too big to store in git, so they're attached
to the **Releases** page in pieces of 1.9 GB or less.

## Install

1. Download this repo (Code → Download ZIP) and extract it.
2. From the latest Release, download every `android16-<variant>-disk*.vmdk.gz.part*`
   file for the VM you want, and put them in that VM's folder.
3. Run `INSTALL-AND-RUN.sh` (Linux/macOS) or `INSTALL-AND-RUN.bat` (Windows).
   It joins the parts, checks them against the checksums, then imports and starts the VM.

To join the parts by hand:

```bash
cat android16-desktop-disk1.vmdk.gz.part* > android16-desktop-disk1.vmdk.gz
```

On Windows: `copy /b android16-desktop-disk1.vmdk.gz.part* android16-desktop-disk1.vmdk.gz`

`SHA256SUMS.txt` in the release lists a checksum for every part.
