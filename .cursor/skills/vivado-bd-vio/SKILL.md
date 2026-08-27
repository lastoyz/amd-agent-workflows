---
name: vivado-bd-vio
description: Insert VIO or AXIS-VIO into a block design and drive probes from Hardware Manager. Use for JTAG enable/reset/counter monitor. commit_hw_vio is required or HW does not update. Reuse existing Debug Hub on Versal.
---

# vivado-bd-vio

ILA = 고속 파형(읽기, BRAM). VIO = JTAG **읽고 쓰기**.

| 단계 | 권장 |
| --- | --- |
| BD 삽입 | GUI 또는 batch Tcl |
| 비트스트림 후 probe | **GUI** Hardware Manager |

## 발견

```tcl
create_bd_cell -type ip -vlnv xilinx.com:ip:vio:3.0 temp_vio_discover
report_property [get_bd_cells temp_vio_discover] CONFIG.*
delete_bd_objs [get_bd_cells temp_vio_discover]
```

Versal: `axis_vio:1.0`. Debug Hub가 있으면 **재사용**. 없으면 ILA와 같이 `axi_dbg_hub`.

| 종류 | probe |
| --- | --- |
| enable / reset / mux | **probe_out** (`INIT_VAL`) |
| counter / flag / FSM | **probe_in** |

안전한 INIT: enable은 보통 `0x0`. 추측하지 말고 사용자에게 극성 확인.

## 런타임

`OUTPUT_VALUE`만 바꾸고 `commit_hw_vio`를 안 하면 HW에 안 반영된다.

```tcl
refresh_hw_vio [get_hw_vios]
set_property OUTPUT_VALUE 1 [get_hw_probes <probe_out> -of_objects [get_hw_vios]]
commit_hw_vio [get_hw_vios]
```

MCP 금지. `validate_bd_design` + `save_bd_design` 후 REPORT.md에 재현 Tcl.
