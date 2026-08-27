---
name: vivado-opt-design
description: Analyze opt_design logs without a live Vivado session. Use when asking what opt_design did, why it skipped, or whether DONT_TOUCH blocked optimization. Grep only the Command: opt_design … opt_design: Time window.
---

# vivado-opt-design

**Neither Vivado MCP nor a live session is required.** Use existing implementation logs.

Output: `vivado_agentic_ai_reports/opt-design-analysis/{REPORT.md,report_data.json,dashboard.html}`

If opt has not run yet:

```tcl
open_project <design>.xpr
launch_runs impl_1 -to_step opt_design
wait_on_run impl_1
```

Log candidates: `vivado.log`, `<proj>.runs/impl_1/runme.log`, `run.log`.

## Core guardrail

**Do not grep the whole log.** Window only:

- Start: `Command: opt_design`
- End: `opt_design: Time`

Messages such as `[Opt 31-138]` also appear in link/place.

## Extract

```bash
sed -n '/Command: opt_design/,/opt_design: Time/p' <logfile> \
  | grep "Command: opt_design\|opt_design completed\|opt_design: Time"
sed -n '/Command: opt_design/,/opt_design: Time/p' <logfile> \
  | grep -A 20 "Opt_design Change Summary"
```

Cell/net names only when `-debug_log` is present:

```bash
sed -n '/Command: opt_design/,/opt_design: Time/p' <logfile> \
  | grep "\[Opt 31-55\]\|\[Opt 31-431\]\|\[Opt 31-684\]\|\[Opt 31-1019\]\|\[Opt 31-1020\]\|\[Opt 31-1565\]" \
  | sort -u
```

- `[Opt 31-1019]` — which DONT_TOUCH objects blocked what % of optimization
- `[Opt 31-1020]` — constrained count per phase

Forbidden: grepping the whole `vivado.log` for `Phase`, utilization, `remap`, `[Opt 31-441]`.

Windows: cut the same window with Git Bash / WSL / Python. PowerShell has no `sed`.

## Optional census (open design only)

```tcl
puts "DONT_TOUCH cells: [llength [get_cells -hier -filter {DONT_TOUCH == TRUE}]]"
puts "DONT_TOUCH nets:  [llength [get_nets  -hier -filter {DONT_TOUCH == TRUE}]]"
```

If none, write JSON census as 0.

If constrained objects exist and `-debug_log` was not used, recommend re-running `opt_design -debug_log`.
