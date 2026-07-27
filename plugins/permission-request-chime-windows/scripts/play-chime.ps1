$ErrorActionPreference = "SilentlyContinue"
$ProgressPreference = "SilentlyContinue"

function Get-ApprovalsReviewer {
    try {
        $hookText = [Console]::In.ReadToEnd()
        if ([string]::IsNullOrWhiteSpace($hookText)) {
            return $null
        }

        $hookInput = $hookText | ConvertFrom-Json
        $transcriptPath = [string]$hookInput.transcript_path
        $turnId = [string]$hookInput.turn_id
        if (-not $transcriptPath -or -not $turnId -or
            -not (Test-Path -LiteralPath $transcriptPath -PathType Leaf)) {
            return $null
        }

        $needle = '"turn_id":"' + $turnId + '"'
        $reviewer = $null
        foreach ($line in [System.IO.File]::ReadLines($transcriptPath)) {
            if (-not $line.Contains('"type":"turn_context"') -or
                -not $line.Contains($needle)) {
                continue
            }

            try {
                $entry = $line | ConvertFrom-Json
                if ($entry.type -eq "turn_context" -and
                    [string]$entry.payload.turn_id -eq $turnId) {
                    $reviewer = [string]$entry.payload.approvals_reviewer
                }
            } catch {}
        }

        return $reviewer
    } catch {
        return $null
    }
}

$reviewer = Get-ApprovalsReviewer
if ($reviewer -eq "auto_review" -or $reviewer -eq "guardian_subagent") {
    exit 0
}

if ($env:CODEX_PERMISSION_CHIME_DRY_RUN -eq "1") {
    Write-Output "chime"
    exit 0
}

$media = Join-Path $env:WINDIR "Media"
$candidates = @()
if ($env:CODEX_PERMISSION_CHIME_SOUND) {
    $candidates += $env:CODEX_PERMISSION_CHIME_SOUND
}
$candidates += (Join-Path $media "Windows Notify System Generic.wav")
$candidates += (Join-Path $media "Windows Ding.wav")

foreach ($sound in $candidates) {
    if (-not $sound) { continue }
    if (-not (Test-Path -LiteralPath $sound)) { continue }

    try {
        $player = New-Object System.Media.SoundPlayer $sound
        $player.Load()
        $player.PlaySync()
        exit 0
    } catch {}
}

try {
    [System.Media.SystemSounds]::Exclamation.Play()
    Start-Sleep -Milliseconds 450
    exit 0
} catch {}

try {
    [Console]::Beep(880, 180)
} catch {}

exit 0
