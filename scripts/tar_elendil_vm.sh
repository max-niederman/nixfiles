#!/usr/bin/env bash
# Emulated NVMe backed by /dev/nvme1n1
# Default: read-only. Enable writes with RW=1 (DANGEROUS).
set -euo pipefail

BACKING="/dev/nvme1n1"
READONLY="off"

# Auto-escalate (needed to open raw block devices and /dev/kvm cleanly)
if [[ $EUID -ne 0 ]]; then exec sudo -- "$0" "$@"; fi

die(){ echo "Error: $*" >&2; exit 1; }

# Sanity checks
[[ -b "$BACKING" ]] || die "$BACKING is not a block device."

# Refuse if any partition or the device itself is mounted
if findmnt -rno SOURCE | grep -qE "^$BACKING([0-9p].*)?$"; then
  die "$BACKING (or a partition) is mounted on the host. Unmount or use RO."
fi

# If RW, also refuse if it contains the host root
if [[ "$READONLY" == "off" ]]; then
  ROOT_SRC="$(findmnt -no SOURCE / || true)"
  if [[ -n "$ROOT_SRC" ]] && readlink -f "$ROOT_SRC" | grep -q "^$(readlink -f "$BACKING")"; then
    die "Refusing RW: $BACKING holds the host root."
  fi
fi

# Launch QEMU with emulated NVMe (controller + namespace)
exec qemu-system-x86_64 \
  -enable-kvm -machine q35,accel=kvm -cpu host \
  -m 4096 -smp 4 \
  -display gtk \
  -device virtio-gpu-pci \
  -device ich9-usb-uhci1 -device usb-tablet \
  -nic user -boot c \
  -drive if=pflash,format=raw,readonly=on,file="/usr/share/edk2/x64/OVMF_CODE.4m.fd" \
  -drive if=pflash,format=raw,readonly=on,file="/usr/share/edk2/x64/OVMF_VARS.4m.fd" \
  -drive if=none,id=nvimg,file="$BACKING",format=raw,cache=none,aio=native,readonly="$READONLY" \
  -device nvme,serial=vmnvme0,id=nvme0 \
  -device nvme-ns,drive=nvimg,bus=nvme0,nsid=1,bootindex=0
