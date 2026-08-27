---
name: host-bringup
description: Align Vivado bitstream/XSA, Vitis ELF, and host software into one bring-up sequence. Use for first board power-on, DMA loopback, or when the user asks which artifact to program in which order.
---

# host-bringup

Board bring-up requires the three artifacts to be the same revision. Do not mix them.

```text
Vivado  (vivado-modes / matching skill)
    → .bit / .pdi  +  .xsa (fixed)
Vitis   (vitis-unified)
    → .elf  (+ boot.bin / BOOT.BIN if that package exists)
host_sw (host-xdma or host-xrt)
    → user app
```

## Sequence

1. **Confirm hardware IDs**: part, PCIe ID, BAR size, DMA IP (XDMA vs AXI DMA vs QDMA vs XRT). Match user / XSA / xsa.xml.
2. **Program the FPGA**: JTAG (`vivado` HW Manager or `program_hw_devices`) or flash/SD BOOT.BIN. **Before** the host driver.
3. **Firmware**: MicroBlaze/PS ELF via xsdb/`launch_hw` or a bootloader. A PCIe-endpoint-only design may have no ELF.
4. **Host**: `lspci` / Device Manager, then the XDMA or XRT skill.
5. **Smoke**: BAR scratch or a small DMA loopback. On failure, stop. Do not grow the app.

## Report

Record in `reports/bringup.md`:

- Vivado project · commit · bit path
- XSA path · generation time
- ELF path
- Host app command and result (PASS/FAIL)

If the driver type is unclear, ask. Do not guess. No MCP.
