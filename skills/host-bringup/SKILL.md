---
name: host-bringup
description: Align Vivado bitstream/XSA, Vitis ELF, and host software into one bring-up sequence. Use for first board power-on, DMA loopback, or when the user asks which artifact to program in which order.
---

# host-bringup

보드 반입은 세 산출물이 같은 리비전이어야 한다. 섞지 말 것.

```text
Vivado  (vivado-modes / 해당 skill)
    → .bit / .pdi  +  .xsa (fixed)
Vitis   (vitis-unified)
    → .elf  (+ boot.bin / BOOT.BIN 이면 그 패키지)
host_sw (host-xdma 또는 host-xrt)
    → 유저 앱
```

## 순서

1. **하드웨어 ID 확인**: part, PCIe ID, BAR 크기, DMA IP(XDMA vs AXI DMA vs QDMA vs XRT). 사용자/XSA/xsa.xml과 맞춘다.
2. **FPGA 프로그래밍**: JTAG(`vivado` HW Manager 또는 `program_hw_devices`) 또는 플래시/SD BOOT.BIN. 호스트 드라이버보다 **먼저**.
3. **펌웨어**: MicroBlaze/PS ELF는 xsdb/`launch_hw` 또는 부트로더. PCIe endpoint만 있으면 ELF가 없을 수 있다.
4. **호스트**: `lspci` / Device Manager 후 XDMA 또는 XRT 스킬.
5. **스모크**: BAR scratch 또는 작은 DMA loopback. 실패하면 앱을 키우지 말고 멈춘다.

## 리포트

`reports/bringup.md`에 기록:

- Vivado 프로젝트·commit·bit 경로
- XSA 경로·생성 시각
- ELF 경로
- 호스트 앱 커맨드와 결과 (PASS/FAIL)

드라이버 종류가 불명확하면 추측하지 말고 묻는다. MCP 금지.
