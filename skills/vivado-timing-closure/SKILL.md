---
name: vivado-timing-closure
description: Close timing after post-route classification. Draft timing_fixes.xdc with real cell/net names, wait for user approval, then batch re-impl up to 3 times. Use DONT_TOUCH FALSE not 0. Do not start before vivado-post-route.
---

# vivado-timing-closure

선행: `vivado-post-route` 분류. **순서를 뒤집지 말 것.**

```text
Gate1  분석 승인
[tcl]  timing_fixes.xdc (실제 이름)
Gate2  제약 승인
[batch] 재구현 (최대 3회)
```

## 가드레일

- placeholder 이름 금지. `get_cells` / `get_nets`로 확인된 이름만.
- `set_property DONT_TOUCH FALSE` — Tcl에서 `0`은 truthy.
- XDC에서 `reset_property` 금지.
- LUT_REMAP 쓰면 bounding FF의 DONT_TOUCH도 끈다.
- 같은 클럭 쌍 `set_clock_groups`가 `set_max_delay -datapath_only`를 덮어씀 → CDC는 per-path `set_false_path`.
- 동기 클럭에 async exception 금지 → multicycle.
- 3회 실패하면 escalate.

## 재실행

remap 속성은 annotation. `opt_design` 없으면 무효. 시작점은 **post-opt DCP**, routed DCP 아님. `read_xdc -unmanaged` (`source` 아님).

| XDC | 접근 |
| --- | --- |
| property만 (`LUT_REMAP`, `DONT_TOUCH`, …) | post-opt DCP + `read_xdc` + `opt_design` + place/route |
| exception만 | `add_files` + `reset_run impl_1 -from_step place_design` |
| 둘 다 / pblock / SLR | full `reset_run impl_1` |

```tcl
close_design -quiet
add_files -fileset constrs_1 timing_fixes.xdc
reset_run impl_1
launch_runs impl_1 -to_step route_design
wait_on_run impl_1
```

```bash
vivado -mode batch -source rerun_impl.tcl -log rerun_impl.log
```

재실행 후 WNS/TNS/failing count를 베이스라인과 비교. 안 좋아지면 Gate2부터. MCP 금지.
