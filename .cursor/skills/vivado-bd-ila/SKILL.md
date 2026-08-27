---
name: vivado-bd-ila
description: Insert System ILA or AXIS-ILA into a Vivado block design using Tcl. Discover CONFIG.* on a temp IP first. Use for BD probes, AXI-Stream capture, chipscope-style debug. Versal needs AXIS-ILA plus AXI Debug Hub.
---

# vivado-bd-ila

Insertion Tcl can run in batch. Canvas check needs GUI.

Output: `vivado_agentic_ai_reports/bd-ila-insertion/`

## Required step 0

Do not copy table values as-is. Discover with a temp IP and `report_property CONFIG.*`.

Non-Versal:

```tcl
create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 temp_discover
report_property [get_bd_cells temp_discover] CONFIG.*
delete_bd_objs [get_bd_cells temp_discover]
```

Versal: `xilinx.com:ip:axis_ila:1.0` + **AXI Debug Hub** + CIPS/NoC. The hub is not auto-created.

For AXI+native, call `set_property CONFIG.C_MON_TYPE {MIX}` **separately**.

Pins before connect:

```tcl
foreach pin [get_bd_intf_pins -of_objects [get_bd_cells <cell>]] { puts $pin }
```

```tcl
validate_bd_design
save_bd_design
```

Leave a reproduction Tcl in REPORT.md using **real names**. No MCP.
