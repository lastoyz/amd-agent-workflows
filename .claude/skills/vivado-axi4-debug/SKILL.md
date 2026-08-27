---
name: vivado-axi4-debug
description: Debug AXI4 protocol bugs with XSim. Batch can capture simulate.log; live FAIL/PASS waveforms require Vivado GUI. Use for AXI handshake, protocol checker, HITL waveform review. Do not edit RTL until the user says to fix it.
---

# vivado-axi4-debug

batch로 시뮬 **로그**는 가능. FAIL/PASS **파형은 GUI 필수**.

```text
[gui] launch_simulation → create_wave_config _FAIL → 사용자 pause
[RTL] 사용자가 "fix it" 한 뒤에만
[gui] close_sim → 재시뮬 → _PASS 파형 → pause
```

테스트벤치를 한 번에 전부 돌리지 않는다. 하나 끝나면 멈춘다.

## GUI

```bash
vivado -mode gui <project>.xpr
```

```tcl
set_property top <tb_name> [get_filesets <sim_set>]
launch_simulation -simset [get_filesets <sim_set>] -mode behavioral
```

blocking. 로그: `<proj>.sim/<sim_set>/behav/xsim/simulate.log` — assertion 이름, 실패 시각, 채널(AW/W/B/AR/R).

## FAIL 파형 (같은 GUI 세션)

`open_wave_database`는 정적 WDB용. 라이브면 `create_wave_config`.

```tcl
foreach wc [get_wave_configs] { close_wave_config -force $wc }
create_wave_config <tb_name>_FAIL
set g [add_wave_group {AW Channel}]
add_wave -into $g -color yellow /<tb_name>/axi_awvalid /<tb_name>/axi_awready
```

신호는 **TB 탑 레벨**. `add_wave -into "AW Channel"` 문자열은 실패. `$g`가 같은 세션에 남아 있어야 한다.

## HITL

버그마다: 시뮬 → FAIL 파형 → **멈춤** → 사용자 A/B/C 또는 “fix it” → RTL 최소 수정 → PASS 파형.

MCP `vivado_start/execute/stop` 금지.
