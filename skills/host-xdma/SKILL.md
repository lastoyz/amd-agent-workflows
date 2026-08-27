---
name: host-xdma
description: Write or run PCIe XDMA userspace tests against /dev/xdma* (Linux) or the Windows XDMA driver. Use for H2C/C2H DMA, user BAR mmap, and AXI-lite register peek/poke. Not for XRT/xclbin Alveo flows.
---

# host-xdma

Target: cards that use AMD/Xilinx **DMA/Bridge Subsystem for PCI Express (XDMA)** as the endpoint. Alveo `xclbin` is `host-xrt`.

Reference driver: [Xilinx/dma_ip_drivers](https://github.com/Xilinx/dma_ip_drivers) `XDMA/linux-kernel`.

## Linux devices

After programming and reboot:

```text
/dev/xdma0_h2c_0     host → card DMA
/dev/xdma0_c2h_0     card → host DMA
/dev/xdma0_user      user BAR (AXI-lite etc.)
/dev/xdma0_bypass    bypass BAR (if present)
/dev/xdma0_events_0  interrupt
```

If missing: `lspci -d 10ee:` and `dmesg | grep -i xdma`. If the module is not loaded, start with the driver. Windows uses the vendor XDMA inf/sys — confirm the path with the user.

## App rules

- Offsets and lengths must match the **IP address map** (Vivado BD Address Editor). Do not guess magic numbers.
- DMA: write to `h2c`, read from `c2h`. Align lengths (typically 64B/4KB) to the IP setting.
- Registers: `pread`/`pwrite` or mmap on the `user` fd. Width 32/64 per the map.
- Large buffers: hugepage / aligned `posix_memalign`.
- Do not generate a full framework at once. First 4B scratch, then 4KB DMA.

Minimal smoke (concept):

```bash
# user BAR offset only after confirming the map
python -c "import os; os.pwrite(os.open('/dev/xdma0_user', os.O_RDWR), b'\\x01\\x00\\x00\\x00', OFFSET)"
```

For C, follow `dma_to_device` / `dma_from_device` in the driver repo `tools/`.

On failure: device node → `lspci` BAR → confirm the FPGA has that bit. Do not work around by rewriting the app. No MCP.
