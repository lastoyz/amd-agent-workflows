# Install skills into user-global Cursor / Claude Code directories.
$ErrorActionPreference = "Stop"
$src = Join-Path $PSScriptRoot "skills"
$targets = @(
    (Join-Path $env:USERPROFILE ".cursor\skills"),
    (Join-Path $env:USERPROFILE ".claude\skills")
)
foreach ($dstRoot in $targets) {
    New-Item -ItemType Directory -Force -Path $dstRoot | Out-Null
    Get-ChildItem -Directory $src | ForEach-Object {
        $dst = Join-Path $dstRoot $_.Name
        if (Test-Path $dst) { Remove-Item -Recurse -Force $dst }
        Copy-Item -Recurse $_.FullName $dst
        Write-Host "installed $($_.Name) -> $dst"
    }
}
Write-Host "Done. Restart Cursor / Claude Code so skills reload."
