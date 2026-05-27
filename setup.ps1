# Claude Workflows 설치 스크립트 (Windows PowerShell)
#
# 사용법 1 — 저장소 clone 후:
#   git clone https://github.com/jaeyeoloh/claude-workflows
#   pwsh claude-workflows/setup.ps1
#
# 사용법 2 — 한 줄 설치:
#   irm https://raw.githubusercontent.com/jaeyeoloh/claude-workflows/main/setup.ps1 | iex

$ErrorActionPreference = "Stop"

$ClaudeDir = "$HOME\.claude"
$Repo      = "https://raw.githubusercontent.com/jaeyeoloh/claude-workflows/main"

# ── 실행 위치 감지 ────────────────────────────────────────────────────────────
$ScriptRoot = if ($PSScriptRoot) { $PSScriptRoot } else { $PWD.Path }
$UseLocal   = Test-Path "$ScriptRoot\commands\new-project.md"

Write-Host ""
Write-Host "🤖  Claude Workflows 설치" -ForegroundColor Cyan
Write-Host "─────────────────────────────"

function Install-File {
    param($RelPath, $Dest, $Label)

    if (Test-Path $Dest) {
        Write-Host "  ⏭  $Label (이미 존재 — 건너뜀)" -ForegroundColor DarkGray
        return
    }

    $dir = Split-Path $Dest -Parent
    New-Item -ItemType Directory -Force -Path $dir | Out-Null

    if ($UseLocal) {
        Copy-Item "$ScriptRoot\$($RelPath.Replace('/', '\'))" -Destination $Dest
    } else {
        Invoke-WebRequest "$Repo/$RelPath" -OutFile $Dest -UseBasicParsing
    }

    Write-Host "  ✅  $Label" -ForegroundColor Green
}

# ── 커맨드 설치 ───────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "📌 슬래시 커맨드"

if ($UseLocal) {
    Get-ChildItem "$ScriptRoot\commands\*.md" | ForEach-Object {
        Install-File "commands/$($_.Name)" "$ClaudeDir\commands\$($_.Name)" "/$($_.BaseName)"
    }
} else {
    Install-File "commands/new-project.md" "$ClaudeDir\commands\new-project.md" "/new-project"
}

# ── 템플릿 설치 ───────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "📋 템플릿"

Install-File "templates/platform-playbook.md" `
    "$ClaudeDir\templates\platform-playbook.md" `
    "platform-playbook.md → ~/.claude/templates/"

Install-File "templates/CLAUDE.md" `
    "$ClaudeDir\CLAUDE.md" `
    "CLAUDE.md → ~/.claude/ (글로벌 행동 규칙)"

# ── settings.json (auto mode) ─────────────────────────────────────────────────
Write-Host ""
Write-Host "⚙️  설정"

$SettingsPath = "$ClaudeDir\settings.json"
if (Test-Path $SettingsPath) {
    Write-Host "  ⏭  settings.json (이미 존재 — 건너뜀)" -ForegroundColor DarkGray
} else {
    New-Item -ItemType Directory -Force -Path $ClaudeDir | Out-Null
    '{"permissions":{"defaultMode":"auto"}}' | Set-Content -Path $SettingsPath -Encoding utf8
    Write-Host "  ✅  settings.json (auto mode 활성화)" -ForegroundColor Green
}

# ── 완료 ──────────────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "─────────────────────────────"
Write-Host "🎉  설치 완료! Claude Code를 재시작하면 적용됩니다." -ForegroundColor Cyan
Write-Host ""
Write-Host "사용 가능한 커맨드:"
Get-ChildItem "$ClaudeDir\commands\*.md" -ErrorAction SilentlyContinue | ForEach-Object {
    Write-Host "  /$($_.BaseName)"
}
Write-Host ""
