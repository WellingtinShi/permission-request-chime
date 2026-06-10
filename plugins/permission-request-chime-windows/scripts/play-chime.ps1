$ErrorActionPreference = "SilentlyContinue"
$ProgressPreference = "SilentlyContinue"

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
