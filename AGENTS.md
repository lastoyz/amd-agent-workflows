# Agent contract

`skills/*/SKILL.md` in this repo is the execution procedure. Do not use the MCP calls from the original AMD Lab `SKILL.md`.

## Always

1. Do not call MCP namespaces (`vivado-mcp`, `mcp_vivado-*`, `vivado_start`, `vivadoExecute`). Do not use them even if the tools are visible.
2. For long work, write one `.tcl` or `.py` in the workspace and run it once in batch. Do not send one-liners the way Vivado MCP does.
3. If Tcl/Python fails, do not retry with different syntax. Show the error to the user and stop.
4. Follow the matching skill for guardrails (parsers, HITL pause, `DONT_TOUCH FALSE`, temp-IP `report_property`).
5. Output path: `<project>/vivado_agentic_ai_reports/<skill-name>/` (Vivado). Vitis/host use each skill's `build/` and `reports/`.

## Which skill to read

| User says | Skill to read |
| --- | --- |
| lint, HDL quality, latch | `vivado-rtl-lint` |
| opt_design, DONT_TOUCH is blocking | `vivado-opt-design` |
| multiple impl, strategy, WNS ranking | `vivado-multi-run` |
| AXI sim, protocol, waveform | `vivado-axi4-debug` |
| why timing failed in GUI | `vivado-post-route` first, then `vivado-timing-closure` |
| ILA, chipscope, probe BD | `vivado-bd-ila` |
| VIO, JTAG enable | `vivado-bd-vio` |
| XSA, platform, ELF, Vitis app | `vitis-unified` |
| HLS, csynth, II, pipeline | `vitis-hls` |
| xsct, XSCT Tcl | `vitis-xsct` |
| /dev/xdma, PCIe DMA, BAR | `host-xdma` |
| xclbin, xbutil, OpenCL | `host-xrt` |
| first board bring-up, bit+ELF+host | `host-bringup` |

If the mode is unclear, start with `vivado-modes`.

## Official upstream

Upstream clones live in `official/`. Read-only. Do not edit them; check URLs in [official/README.md](official/README.md).

## Relation to official AMD skills

- For long Vitis HLS optimization loops, prefer [Xilinx/ai-assisted-vitis `vhls-opt`](https://github.com/Xilinx/ai-assisted-vitis/tree/main/skill-hub/vhls-opt). `vitis-hls` here is the MCP-less CLI minimum.
- For detailed XSCT→Python mapping, use [xsct-to-python-converter](https://github.com/Xilinx/ai-assisted-vitis/tree/main/skill-hub/xsct-to-python-converter). `vitis-xsct` here covers batch execution and migration order only.
