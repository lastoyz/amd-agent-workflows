---
name: host-xrt
description: Load xclbin and run host code with AMD XRT (xbutil, OpenCL or native XRT APIs). Use for Alveo, Versal AIE/PL kernels, and shells — not for raw XDMA character devices.
---

# host-xrt

Target: accelerators with an **XRT shell** (Alveo, some Versal platforms). Bare PCIe XDMA cards are `host-xdma`.

```bash
xbutil examine
xbutil validate --device <bdf>    # only after user approval. Long.
```

`xclbin` is a Vitis `v++` link output. An XRT app will not load from a Vivado `.bit` alone.

## Host app

1. Enumerate the device (`xcl::device` / `cl::Device`).
2. Load `xclbin`.
3. Kernel handle, BO (buffer object) alloc, host↔device sync.
4. Run the kernel, compare results.

Do not mix OpenCL and XRT native in one file. Follow the existing code style.

Environment: `source /opt/xilinx/xrt/setup.sh` (Linux). On Windows XRT, confirm the install path with the user.

## Guardrails

- Do not `xbutil reset` or refresh flash without user approval.
- If UUID/xclbin does not match the shell, rebuild the xclbin. Do not patch the app.
- Report: BDF, xclbin path, kernel name, PASS/FAIL in `reports/xrt.md`.

No MCP.
