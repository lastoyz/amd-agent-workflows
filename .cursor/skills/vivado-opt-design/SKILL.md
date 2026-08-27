---
name: vivado-opt-design
description: Analyze opt_design logs without a live Vivado session. Use when asking what opt_design did, why it skipped, or whether DONT_TOUCH blocked optimization. Grep only the Command: opt_design … opt_design: Time window.
---

# vivado-opt-design

**Vivado MCP도 라이브 세션도 필요 없다.** 이미 있는 implementation 로그.

산출: `vivado_agentic_ai_reports/opt-design-analysis/{REPORT.md,report_data.json,dashboard.html}`

opt가 아직 없으면:

```tcl
open_project <design>.xpr
launch_runs impl_1 -to_step opt_design
wait_on_run impl_1
```

로그 후보: `vivado.log`, `<proj>.runs/impl_1/runme.log`, `run.log`.

## 핵심 가드레일

**전체 로그 grep 금지.** 구간만:

- 시작: `Command: opt_design`
- 끝: `opt_design: Time`

`[Opt 31-138]` 등은 link/place에도 나온다.

## 추출

```bash
sed -n '/Command: opt_design/,/opt_design: Time/p' <logfile> \
  | grep "Command: opt_design\|opt_design completed\|opt_design: Time"
sed -n '/Command: opt_design/,/opt_design: Time/p' <logfile> \
  | grep -A 20 "Opt_design Change Summary"
```

`-debug_log`가 있을 때만 셀/넷 이름:

```bash
sed -n '/Command: opt_design/,/opt_design: Time/p' <logfile> \
  | grep "\[Opt 31-55\]\|\[Opt 31-431\]\|\[Opt 31-684\]\|\[Opt 31-1019\]\|\[Opt 31-1020\]\|\[Opt 31-1565\]" \
  | sort -u
```

- `[Opt 31-1019]` — 어느 DONT_TOUCH 객체가 최적화를 몇 % 막는지
- `[Opt 31-1020]` — phase별 constrained 개수

금지: 전체 `vivado.log`에서 `Phase`, utilization, `remap`, `[Opt 31-441]` grep.

Windows: Git Bash / WSL / Python으로 같은 구간을 자른다. PowerShell `sed` 없음.

## 선택 census (열린 디자인만)

```tcl
puts "DONT_TOUCH cells: [llength [get_cells -hier -filter {DONT_TOUCH == TRUE}]]"
puts "DONT_TOUCH nets:  [llength [get_nets  -hier -filter {DONT_TOUCH == TRUE}]]"
```

없으면 JSON census를 0으로.

Constrained objects가 있고 `-debug_log`가 없었으면 `opt_design -debug_log` 재실행을 권한다.
