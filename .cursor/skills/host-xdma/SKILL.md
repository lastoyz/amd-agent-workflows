---
name: host-xdma
description: Write or run PCIe XDMA userspace tests against /dev/xdma* (Linux) or the Windows XDMA driver. Use for H2C/C2H DMA, user BAR mmap, and AXI-lite register peek/poke. Not for XRT/xclbin Alveo flows.
---

# host-xdma

대상: AMD/Xilinx **DMA/Bridge Subsystem for PCI Express (XDMA)** 를 endpoint로 쓰는 카드. Alveo `xclbin` 은 `host-xrt`.

레퍼런스 드라이버: [Xilinx/dma_ip_drivers](https://github.com/Xilinx/dma_ip_drivers) `XDMA/linux-kernel`.

## Linux 디바이스

프로그래밍·리부트 후:

```text
/dev/xdma0_h2c_0     host → card DMA
/dev/xdma0_c2h_0     card → host DMA
/dev/xdma0_user      user BAR (AXI-lite 등)
/dev/xdma0_bypass    bypass BAR (있으면)
/dev/xdma0_events_0  인터럽트
```

없으면 `lspci -d 10ee:` 와 `dmesg | grep -i xdma`. 모듈 미로드면 드라이버부터. Windows는 벤더 XDMA inf/sys — 경로를 사용자에게 확인.

## 앱 규칙

- 오프셋·길이는 **IP 주소맵**(Vivado BD Address Editor)과 일치. 매직 넘버 추측 금지.
- DMA: `h2c`에 write, `c2h`에 read. 길이는 정렬(보통 64B/4KB)을 IP 설정에 맞춘다.
- 레지스터: `user` fd에 `pread`/`pwrite` 또는 mmap. 폭은 32/64를 맵에 맞게.
- 큰 버퍼는 hugepage/정렬 `posix_memalign`.
- 한 번에 전체 프레임워크를 생성하지 말 것. 먼저 4B scratch, 그다음 4KB DMA.

최소 스모크 (개념):

```bash
# user BAR 오프셋은 맵을 확인한 뒤에만
python -c "import os; os.pwrite(os.open('/dev/xdma0_user', os.O_RDWR), b'\\x01\\x00\\x00\\x00', OFFSET)"
```

C는 드라이버 레포 `tools/`의 `dma_to_device` / `dma_from_device` 패턴을 따른다.

실패 시: 디바이스 노드 → `lspci` BAR → FPGA가 해당 bit인지. 앱 재작성으로 우회하지 말 것. MCP 금지.
