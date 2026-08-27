---
name: vitis-unified
description: Build Vitis Unified platform and application from an XSA using vitis -s Python batch, without MCP or GUI. Use when creating platform.xpfm, standalone/linux domain, importing C sources, or building ELF from a hardware handoff.
---

# vitis-unified

Vivado MCP가 없듯이 **Vitis MCP도 쓰지 않는다.** 한 작업 = 한 `build.py` → `vitis -s build.py`.

Classic Vitis IDE / Eclipse `xsct` 를 새로 쓰지 말 것. 레거시 Tcl만 있으면 `vitis-xsct`로 이관.

환경: `settings64.sh` / `settings64.bat` 후 `vitis --version`. 없으면 사용자에게 경로를 묻는다.

## 흐름

```text
Vivado write_hw_platform / write_hw_platform -fixed  →  .xsa
    ↓
vitis -s build.py
    ↓
workspace/<platform>/export/<platform>/<platform>.xpfm
workspace/<app>/build/*.elf
```

고정 XSA(bitstream 포함) vs extensible XSA(가속기 플랫폼)를 사용자와 확인한다. Embedded SW는 보통 **fixed XSA**.

## `build.py` 골격 (UG1400)

API 이름은 버전에 따라 `hw_design` / `hw` 가 갈린다. 실패하면 에러를 보여 주고 멈춘다. 추측으로 키워드를 바꿔 재시도하지 말 것.

```python
import os
import vitis

XSA = os.path.abspath("design_1_wrapper.xsa")
WS = os.path.abspath("vitis_ws")
os.makedirs(WS, exist_ok=True)

client = vitis.create_client()
client.set_workspace(path=WS)

plat = client.create_platform_component(
    name="plat",
    hw_design=XSA,
    os="standalone",
    cpu="psu_cortexa53_0",          # 보드에 맞게. MicroBlaze면 microblaze_0
    domain_name="standalone_ps",
)
plat.build()

xpfm = os.path.join(WS, "plat", "export", "plat", "plat.xpfm")
app = client.create_app_component(
    name="app",
    platform=xpfm,
    domain="standalone_ps",
)
app.import_files(from_loc="src", files=["main.c"], dest_dir_in_cmp="src")
app.build()
```

```bash
vitis -s build.py
```

Windows: `vitis.bat -s build.py`. 장시간 빌드는 타임아웃을 넉넉히 (10분+).

## 가드레일

- CPU/OS/domain 이름을 XSA의 프로세서 리스트와 맞춘다. 모르면 `platform` 생성 후 에러 메시지를 사용자에게 보여 준다.
- `hello_world` 템플릿은 스모크에만. 제품 소스는 `import_files`.
- bitstream을 Vitis에서 다시 만들지 않는다. Vivado `write_bitstream` / `write_hw_platform` 산출을 쓴다.
- 산출 ELF 경로를 `reports/vitis-unified.md`에 적는다.
