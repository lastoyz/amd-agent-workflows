# AMD FPGA Agent Workflows

Cursor / Claude Code가 **Vivado MCP Server 없이** AMD FPGA 흐름을 돌릴 때 읽는 실행 스킬.

한 작업 = 한 스크립트. MCP 도구(`vivado_start`, `vivadoExecute`, `mcp_vivado-*`)는 호출하지 않는다.

| 영역 | 실행 수단 | 공식 AMD Git에 있는 것 | 이 저장소 |
| --- | --- | --- | --- |
| **Vivado** | `vivado -mode batch` / `-mode gui` / 터미널 grep | ECS Lab skill은 MCP 전제. 공개 Git에 Tcl 우회 없음 | MCP → Tcl 치환 8개 + 모드 가이드 |
| **Vitis** | `vitis -s script.py`, `v++` / `vitis-run` | [Xilinx/ai-assisted-vitis](https://github.com/Xilinx/ai-assisted-vitis) (`vhls-opt`, `xsct-to-python-converter`) | CLI/Python 배치 레시피 (MCP 없음) |
| **host_sw** | XDMA 캐릭터 디바이스, XRT | 없음 (드라이버 레포만) | bringup / XDMA / XRT |

예제 RTL·랩 zip은 여기에 넣지 않는다. Vivado 랩 예제는 [lastoyz/amd_vm](https://github.com/lastoyz/amd_vm) (`without-mcp/` 동봉).

## 에이전트에게 주는 방법

이 저장소를 워크스페이스로 열면 `.cursor/skills/` · `.claude/skills/` 가 자동으로 잡힌다.

다른 FPGA 프로젝트에서 쓰려면:

```powershell
# Windows — 사용자 스킬로 설치
.\install.ps1
```

```bash
# Linux / Git Bash
./install.sh
```

프롬프트 예:

```text
Vivado MCP는 쓰지 않는다.
skills 인덱스를 읽고 해당 SKILL.md 순서대로 실행한다.
한 작업 = 한 .tcl 또는 한 .py. 실패하면 구문을 바꿔 재시도하지 말고 에러를 보여 주고 멈춘다.
```

## Skill 인덱스

### Vivado

| Skill | 언제 | 모드 |
| --- | --- | --- |
| [vivado-modes](skills/vivado-modes/SKILL.md) | batch / GUI / tcl 고르기 | — |
| [vivado-rtl-lint](skills/vivado-rtl-lint/SKILL.md) | 합성 전 RTL lint | batch |
| [vivado-opt-design](skills/vivado-opt-design/SKILL.md) | opt가 뭘 했는지 | 터미널만 |
| [vivado-multi-run](skills/vivado-multi-run/SKILL.md) | 여러 impl strategy 비교 | 터미널만 |
| [vivado-axi4-debug](skills/vivado-axi4-debug/SKILL.md) | AXI 프로토콜 시뮬 + 파형 | GUI 필수 |
| [vivado-post-route](skills/vivado-post-route/SKILL.md) | failing path 분류·하이라이트 | batch → GUI |
| [vivado-timing-closure](skills/vivado-timing-closure/SKILL.md) | XDC + 재구현 (최대 3회) | 승인 → batch |
| [vivado-bd-ila](skills/vivado-bd-ila/SKILL.md) | BD에 ILA 삽입 | GUI 또는 batch |
| [vivado-bd-vio](skills/vivado-bd-vio/SKILL.md) | BD에 VIO + HW Manager | GUI |

### Vitis

| Skill | 언제 | 모드 |
| --- | --- | --- |
| [vitis-unified](skills/vitis-unified/SKILL.md) | XSA → platform → app → ELF | `vitis -s` |
| [vitis-hls](skills/vitis-hls/SKILL.md) | csim / csynth / cosim / pack | `v++` / `vitis-run` |
| [vitis-xsct](skills/vitis-xsct/SKILL.md) | 레거시 XSCT Tcl만 남았을 때 | `xsct` → Python 이관 |

### Host software

| Skill | 언제 |
| --- | --- |
| [host-bringup](skills/host-bringup/SKILL.md) | bit/xsa/ELF와 호스트 앱을 한 줄로 맞출 때 |
| [host-xdma](skills/host-xdma/SKILL.md) | PCIe XDMA 유저 앱 (`/dev/xdma*`) |
| [host-xrt](skills/host-xrt/SKILL.md) | Alveo / Versal XRT (`xclbin`, `xbutil`) |

## AMD 공식 Git에서 확인한 것 (2026-08-27)

비슷한 **MD 워크플로**는 있지만, ECS Lab의 MCP skill을 **Tcl batch/GUI로 치환한 것**은 없다.

| 저장소 | 내용 | 이 저장소와의 차이 |
| --- | --- | --- |
| [Xilinx/ai-assisted-vitis](https://github.com/Xilinx/ai-assisted-vitis) | Vitis Claude skill (`vhls-opt`, `xsct-to-python-converter`) | Vitis HLS/XSCT 지식. Vivado MCP 우회 아님 |
| [Xilinx/mlir-aie](https://github.com/Xilinx/mlir-aie/tree/main/skills) | AIE kernel/dataflow `SKILL.md` | AIE 전용 |
| [Xilinx/fpl26_optimization_contest](https://github.com/Xilinx/fpl26_optimization_contest) | RapidWright + **VivadoMCP** | MCP를 쓰는 쪽 |

AMD Vivado Agent Skill(rtl-lint, opt-design-analysis, …)은 랩/얼리액세스 자료이며 `github.com/Xilinx`에 동일 이름의 MCP-less Tcl 가이드는 없다.

## 관련

- 랩 예제 미러: [lastoyz/amd_vm](https://github.com/lastoyz/amd_vm) · `without-mcp/`
- Confluence: [Vivado Agent Skill — MCP 없이 Tcl batch/GUI 우회](https://edelway.atlassian.net/wiki/spaces/~712020a9f82d3b6447487d89a832eff8293188/pages/56786949)
