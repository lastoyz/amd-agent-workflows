---
name: vivado-post-route
description: Classify post-route failing timing paths (CDC, SLR, high fanout, long logic) and optionally highlight them in Vivado GUI. Analysis only — do not write XDC or re-implement. Use before vivado-timing-closure.
---

# vivado-post-route

**분석만.** XDC·재구현은 `vivado-timing-closure`. 순서를 뒤집지 말 것.

```text
[batch/tcl] open_run / open_checkpoint → report_* -file → 분류
[gui] 사용자 승인 후 highlight / mark / fit
```

## Phase 1

```tcl
open_project <xpr>
open_run impl_1
# 또는 open_checkpoint <routed.dcp>
set baseline_wns [get_property SLACK [get_timing_paths -max_paths 1]]
set paths_neg [get_timing_paths -max_paths 1000 -slack_lesser_than 0]
puts "WNS=$baseline_wns fail=[llength $paths_neg]"
```

WNS ≥ 0 이면 meets timing 하고 **종료**.

```tcl
set rd [file join [pwd] vivado_agentic_ai_reports post-route-dcp-analysis]
file mkdir $rd
report_timing_summary -max_paths 1000 -report_unconstrained -file [file join $rd timing_summary.rpt]
report_clock_interaction -delay_type max -file [file join $rd clock_interaction.rpt]
report_cdc -file [file join $rd cdc.rpt]
```

분류 우선순위 **첫 매칭**: CDC → SLR Crossing → High Fanout (`max_fo`>1000, route delay%>80) → Long Logic → Unclassified.

카테고리당 **worst-slack 1개**만 하이라이트.

## Phase 2 GUI

```tcl
catch {unhighlight_objects [get_highlighted_objects]}
highlight_objects -color_index 1 [get_cells -of_objects $path]
mark_objects -color red [get_pins [get_property STARTPOINT_PIN $path]]
report_timing -from [get_pins [get_property STARTPOINT_PIN $path]] \
  -to [get_pins [get_property ENDPOINT_PIN $path]]
```

`report_timing -of_objects` 는 path 객체를 받지 않는다 (UG835).

색: CDC 빨강 1, SLR 파랑 3, Fanout 주황 6, Long Logic 녹 4, Unclassified magenta 7.
