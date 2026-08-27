---
name: vivado-rtl-lint
description: Run synth_design -lint in Vivado batch mode, parse CSV, write an RTL lint report. Use when linting HDL, checking latches/unused assigns, or the user asks for rtl-lint without MCP.
---

# vivado-rtl-lint

MCP `vivadoExecute` 조각을 **하나의 batch Tcl**로 모은다. 리포트 파싱은 Vivado 밖 Python.

산출: `vivado_agentic_ai_reports/rtl-lint/`

## 순서

### 1. 프로젝트

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

`.rpt`를 에이전트가 직접 파싱하지 말 것. 예제 스킬의 `parse_lint_report.py` (7컬럼).

```bash
python parse_lint_report.py linter.rpt linter.csv
```

### 4. `rtl_lint_report.md`

CSV 이슈마다 수정 방향. Vivado가 0건이면 0건. 주석을 코드 이슈로 오인하지 말 것.

## 가드레일

- `synth_design`에 **반드시 `-file`**.
- top이 여러 개면 사용자에게 묻고 멈춘다.
- 문법 오류로 elaborate 실패하면 lint를 쓰지 말고 먼저 고친다.
- MCP 금지.
