# Official AMD sources

This folder is **where official AMD Git is tracked as-is**. Do not mix it with our skills (`../skills/`).

Clone:

```bash
git clone --recurse-submodules https://github.com/lastoyz/amd-agent-workflows.git
# if the repo is already cloned
git submodule update --init --depth 1
```

Large repos (mlir-aie ~2 GB, TraceLens ~1.3 GB) are not submodules. Check them separately via the **upstream URL** in the tables below.

## Layout of this folder

```
official/
├── README.md                      ← this file (catalog)
├── mlir-aie-skills/               ← skills/ snapshot from Xilinx/mlir-aie (subfolder)
├── amd-skills/                    ← submodule → github.com/amd/skills
├── ai-assisted-vitis/             ← submodule → github.com/Xilinx/ai-assisted-vitis
├── fpl26-optimization-contest/    ← submodule → github.com/Xilinx/fpl26_optimization_contest
└── magpie/                        ← submodule → github.com/AMD-AGI/Magpie
```

License and copyright follow each upstream repo. Do not edit the clones; bump the upstream SHA only.

## Submodules (cloned into this repo)

| Local path | Upstream | Default branch | Why we pulled it |
| --- | --- | --- | --- |
| [amd-skills/](amd-skills/) | https://github.com/amd/skills | `main` | AMD company-wide Agent Skills catalog. No FPGA. Reference for format and install. |
| [ai-assisted-vitis/](ai-assisted-vitis/) | https://github.com/Xilinx/ai-assisted-vitis | `main` | Official Vitis skill-hub: `vhls-opt`, `xsct-to-python-converter` |
| [fpl26-optimization-contest/](fpl26-optimization-contest/) | https://github.com/Xilinx/fpl26_optimization_contest | `main` | Official VivadoMCP + RapidWrightMCP (the side that **uses** MCP) |
| [magpie/](magpie/) | https://github.com/AMD-AGI/Magpie | `main` | GPU eval. Official pattern for **replacing MCP with CLI skills** (`docs/how-to/mcp-and-skills.md`) |

Update:

```bash
git submodule update --remote --depth 1
```

## Subfolder snapshot (partial)

| Local path | Upstream | What we took | Why not the full repo |
| --- | --- | --- | --- |
| [mlir-aie-skills/](mlir-aie-skills/) | https://github.com/Xilinx/mlir-aie | `skills/` only | Full tree ~2.1 GB. We only need the AIE/NPU `SKILL.md` pipeline |

Commit SHA and date: [mlir-aie-skills/SOURCE.txt](mlir-aie-skills/SOURCE.txt). To refresh, recopy `skills/` from upstream and update SOURCE.txt.

## Link only (not cloned — check separately)

### Adaptive Computing / FPGA (github.com/Xilinx)

| URL | Look at | Notes |
| --- | --- | --- |
| https://github.com/Xilinx/mlir-aie | `skills/` | Full toolchain. Snapshot is `mlir-aie-skills/` above |
| https://github.com/Xilinx/mlir-aie/tree/main/skills | README + 5 skills | baseline → presim → bringup → kernel-opt → dataflow-opt |
| https://github.com/Xilinx/RapidWright | root | Used as a submodule by fpl26. DCP bridge |
| https://github.com/Xilinx/Vitis-Tutorials/tree/2026.1/Embedded_Software/Feature_Tutorials/04-vitis_scripting_flows | `vitis -s` tutorial | Human-facing MD. Not an agent `SKILL.md` |
| https://github.com/Xilinx/Vivado-Design-Tutorials | lab Tcl | Not an AI skill |
| https://docs.amd.com/r/en-US/ug1702-vitis-accelerated-reference/Using-AI-Features-of-the-Vitis-Unified-IDE | UG1702 AI Features | In-IDE `vivado-doc-server` MCP, `ai-features.skills.skillDirectories` |

ECS Lab Vivado Agent Skills (`rtl-lint` and similar) have no public official Git. Lab zip / EA lounge only.

### Company-wide skills · agent runtime (github.com/amd)

| URL | Look at | Notes |
| --- | --- | --- |
| https://github.com/amd/skills | `skills/`, `README.md` | `npx skills add amd/skills`. Ryzen AI / Instinct / ROCm |
| https://github.com/amd/gaia | `.claude/skills/`, docs/spec | Local agent. Not FPGA |
| https://github.com/amd/Quark | `.claude/skills/` | Quantization workflows |

### GPU agents (github.com/AMD-AGI)

| URL | Look at | Notes |
| --- | --- | --- |
| https://github.com/AMD-AGI/Magpie | `skills/magpie/`, `docs/how-to/mcp-and-skills.md` | Also a submodule |
| https://github.com/AMD-AGI/TraceLens | Agent/Analysis skills | ~1.3 GB. Link only |
| https://github.com/AMD-AGI/Hyperloom | `src/hyperloom/inference_optimizer/SKILL.md` | ~54 MB. Link only |
| https://github.com/AMD-AGI/maxtext-slurm | `skills/` | Many Slurm/MaxText job skills |
| https://github.com/AMD-AGI/Apex | root | GPU kernel optimization agent |
| https://github.com/AMD-AGI/AgentKernelArena | root | Kernel agent bench |

## Relation to our code

| What we use | What we take from official |
| --- | --- |
| `../skills/vitis-hls` | `ai-assisted-vitis/skill-hub/vhls-opt` is longer. Prefer official |
| `../skills/vitis-xsct` | `ai-assisted-vitis/skill-hub/xsct-to-python-converter` |
| `../skills/vivado-*` | No public official counterpart. Tcl bypass of Lab MCP skills |
| CLI without MCP | Same pattern as Magpie `mcp-and-skills.md` |

## Mirrors

| Host | This folder |
| --- | --- |
| GitHub (English, `main`) | https://github.com/lastoyz/amd-agent-workflows/tree/main/official |
| GitHub (Korean, `ko`) | https://github.com/lastoyz/amd-agent-workflows/tree/ko/official |
