---
name: vivado-multi-run
description: Compare multiple Vivado impl_* runs from existing timing/utilization reports without opening a DCP. Use when ranking strategies by WNS/TNS or comparing place/phys_opt/route progression.
---

# vivado-multi-run

**No live Vivado required.** Completed `impl_*` reports only.

Output: `vivado_agentic_ai_reports/multi-run-analysis/{REPORT.md,report_data.json,dashboard.html}`

If runs do not exist, first `launch_runs impl_1 impl_2 …` then `wait_on_run`. This skill is **read-only**.

## Files

```
<proj>.runs/impl_1/
<proj>.runs/impl_2/
```

| Use | File examples |
| --- | --- |
| timing | `*timing_summary*.rpt` |
| utilization | `*utilization*.rpt` |
| congestion | `*congestion*`, design_analysis |
| strategy | `-directive` in runme Tcl / log |

Do not put a full `report_timing_summary` into context. Design Timing Summary table only.

```bash
grep -A 20 "Design Timing Summary" <run>/timing_summary.rpt | head -25
```

PowerShell: `Select-String -Path .\timing_summary.rpt -Pattern "Design Timing Summary" -Context 0,20`

Extract: WNS, TNS, failing endpoints, WHS, THS.

## Ranking

WNS first; on a tie, TNS; then failing path count. Drop route failures and missing reports from the ranking as anomalies.

If each of place → phys_opt → route has a timing summary, put WNS columns side by side.

## Guardrails

- Do not open a DCP or use MCP.
- If there are fewer than 2 runs, do not compare. Ask for more runs.
