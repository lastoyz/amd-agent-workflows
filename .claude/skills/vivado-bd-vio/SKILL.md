---
name: vivado-bd-vio
description: Insert VIO or AXIS-VIO into a block design and drive probes from Hardware Manager. Use for JTAG enable/reset/counter monitor. commit_hw_vio is required or HW does not update. Reuse existing Debug Hub on Versal.
---

# vivado-bd-vio

ILA = high-speed waveform (read, BRAM). VIO = JTAG **read and write**.

| Stage | Recommended |
| --- | --- |
| BD insert | GUI or batch Tcl |
| Probe after bitstream | **GUI** Hardware Manager |

## Discovery

```tcl
create_bd_cell -type ip -vlnv xilinx.com:ip:vio:3.0 temp_vio_discover
report_property [get_bd_cells temp_vio_discover] CONFIG.*
delete_bd_objs [get_bd_cells temp_vio_discover]
```

Versal: `axis_vio:1.0`. If a Debug Hub already exists, **reuse** it. Otherwise add `axi_dbg_hub` the same way as ILA.

| Kind | Probe |
| --- | --- |
| enable / reset / mux | **probe_out** (`INIT_VAL`) |
| counter / flag / FSM | **probe_in** |

Safe INIT: enable is usually `0x0`. Do not guess polarity — ask the user.

## Runtime

Changing `OUTPUT_VALUE` without `commit_hw_vio` does not update HW.

```tcl
refresh_hw_vio [get_hw_vios]
set_property OUTPUT_VALUE 1 [get_hw_probes <probe_out> -of_objects [get_hw_vios]]
commit_hw_vio [get_hw_vios]
```

No MCP. After `validate_bd_design` + `save_bd_design`, leave a reproduction Tcl in REPORT.md.
