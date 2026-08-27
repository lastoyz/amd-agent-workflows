---
name: vitis-hls
description: Run Vitis HLS csim/csynth/cosim/pack/impl from CLI (v++ and vitis-run) without MCP. Use for HLS .cfg flows, II/latency reports, and iterative pragma changes. Prefer official Xilinx/ai-assisted-vitis vhls-opt when that skill is installed.
---

# vitis-hls

Official long optimization loop: [Xilinx/ai-assisted-vitis `vhls-opt`](https://github.com/Xilinx/ai-assisted-vitis/tree/main/skill-hub/vhls-opt).  
This skill is the **MCP-less CLI minimum**. If `vhls-opt` is loaded, follow that instead.

Environment: `vitis --version` or `v++ --version`. If missing, ask for settings64.

## Commands

`.cfg` (sources, top, clock, part) + `--work_dir` are required. Stop if the files are missing.

| Action | Command |
| --- | --- |
| csynth | `v++ -c --mode hls --config <CFG> --work_dir <DIR>` |
| csim | `vitis-run --mode hls --csim --config <CFG> --work_dir <DIR>` |
| cosim | `vitis-run --mode hls --cosim --config <CFG> --work_dir <DIR>` |
| pack | `vitis-run --mode hls --package --config <CFG> --work_dir <DIR>` |
| impl | `vitis-run --mode hls --impl --config <CFG> --work_dir <DIR>` |

Show the command to the user before running. csynth/cosim/impl timeout ≥ 10 min.

After success:

- csynth: Performance / Utilization from `<DIR>/**/csynth.rpt` (latency, II, clock, BRAM/DSP/FF/LUT)
- cosim: PASS/FAIL
- warning count

Legacy `vitis_hls -f run.tcl` only when there is no Unified `.cfg`. Do not create a new Tcl flow.

## Optimization loop (short)

1. Save baseline csynth numbers.
2. One pragma group **at a time** (pipeline / partition / dataflow).
3. csynth → cosim. On FAIL, revert and stop.
4. After user confirmation, next group.

Do not large-refactor code by guessing. No MCP.
