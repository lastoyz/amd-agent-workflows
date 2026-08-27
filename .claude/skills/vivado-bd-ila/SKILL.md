---
name: vivado-bd-ila
description: Insert System ILA or AXIS-ILA into a Vivado block design using Tcl. Discover CONFIG.* on a temp IP first. Use for BD probes, AXI-Stream capture, chipscope-style debug. Versal needs AXIS-ILA plus AXI Debug Hub.
---

# vivado-bd-ila

삽입 Tcl은 batch로도 된다. 캔버스 확인은 GUI.

산출: `vivado_agentic_ai_reports/bd-ila-insertion/`

## 필수 0단계

테이블 값을 그대로 쓰지 말 것. temp IP로 `report_property CONFIG.*`.

비-Versal:

```tcl
create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 temp_discover
report_property [get_bd_cells temp_discover] CONFIG.*
delete_bd_objs [get_bd_cells temp_discover]
```

Versal: `xilinx.com:ip:axis_ila:1.0` + **AXI Debug Hub** + CIPS/NoC. 허브는 자동 생성되지 않는다.

AXI+native면 `set_property CONFIG.C_MON_TYPE {MIX}` 를 **별도 호출**.

연결 전 핀:

```tcl
foreach pin [get_bd_intf_pins -of_objects [get_bd_cells <cell>]] { puts $pin }
```

```tcl
validate_bd_design
save_bd_design
```

REPORT.md에 **실제 이름**으로 재현 Tcl을 남긴다. MCP 금지.
