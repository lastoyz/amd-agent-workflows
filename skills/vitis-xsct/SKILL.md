---
name: vitis-xsct
description: Run leftover XSCT Tcl with xsct in batch, or migrate it to Vitis Unified Python. Use when the user has old .tcl FSBL/app scripts, mentions XSCT, or classic Vitis SDK. Prefer Python; do not mix xsct and vitis -s in one flow.
---

# vitis-xsct

New work uses `vitis-unified` (`vitis -s`). This skill is **when leftover Tcl already exists**.

Detailed mapping: [Xilinx/ai-assisted-vitis `xsct-to-python-converter`](https://github.com/Xilinx/ai-assisted-vitis/tree/main/skill-hub/xsct-to-python-converter).

## Batch run (existing scripts only)

```bash
xsct -eval "source build.tcl"
# or
xsct build.tcl
```

Do not have the agent attach to an `-interactive` GUI. Write logs to a file.

On failure, do not improvise Tcl edits. Show the error. If `xsct` is not on PATH, use `bin/xsct` from the Vitis install.

## Migration order

1. List `platform`, `domain`, `app`, `sysproj` calls in the existing Tcl.
2. Move them to Unified Python (`create_platform_component`, `create_app_component`, `import_files`, `build`).
3. Mark the XSCT script as a discard candidate only after one successful `vitis -s`.
4. System projects are optional in Unified. Do not clone an XSCT-required structure as-is.

Do not mix `xsct` and `vitis -s` in one build. No MCP.
