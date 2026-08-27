---
name: vivado-axi4-debug
description: Debug AXI4 protocol bugs with XSim. Batch can capture simulate.log; live FAIL/PASS waveforms require Vivado GUI. Use for AXI handshake, protocol checker, HITL waveform review. Do not edit RTL until the user says to fix it.
---

# vivado-axi4-debug

Batch can capture simulation **logs**. FAIL/PASS **waveforms require GUI**.

```text
[gui] launch_simulation → create_wave_config _FAIL → user pause
[RTL] only after the user says "fix it"
[gui] close_sim → re-sim → _PASS waveform → pause
```

Do not run the whole testbench at once. Stop after each one.

## GUI

```bash
vivado -mode gui <project>.xpr
```

```tcl
set_property top <tb_name> [get_filesets <sim_set>]
launch_simulation -simset [get_filesets <sim_set>] -mode behavioral
```

Blocking. Log: `<proj>.sim/<sim_set>/behav/xsim/simulate.log` — assertion name, fail time, channel (AW/W/B/AR/R).

## FAIL waveform (same GUI session)

`open_wave_database` is for static WDB. Live: `create_wave_config`.

```tcl
foreach wc [get_wave_configs] { close_wave_config -force $wc }
create_wave_config <tb_name>_FAIL
set g [add_wave_group {AW Channel}]
add_wave -into $g -color yellow /<tb_name>/axi_awvalid /<tb_name>/axi_awready
```

Signals are **TB top level**. `add_wave -into "AW Channel"` as a string fails. `$g` must remain in the same session.

## HITL

Per bug: sim → FAIL waveform → **stop** → user A/B/C or “fix it” → minimal RTL change → PASS waveform.

Do not call MCP `vivado_start` / `vivadoExecute` / `mcp_vivado-*`.
