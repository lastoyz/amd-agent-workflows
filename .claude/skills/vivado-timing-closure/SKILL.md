---
name: vivado-timing-closure
description: Close timing after post-route classification. Draft timing_fixes.xdc with real cell/net names, wait for user approval, then batch re-impl up to 3 times. Use DONT_TOUCH FALSE not 0. Do not start before vivado-post-route.
---

# vivado-timing-closure

Prerequisite: `vivado-post-route` classification. **Do not reverse the order.**

```text
Gate1  analysis approval
[tcl]  timing_fixes.xdc (real names)
Gate2  constraint approval
[batch] re-impl (max 3 times)
```

## Guardrails

- No placeholder names. Only names confirmed with `get_cells` / `get_nets`.
- `set_property DONT_TOUCH FALSE` — in Tcl, `0` is truthy.
- Do not use `reset_property` in XDC.
- If you use LUT_REMAP, also turn off DONT_TOUCH on the bounding FFs.
- `set_clock_groups` on the same clock pair overrides `set_max_delay -datapath_only` → for CDC use per-path `set_false_path`.
- Do not put async exceptions on synchronous clocks → multicycle.
- After 3 failures, escalate.

## Re-run

Remap properties are annotations. They do nothing without `opt_design`. Start from the **post-opt DCP**, not the routed DCP. Use `read_xdc -unmanaged` (not `source`).

| XDC | Approach |
| --- | --- |
| properties only (`LUT_REMAP`, `DONT_TOUCH`, …) | post-opt DCP + `read_xdc` + `opt_design` + place/route |
| exceptions only | `add_files` + `reset_run impl_1 -from_step place_design` |
| both / pblock / SLR | full `reset_run impl_1` |

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

After the re-run, compare WNS/TNS/failing count to the baseline. If worse, go back to Gate2. No MCP.
