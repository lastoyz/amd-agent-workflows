---
name: vivado-rtl-lint
description: Run synth_design -lint in Vivado batch mode, parse CSV, write an RTL lint report. Use when linting HDL, checking latches/unused assigns, or the user asks for rtl-lint without MCP.
---

# vivado-rtl-lint

Collect MCP `vivadoExecute` fragments into **one batch Tcl**. Parse the report with Python outside Vivado.

Output: `vivado_agentic_ai_reports/rtl-lint/`

## Sequence

### 1. Project

```bash
cd <example>
vivado -mode batch -source recreate_project.tcl -log recreate.log
```

### 2. Lint Tcl (`run_rtl_lint.tcl`)

```tcl
set xpr_files [glob -nocomplain *.xpr]
if {[llength $xpr_files] == 0} {
    error "No .xpr found. Run recreate_project.tcl first."
}
open_project [lindex $xpr_files 0]
set part_number [get_property part [current_project]]
set project_dir [get_property DIRECTORY [current_project]]
set top_module [get_property top [current_fileset]]
if {$top_module eq ""} {
    set all_tops [find_top]
    set top_module [lindex $all_tops 0]
    if {[llength $all_tops] > 1} { error "Confirm top with user." }
}
set report_dir [file join $project_dir vivado_agentic_ai_reports rtl-lint]
file mkdir $report_dir
set vivado_version [version -short]
set major [lindex [split $vivado_version "."] 0]
set minor [lindex [split $vivado_version "."] 1]
if {$major > 2026 || ($major == 2026 && $minor >= 1)} {
    set lint_report_file [file join $report_dir linter.csv]
} else {
    set lint_report_file [file join $report_dir linter.rpt]
}
catch {set_param synth.elaboration.rodinMoreOptions "rt::set_parameter linterCsvFile true"}
synth_design -top $top_module -part $part_number -lint -file $lint_report_file
if {![file exists $lint_report_file] || [file size $lint_report_file] == 0} {
    error "CRITICAL: lint report missing or empty"
}
exit
```

```bash
vivado -mode batch -source run_rtl_lint.tcl -log vivado_lint.log -journal vivado_lint.jou
```

### 3. CSV (Vivado < 26.1)

Do not have the agent parse the raw `.rpt`. Use the example skill's `parse_lint_report.py` (7 columns).

```bash
python parse_lint_report.py linter.rpt linter.csv
```

### 4. `rtl_lint_report.md`

One fix direction per CSV issue. If Vivado reports 0 issues, report 0. Do not treat comments as code issues.

## Guardrails

- `synth_design` **must** include `-file`.
- If there are multiple tops, ask the user and stop.
- If elaborate fails on syntax errors, fix those first. Do not lint yet.
- No MCP.
