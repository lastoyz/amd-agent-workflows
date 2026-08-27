# Agent contract

이 저장소의 `skills/*/SKILL.md` 가 실행 절차다. 원본 AMD Lab `SKILL.md`의 MCP 호출은 쓰지 않는다.

## 항상

1. MCP 네임스페이스(`vivado-mcp`, `mcp_vivado-*`, `vivado_start`, `vivadoExecute`)를 호출하지 않는다. 도구가 보여도 쓰지 않는다.
2. 긴 작업은 워크스페이스에 `.tcl` 또는 `.py` 하나를 쓰고 batch로 한 번 돌린다. Vivado MCP처럼 한 줄씩 보내지 않는다.
3. Tcl/Python이 실패하면 구문을 바꿔 재시도하지 말고, 에러를 사용자에게 보여 주고 멈춘다.
4. 가드레일(파서, HITL pause, `DONT_TOUCH FALSE`, temp IP `report_property`)은 해당 skill을 따른다.
5. 산출 경로: `<project>/vivado_agentic_ai_reports/<skill-name>/` (Vivado). Vitis/host는 각 skill의 `build/` · `reports/`.

## 도구 고르기

| 사용자 말 | 읽을 skill |
| --- | --- |
| lint, HDL quality, latch | `vivado-rtl-lint` |
| opt_design, DONT_TOUCH가 막음 | `vivado-opt-design` |
| 여러 impl, strategy, WNS 순위 | `vivado-multi-run` |
| AXI 시뮬, protocol, waveform | `vivado-axi4-debug` |
| timing이 왜 깨졌는지 GUI | `vivado-post-route` 먼저, 그다음 `vivado-timing-closure` |
| ILA, chipscope, probe BD | `vivado-bd-ila` |
| VIO, JTAG enable | `vivado-bd-vio` |
| XSA, platform, ELF, Vitis app | `vitis-unified` |
| HLS, csynth, II, pipeline | `vitis-hls` |
| xsct, XSCT Tcl | `vitis-xsct` |
| /dev/xdma, PCIe DMA, BAR | `host-xdma` |
| xclbin, xbutil, OpenCL | `host-xrt` |
| 보드 첫 반입, bit+ELF+host | `host-bringup` |

모드가 헷갈리면 `vivado-modes` 부터.

## 공식 원본

업스트림 클론은 `official/` 이다. 읽기 전용. 고치지 말고 [official/README.md](official/README.md) 의 URL로 확인한다.

## 공식 AMD skill과의 관계

- Vitis HLS 최적화의 긴 루프는 [Xilinx/ai-assisted-vitis `vhls-opt`](https://github.com/Xilinx/ai-assisted-vitis/tree/main/skill-hub/vhls-opt) 를 우선한다. 여기 `vitis-hls` 는 MCP 없는 CLI 최소 세트다.
- XSCT→Python 매핑의 상세는 [xsct-to-python-converter](https://github.com/Xilinx/ai-assisted-vitis/tree/main/skill-hub/xsct-to-python-converter). 여기 `vitis-xsct` 는 배치 실행과 이관 순서만.
