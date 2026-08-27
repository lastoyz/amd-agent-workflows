---
name: vitis-xsct
description: Run leftover XSCT Tcl with xsct in batch, or migrate it to Vitis Unified Python. Use when the user has old .tcl FSBL/app scripts, mentions XSCT, or classic Vitis SDK. Prefer Python; do not mix xsct and vitis -s in one flow.
---

# vitis-xsct

새 작업은 `vitis-unified` (`vitis -s`). 이 스킬은 **레거시 Tcl이 이미 있을 때**.

상세 매핑: [Xilinx/ai-assisted-vitis `xsct-to-python-converter`](https://github.com/Xilinx/ai-assisted-vitis/tree/main/skill-hub/xsct-to-python-converter).

## 배치 실행 (있는 스크립트만)

```bash
xsct -eval "source build.tcl"
# 또는
xsct build.tcl
```

`-interactive` GUI를 에이전트가 붙잡지 말 것. 로그를 파일로 남긴다.

실패하면 Tcl을 즉흥 수정하지 말고 에러를 보여 준다. `xsct`가 PATH에 없으면 Vitis 설치의 `bin/xsct`.

## 이관 순서

1. 기존 Tcl에서 `platform`, `domain`, `app`, `sysproj` 호출을 목록화.
2. Unified Python으로 옮긴다 (`create_platform_component`, `create_app_component`, `import_files`, `build`).
3. `vitis -s` 로 한 번 성공한 뒤에야 XSCT 스크립트를 폐기 후보로 표시.
4. 시스템 프로젝트는 Unified에서 optional. XSCT에서 필수로 만든 구조를 그대로 복제하지 말 것.

한 빌드에서 `xsct`와 `vitis -s`를 섞지 말 것. MCP 금지.
