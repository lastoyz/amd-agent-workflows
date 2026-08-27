---
name: vivado-modes
description: Choose Vivado batch vs GUI vs tcl vs terminal-only when running FPGA flows without MCP. Use when starting Vivado, picking -mode batch/gui/tcl, or substituting vivado_start/vivadoExecute.
---

# vivado-modes

Split the MCP `vivado_start` + `vivado_execute` loop into these three modes. `vivado` must be on PATH. Windows example: `C:\Xilinx\Vivado\<ver>\bin\vivado.bat`

## Commands

```bash
vivado -mode batch -source run.tcl -log vivado_batch.log -journal vivado_batch.jou
vivado -mode gui project.xpr
vivado -mode gui -source highlight.tcl
vivado -mode tcl
```

Working directory is the example folder that has `.xpr` or `recreate_project.tcl`.

```tcl
puts "PWD=[pwd]"
puts "Vivado [version -short]"
```

## MCP → local

| MCP | Local |
| --- | --- |
| `vivado_start` | From that dir, `vivado -mode gui` or `batch -source` |
| `vivado_execute` | Paste into the GUI Tcl Console, or collect into a `.tcl` and `source` |
| One-line semicolon Tcl | In batch, use a **multi-line `.tcl`** |
| `timeout` / `wait_for_output` | `wait_on_run impl_1`, blocking `launch_simulation` |
| `vivado_log_messages` | grep `vivado_batch.log` / `vivado.log` |
| `vivado_stop` | Tcl `exit` |
| `run_in_terminal` | As-is (opt / multi-run) |

Why the original Lab skill said “do not create Tcl files”: each MCP call is a separate fragment. In this bypass, **one job = one `.tcl`**.

## When GUI is required

No GUI needed: `synth_design`, `launch_runs`, `report_* -file`, BD `create_bd_cell` / `validate_bd_design`.

GUI required: live XSim waveforms, device `highlight_objects`, visual IP Integrator canvas, Hardware Manager `commit_hw_vio`.

```text
[batch] analysis · impl · reports
    ↓
[gui]  confirm waveforms / highlights, approval
    ↓
[batch] re-impl with approved XDC
```

## Rules

1. Do not call MCP.
2. Restarting the GUI drops variables. Put long analysis in a `.tcl` and `source` it.
3. Join paths with `file join`. Python: Linux `python3`, Windows `python`.
4. If Tcl fails, do not retry with different syntax. Show the error and stop.
