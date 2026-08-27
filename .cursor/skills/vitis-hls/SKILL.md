---
name: vitis-hls
description: Run Vitis HLS csim/csynth/cosim/pack/impl from CLI (v++ and vitis-run) without MCP. Use for HLS .cfg flows, II/latency reports, and iterative pragma changes. Prefer official Xilinx/ai-assisted-vitis vhls-opt when that skill is installed.
---

# vitis-hls

공식 긴 최적화 루프: [Xilinx/ai-assisted-vitis `vhls-opt`](https://github.com/Xilinx/ai-assisted-vitis/tree/main/skill-hub/vhls-opt).  
이 스킬은 **MCP 없는 CLI 최소 세트**. `vhls-opt`가 로드되어 있으면 그쪽을 따른다.

환경: `vitis --version` 또는 `v++ --version`. 없으면 settings64를 요청.

## 명령

`.cfg` (sources, top, clock, part) + `--work_dir` 필수. 파일 없으면 멈춘다.

| Action | Command |
| --- | --- |
| csynth | `v++ -c --mode hls --config <CFG> --work_dir <DIR>` |
| csim | `vitis-run --mode hls --csim --config <CFG> --work_dir <DIR>` |
| cosim | `vitis-run --mode hls --cosim --config <CFG> --work_dir <DIR>` |
| pack | `vitis-run --mode hls --package --config <CFG> --work_dir <DIR>` |
| impl | `vitis-run --mode hls --impl --config <CFG> --work_dir <DIR>` |

실행 전 명령을 사용자에게 보여 준다. csynth/cosim/impl 타임아웃 ≥ 10분.

성공 후:

- csynth: `<DIR>/**/csynth.rpt` 의 Performance / Utilization (latency, II, clock, BRAM/DSP/FF/LUT)
- cosim: PASS/FAIL
- 경고 개수

구식 `vitis_hls -f run.tcl` 은 Unified `.cfg`가 없을 때만. 새로 만들지 말 것.

## 최적화 루프 (짧음)

1. baseline csynth 숫자를 저장한다.
2. pragma 그룹을 **한 번에 하나** (pipeline / partition / dataflow).
3. csynth → cosim. FAIL이면 되돌리고 멈춘다.
4. 사용자 확인 후 다음 그룹.

코드를 추측으로 대규모 리팩터하지 말 것. MCP 금지.
