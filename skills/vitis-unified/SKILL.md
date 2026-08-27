---
name: vitis-unified
description: Build Vitis Unified platform and application from an XSA using vitis -s Python batch, without MCP or GUI. Use when creating platform.xpfm, standalone/linux domain, importing C sources, or building ELF from a hardware handoff.
---

# vitis-unified

Same as Vivado: **do not use a Vitis MCP either.** One job = one `build.py` → `vitis -s build.py`.

Do not start new work with Classic Vitis IDE / Eclipse `xsct`. If only legacy Tcl exists, migrate with `vitis-xsct`.

Environment: run `settings64.sh` / `settings64.bat`, then `vitis --version`. If missing, ask the user for the path.

## Flow

```text
Vivado write_hw_platform / write_hw_platform -fixed  →  .xsa
    ↓
vitis -s build.py
    ↓
workspace/<platform>/export/<platform>/<platform>.xpfm
workspace/<app>/build/*.elf
```

Confirm with the user: fixed XSA (includes bitstream) vs extensible XSA (accelerator platform). Embedded SW is usually a **fixed XSA**.

## `build.py` skeleton (UG1400)

API names split by version: `hw_design` vs `hw`. On failure, show the error and stop. Do not retry by guessing keywords.

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
    cpu="psu_cortexa53_0",          # match the board. MicroBlaze → microblaze_0
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

Windows: `vitis.bat -s build.py`. Give long builds a generous timeout (10 min+).

## Guardrails

- Match CPU/OS/domain names to the processor list in the XSA. If unknown, create the `platform` and show the error to the user.
- `hello_world` template is smoke-only. Product sources go through `import_files`.
- Do not rebuild the bitstream in Vitis. Use Vivado `write_bitstream` / `write_hw_platform` outputs.
- Write the output ELF path in `reports/vitis-unified.md`.
