---
name: vivado-modes
description: Choose Vivado batch vs GUI vs tcl vs terminal-only when running FPGA flows without MCP. Use when starting Vivado, picking -mode batch/gui/tcl, or substituting vivado_start/vivadoExecute.
---

# vivado-modes

MCP `vivado_start` + `vivado_execute` 루프를 이 세 모드로 나눈다. PATH에 `vivado`가 있어야 한다. Windows 예: `C:\Xilinx\Vivado\<ver>\bin\vivado.bat`

## 명령

```bash
vivado -mode batch -source run.tcl -log vivado_batch.log -journal vivado_batch.jou
vivado -mode gui project.xpr
vivado -mode gui -source highlight.tcl
vivado -mode tcl
```

작업 디렉터리는 `.xpr` 또는 `recreate_project.tcl`이 있는 예제 폴더.

```tcl
puts "PWD=[pwd]"
puts "Vivado [version -short]"
```

## MCP → 로컬

| MCP | 로컬 |
| --- | --- |
| `vivado_start` | 해당 dir에서 `vivado -mode gui` 또는 `batch -source` |
| `vivado_execute` | GUI Tcl Console에 붙여넣기, 또는 `.tcl`에 모아 `source` |
| 한 줄 semicolon Tcl | batch에서는 **여러 줄 `.tcl`** |
| `timeout` / `wait_for_output` | `wait_on_run impl_1`, blocking `launch_simulation` |
| `vivado_log_messages` | `vivado_batch.log` / `vivado.log` grep |
| `vivado_stop` | Tcl `exit` |
| `run_in_terminal` | 그대로 (opt / multi-run) |

원본 Lab skill이 “Tcl 파일을 만들지 말라”고 한 이유: MCP는 호출마다 별도 조각이다. 우회에서는 **한 작업 = 한 `.tcl`**.

## 언제 GUI인가

GUI 없이: `synth_design`, `launch_runs`, `report_* -file`, BD `create_bd_cell` / `validate_bd_design`.

GUI 필요: XSim 라이브 파형, device `highlight_objects`, IP Integrator 캔버스 육안, Hardware Manager `commit_hw_vio`.

```text
[batch] 분석·구현·리포트
    ↓
[gui]  파형·하이라이트 확인, 승인
    ↓
[batch] 승인된 XDC로 재구현
```

## 규칙

1. MCP를 호출하지 않는다.
2. GUI를 재시작하면 변수가 사라진다. 긴 분석은 `.tcl` + `source`.
3. 경로 구분: `file join`. Python: Linux `python3`, Windows `python`.
4. Tcl 실패 시 구문을 바꿔 재시도하지 말고 에러를 보여 주고 멈춘다.
