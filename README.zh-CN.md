# Permission Request Chime

[English](README.md) | 简体中文

Permission Request Chime 是一个 Codex 插件。Codex 把 permission request
交给你审批时，它会播放一声本地提示音，避免 Codex 在后台安静等待，你却没有发现。
由自动审批处理的请求会保持安静。

它使用 Codex 的 `PermissionRequest` lifecycle hook，并读取当前 turn 的本地
`approvals_reviewer` 元数据，用来区分用户审批和自动审批。它不会截图，不会识别窗口标题，
不会用 OCR 读取屏幕，也不会发起网络请求。

## 快速安装

添加 marketplace：

```text
codex plugin marketplace add WellingtinShi/permission-request-chime --ref stable
```

然后打开 Codex plugin directory，只安装与你系统匹配的那个插件：

| 系统 | 安装这个插件 |
| --- | --- |
| macOS | `permission-request-chime` |
| Windows | `permission-request-chime-windows` |

安装后重启 Codex。第一次触发时，Codex 会要求你 review 并 trust 这个 hook。

不要在同一台机器上同时安装两个插件，除非你明确想让两个 hook 都运行。

## 让 Codex 帮你安装

也可以把下面这段话粘贴到本地 Codex 对话里：

```text
请帮我添加 Permission Request Chime marketplace，并运行：

codex plugin marketplace add WellingtinShi/permission-request-chime --ref stable

运行完成后，请提醒我打开 Codex plugin directory，并按系统安装一个插件：
macOS：permission-request-chime
Windows：permission-request-chime-windows
```

## 升级

如果你用 `--ref stable` 添加 marketplace，可以不卸载插件，直接刷新：

```text
codex plugin marketplace upgrade permission-request-chime
```

升级后重启 Codex。如果 Codex 要求 review / trust 更新后的 hook，请先 trust，再测试提示音。

如果你之前固定到了旧 tag，例如 `v0.2.1`，先切换到 `stable`：

```text
codex plugin marketplace remove permission-request-chime
codex plugin marketplace add WellingtinShi/permission-request-chime --ref stable
```

如果你需要完全固定的可复现安装，可以使用最新 release tag：

```text
codex plugin marketplace add WellingtinShi/permission-request-chime --ref v0.2.4
```

## 它会做什么

两个插件都会匹配 Codex `PermissionRequest` 事件，配置为 `matcher: "*"`。新版 Codex
会先触发这个 hook，再决定交给自动审批还是用户审批，因此脚本会先检查当前 turn
的审批来源。`auto_review` 会静音；交给用户的请求才会播放。旧版 Codex
如果没有审批来源元数据，会保留原来的响铃行为。

macOS：

- 运行 `scripts/play-chime.sh`。
- 默认用 `afplay` 播放 `/System/Library/Sounds/Glass.aiff`。
- 如果 `afplay` 不可用，会尝试 `osascript -e "beep 1"`。
- 如果还是不可用，会尝试 terminal bell。

Windows：

- 运行 `scripts/play-chime.ps1` 的 encoded 副本，避免 Windows 引号解析问题。
- 如果 `CODEX_PERMISSION_CHIME_SOUND` 指向可读 `.wav` 文件，会播放该文件。
- 否则播放 `C:\Windows\Media` 里的短 `.wav` 文件。
- 最后 fallback 到 `SystemSounds.Exclamation` 和 `[Console]::Beep(...)`。

## 自定义提示音

macOS：

```bash
export CODEX_PERMISSION_CHIME_SOUND=/System/Library/Sounds/Ping.aiff
```

Windows：

```powershell
$env:CODEX_PERMISSION_CHIME_SOUND = "C:\Windows\Media\Windows Notify System Generic.wav"
```

如果你直接修改 hook 命令，需要重启 Codex，并重新 trust 更新后的 hook。

## 测试

先把 Codex 设为“请求批准”，再触发一个无害的权限申请。

macOS：

```bash
/bin/date
```

Windows：

```powershell
powershell.exe -NoProfile -Command Get-Date
```

预期行为：

1. Codex 把 permission request 交给你审批。
2. 已安装插件播放提示音。
3. 批准后，命令输出当前日期和时间。

切换到“自动审批”后，同类请求应该保持安静。

## 安全说明

这两个插件都包含非 managed command hook，所以 Codex 会要求你明确 trust 后才运行。
trust 前可以先查看 hook：

- macOS：`plugins/permission-request-chime/hooks/hooks.json`
- Windows：`plugins/permission-request-chime-windows/hooks/hooks.json`

两个 hook 的可读播放脚本分别保存在：

- macOS：`plugins/permission-request-chime/scripts/play-chime.sh`
- Windows：`plugins/permission-request-chime-windows/scripts/play-chime.ps1`

## 没有声音怎么办

先检查这些点：

- 是否安装并启用了对应系统的插件。
- 安装或升级后是否已经重启 Codex。
- hook 是否已经 review / trust。
- 系统是否静音，输出设备是否正常。
- Windows focus assist 或音量混音器是否拦截了声音。

更多排查见 `docs/testing.md`。

## License

MIT
