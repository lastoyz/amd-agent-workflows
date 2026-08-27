---
name: vivado-post-route
description: Classify post-route failing timing paths (CDC, SLR, high fanout, long logic) and optionally highlight them in Vivado GUI. Analysis only — do not write XDC or re-implement. Use before vivado-timing-closure.
---

# vivado-post-route

**Analysis only.** XDC and re-impl belong in `vivado-timing-closure`. Do not reverse the order.

```text
[batch/tcl] open_run / open_checkpoint → report_* -file → classify
[gui] after user approval, highlight / mark / fit
```

## Phase 1

```tcl
open_project <xpr>
open_run impl_1
# or open_checkpoint <routed.dcp>
set baseline_wns [get_property SLACK [get_timing_paths -max_paths 1]]
set paths_neg [get_timing_paths -max_paths 1000 -slack_lesser_than 0]
puts "WNS=$baseline_wns fail=[llength $paths_neg]"
```

If WNS ≥ 0, the design meets timing — **stop**.

```tcl
set rd [file join [pwd] vivado_agentic_ai_reports post-route-dcp-analysis]
file mkdir $rd
report_timing_summary -max_paths 1000 -report_unconstrained -file [file join $rd timing_summary.rpt]
report_clock_interaction -delay_type max -file [file join $rd clock_interaction.rpt]
report_cdc -file [file join $rd cdc.rpt]
```

Classification priority, **first match**: CDC → SLR Crossing → High Fanout (`max_fo`>1000, route delay%>80) → Long Logic → Unclassified.

Highlight **one worst-slack path per category**.

## Phase 2 GUI

```tcl
catch {unhighlight_objects [get_highlighted_objects]}
highlight_objects -color_index 1 [get_cells -of_objects $path]
mark_objects -color red [get_pins [get_property STARTPOINT_PIN $path]]
report_timing -from [get_pins [get_property STARTPOINT_PIN $path]] \
  -to [get_pins [get_property ENDPOINT_PIN $path]]
```

`report_timing -of_objects` does not take a path object (UG835).

Colors: CDC red 1, SLR blue 3, Fanout orange 6, Long Logic green 4, Unclassified magenta 7.
