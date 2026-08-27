# AMD FPGA Agent Workflows

Cursor / Claude Code가 **Vivado MCP Server 없이** AMD FPGA 흐름을 돌릴 때 읽는 실행 스킬.

한 작업 = 한 스크립트. MCP 도구(`vivado_start`, `vivadoExecute`, `mcp_vivado-*`)는 호출하지 않는다.

| 영역 | 실행 수단 | 공식 AMD Git에 있는 것 | 이 저장소 |
| --- | --- | --- | --- |
| **Vivado** | `vivado -mode batch` / `-mode gui` / 터미널 grep | ECS Lab skill은 MCP 전제. 공개 Git에 Tcl 우회 없음 | MCP → Tcl 치환 8개 + 모드 가이드 |
| **Vitis** | `vitis -s script.py`, `v++` / `vitis-run` | [Xilinx/ai-assisted-vitis](https://github.com/Xilinx/ai-assisted-vitis) (`vhls-opt`, `xsct-to-python-converter`) | CLI/Python 배치 레시피 (MCP 없음) |
| **host_sw** | XDMA 캐릭터 디바이스, XRT | 없음 (드라이버 레포만) | bringup / XDMA / XRT |

예제 RTL·랩 zip은 여기에 넣지 않는다. Vivado 랩 예제는 [lastoyz/amd_vm](https://github.com/lastoyz/amd_vm) 의 **`lab_training/`** (Tcl 우회는 `lab_training/without-mcp/`). GitLab: [jose/amd_vm](http://192.168.10.97:8080/jose/amd_vm).

공식 AMD Git 클론·링크는 **[official/](official/README.md)** 에 모아 두었다. 서브모듈은 원 저장소를 그대로 가리킨다.

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

## 저장소 구조

```
amd-agent-workflows/
├── README.md                 ← 이 파일
├── AGENTS.md                 ← 에이전트 계약 (MCP 금지)
├── skills/                   ← 우리가 쓴 MCP-less skill (원본)
├── .cursor/skills/           ← Cursor 자동 로드용 복사
├── .claude/skills/           ← Claude Code 자동 로드용 복사
├── official/                 ← AMD 공식 Git (서브모듈 + 스냅샷)
│   ├── README.md             ← 원 소스 URL · 왜 클론했는지 · 링크만 둔 것
│   ├── amd-skills/           ← submodule  github.com/amd/skills
│   ├── ai-assisted-vitis/    ← submodule  github.com/Xilinx/ai-assisted-vitis
│   ├── fpl26-optimization-contest/  ← submodule  github.com/Xilinx/fpl26_optimization_contest
│   ├── magpie/               ← submodule  github.com/AMD-AGI/Magpie
│   └── mlir-aie-skills/      ← Xilinx/mlir-aie `skills/` 스냅샷 (전체 ~2 GB라 부분만)
├── install.ps1 / install.sh
└── .gitmodules
```

클론 시 공식 레포까지 받으려면 `--recurse-submodules`.

## 원 소스 (공식 Git)

자세한 표·링크는 **[official/README.md](official/README.md)**. 요약:

| 원 소스 | 이 저장소에서의 위치 | 비고 |
| --- | --- | --- |
| https://github.com/amd/skills | `official/amd-skills/` (submodule) | 전사 skill 카탈로그. FPGA 없음 |
| https://github.com/Xilinx/ai-assisted-vitis | `official/ai-assisted-vitis/` (submodule) | `vhls-opt`, `xsct-to-python-converter` |
| https://github.com/Xilinx/fpl26_optimization_contest | `official/fpl26-optimization-contest/` (submodule) | VivadoMCP를 **쓰는** 쪽 |
| https://github.com/AMD-AGI/Magpie | `official/magpie/` (submodule) | MCP 없을 때 skill로 CLI 대체하는 공식 패턴 |
| https://github.com/Xilinx/mlir-aie | `official/mlir-aie-skills/` (skills/만) | AIE/NPU skill. 전체 레포는 링크만 |
| https://github.com/amd/gaia , [Quark](https://github.com/amd/Quark) | 링크만 | 에이전트 런타임 / 양자화 |
| https://github.com/AMD-AGI/TraceLens , [Hyperloom](https://github.com/AMD-AGI/Hyperloom), [maxtext-slurm](https://github.com/AMD-AGI/maxtext-slurm) | 링크만 | GPU. 용량 큼 |

ECS Lab Vivado Agent Skill(`rtl-lint` 등)의 MCP-less Tcl 가이드는 공식 공개 Git에 없다. 그 우회본이 이 저장소 `skills/vivado-*` 이다.

## 미러

| 호스트 | URL |
| --- | --- |
| GitHub | https://github.com/lastoyz/amd-agent-workflows |
| GitLab (사내, internal) | http://192.168.10.97:8080/jose/amd-agent-workflows |

## 관련

- 랩 예제 미러: [lastoyz/amd_vm](https://github.com/lastoyz/amd_vm) · GitLab [jose/amd_vm](http://192.168.10.97:8080/jose/amd_vm) · `lab_training/` · `lab_training/without-mcp/`
- Confluence: [Vivado Agent Skill — MCP 없이 Tcl batch/GUI 우회](https://edelway.atlassian.net/wiki/spaces/~712020a9f82d3b6447487d89a832eff8293188/pages/56786949)
