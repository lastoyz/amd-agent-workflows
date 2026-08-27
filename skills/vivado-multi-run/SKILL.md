---
name: vivado-multi-run
description: Compare multiple Vivado impl_* runs from existing timing/utilization reports without opening a DCP. Use when ranking strategies by WNS/TNS or comparing place/phys_opt/route progression.
---

# vivado-multi-run

**라이브 Vivado 불필요.** 완료된 `impl_*` 리포트만.

산출: `vivado_agentic_ai_reports/multi-run-analysis/{REPORT.md,report_data.json,dashboard.html}`

런이 없으면 선행으로 `launch_runs impl_1 impl_2 …` 후 `wait_on_run`. 이 skill은 **읽기만**.

## 파일

```
<proj>.runs/impl_1/
<proj>.runs/impl_2/
```

| 용도 | 파일 예 |
| --- | --- |
| 타이밍 | `*timing_summary*.rpt` |
| utilization | `*utilization*.rpt` |
| 혼잡 | `*congestion*`, design_analysis |
| strategy | runme Tcl / log의 `-directive` |

`report_timing_summary` 전문을 컨텍스트에 넣지 말 것. Design Timing Summary 표만.

```bash
grep -A 20 "Design Timing Summary" <run>/timing_summary.rpt | head -25
```

PowerShell: `Select-String -Path .\timing_summary.rpt -Pattern "Design Timing Summary" -Context 0,20`

추출: WNS, TNS, failing endpoints, WHS, THS.

## 순위

WNS 우선, 동점이면 TNS, 그다음 failing path 수. route 실패·리포트 없음은 순위에서 빼고 anomaly.

place → phys_opt → route 각 단계 timing summary가 있으면 WNS 열을 나란히.

## 가드레일

- DCP를 열거나 MCP를 쓰지 않는다.
- 런이 2개 미만이면 비교하지 말고 런을 더 돌리라고 한다.
