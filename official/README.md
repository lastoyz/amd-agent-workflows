# Official AMD sources

이 폴더는 **AMD 공식 Git을 그대로 따라가기 위한 자리**다. 우리 skill(`../skills/`)과 섞지 않는다.

클론:

```bash
git clone --recurse-submodules https://github.com/lastoyz/amd-agent-workflows.git
# 이미 받은 저장소면
git submodule update --init --depth 1
```

큰 레포(mlir-aie ~2 GB, TraceLens ~1.3 GB)는 서브모듈로 넣지 않았다. 아래 표의 **원 소스 URL**로 따로 확인한다.

## 이 폴더 구조

```
official/
├── README.md                      ← 이 파일 (카탈로그)
├── mlir-aie-skills/               ← Xilinx/mlir-aie 의 skills/ 만 스냅샷 (서브폴더)
├── amd-skills/                    ← submodule → github.com/amd/skills
├── ai-assisted-vitis/             ← submodule → github.com/Xilinx/ai-assisted-vitis
├── fpl26-optimization-contest/    ← submodule → github.com/Xilinx/fpl26_optimization_contest
└── magpie/                        ← submodule → github.com/AMD-AGI/Magpie
```

라이선스·저작권은 각 원 저장소 것을 따른다. 수정하지 말고 업스트림 SHA만 올린다.

## 서브모듈 (이 저장소에 클론됨)

| 로컬 경로 | 원 소스 | 기본 브랜치 | 왜 가져왔나 |
| --- | --- | --- | --- |
| [amd-skills/](amd-skills/) | https://github.com/amd/skills | `main` | AMD 전사 Agent Skills 카탈로그. FPGA 없음. 형식·설치 방법 참고. |
| [ai-assisted-vitis/](ai-assisted-vitis/) | https://github.com/Xilinx/ai-assisted-vitis | `main` | 공식 Vitis skill-hub: `vhls-opt`, `xsct-to-python-converter` |
| [fpl26-optimization-contest/](fpl26-optimization-contest/) | https://github.com/Xilinx/fpl26_optimization_contest | `main` | 공식 VivadoMCP + RapidWrightMCP (MCP를 **쓰는** 쪽) |
| [magpie/](magpie/) | https://github.com/AMD-AGI/Magpie | `main` | GPU 평가. **MCP 없을 때 skill로 CLI 대체** 패턴 (`docs/how-to/mcp-and-skills.md`) |

업데이트:

```bash
git submodule update --remote --depth 1
```

## 서브폴더 스냅샷 (부분만)

| 로컬 경로 | 원 소스 | 가져온 것 | 전체 레포를 안 넣은 이유 |
| --- | --- | --- | --- |
| [mlir-aie-skills/](mlir-aie-skills/) | https://github.com/Xilinx/mlir-aie | `skills/` 만 | 전체 ~2.1 GB. AIE/NPU `SKILL.md` 파이프라인만 필요 |

커밋 SHA·날짜는 [mlir-aie-skills/SOURCE.txt](mlir-aie-skills/SOURCE.txt). 최신으로 맞출 때 원 레포 `skills/`를 다시 복사하고 SOURCE.txt를 고친다.

## 링크만 (클론하지 않음 — 따로 확인)

### Adaptive Computing / FPGA (github.com/Xilinx)

| URL | 볼 곳 | 메모 |
| --- | --- | --- |
| https://github.com/Xilinx/mlir-aie | `skills/` | 전체 툴체인. 스냅샷은 위 `mlir-aie-skills/` |
| https://github.com/Xilinx/mlir-aie/tree/main/skills | README + 5 skill | baseline → presim → bringup → kernel-opt → dataflow-opt |
| https://github.com/Xilinx/RapidWright | 루트 | fpl26 이 서브모듈로 씀. DCP 브리지 |
| https://github.com/Xilinx/Vitis-Tutorials/tree/2026.1/Embedded_Software/Feature_Tutorials/04-vitis_scripting_flows | `vitis -s` 튜토리얼 | 사람용 MD. Agent `SKILL.md` 아님 |
| https://github.com/Xilinx/Vivado-Design-Tutorials | 랩 Tcl | AI skill 아님 |
| https://docs.amd.com/r/en-US/ug1702-vitis-accelerated-reference/Using-AI-Features-of-the-Vitis-Unified-IDE | UG1702 AI Features | IDE 안 `vivado-doc-server` MCP, `ai-features.skills.skillDirectories` |

ECS Lab Vivado Agent Skill(`rtl-lint` 등)의 공개 Git은 없다. 랩 zip / EA lounge.

### 전사 스킬 · 에이전트 런타임 (github.com/amd)

| URL | 볼 곳 | 메모 |
| --- | --- | --- |
| https://github.com/amd/skills | `skills/`, `README.md` | `npx skills add amd/skills`. Ryzen AI / Instinct / ROCm |
| https://github.com/amd/gaia | `.claude/skills/`, docs/spec | 로컬 에이전트. FPGA 아님 |
| https://github.com/amd/Quark | `.claude/skills/` | 양자화 워크플로 |

### GPU 에이전트 (github.com/AMD-AGI)

| URL | 볼 곳 | 메모 |
| --- | --- | --- |
| https://github.com/AMD-AGI/Magpie | `skills/magpie/`, `docs/how-to/mcp-and-skills.md` | 서브모듈로도 있음 |
| https://github.com/AMD-AGI/TraceLens | Agent/Analysis skills | ~1.3 GB. 링크만 |
| https://github.com/AMD-AGI/Hyperloom | `src/hyperloom/inference_optimizer/SKILL.md` | ~54 MB. 링크만 |
| https://github.com/AMD-AGI/maxtext-slurm | `skills/` | Slurm/MaxText 잡 스킬 다수 |
| https://github.com/AMD-AGI/Apex | 루트 | GPU 커널 최적화 에이전트 |
| https://github.com/AMD-AGI/AgentKernelArena | 루트 | 커널 에이전트 벤치 |

## 우리 코드와의 관계

| 우리가 쓰는 것 | 공식에서 가져오는 것 |
| --- | --- |
| `../skills/vitis-hls` | `ai-assisted-vitis/skill-hub/vhls-opt` 가 더 김. 공식 우선 |
| `../skills/vitis-xsct` | `ai-assisted-vitis/skill-hub/xsct-to-python-converter` |
| `../skills/vivado-*` | 공개 공식 대응 없음. Lab MCP skill의 Tcl 우회 |
| MCP 없이 CLI | Magpie `mcp-and-skills.md` 와 같은 패턴 |

## 미러

| 호스트 | 이 폴더 |
| --- | --- |
| GitHub | https://github.com/lastoyz/amd-agent-workflows/tree/main/official |
| GitLab (사내) | http://192.168.10.97:8080/jose/amd-agent-workflows/-/tree/main/official |
