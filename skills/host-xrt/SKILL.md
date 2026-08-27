---
name: host-xrt
description: Load xclbin and run host code with AMD XRT (xbutil, OpenCL or native XRT APIs). Use for Alveo, Versal AIE/PL kernels, and shells — not for raw XDMA character devices.
---

# host-xrt

대상: **XRT 셸**이 있는 가속기(Alveo, 일부 Versal 플랫폼). Bare PCIe XDMA 카드는 `host-xdma`.

```bash
xbutil examine
xbutil validate --device <bdf>    # 사용자 승인 후에만. 길다.
```

`xclbin` 은 Vitis `v++` 링크 산출. Vivado `.bit`만 있다고 XRT 앱이 로드되지 않는다.

## 호스트 앱

1. 디바이스 enumerate (`xcl::device` / `cl::Device`).
2. `xclbin` load.
3. 커널 핸들, BO(buffer object) alloc, 호스트↔디바이스 sync.
4. 커널 실행, 결과 비교.

OpenCL 과 XRT native를 한 파일에서 섞지 말 것. 기존 코드 스타일을 따른다.

환경: `source /opt/xilinx/xrt/setup.sh` (Linux). Windows XRT는 설치 경로를 사용자에게 확인.

## 가드레일

- `xbutil reset` / 플래시 갱신은 사용자 승인 없이 하지 말 것.
- UUID/xclbin이 셸과 안 맞으면 앱을 고치지 말고 xclbin 재빌드.
- 리포트: `reports/xrt.md`에 BDF, xclbin 경로, 커널 이름, PASS/FAIL.

MCP 금지.
