# Permission Request Chime

[English](README.md) | 简体中文

Permission Request Chime 是一个 Codex 插件 marketplace，现在包含两个按系统区分的插件。
当 Codex 创建 permission request 审批请求时，插件会播放一声本地提示音，避免你切到
其他窗口后错过审批弹窗。

这两个插件都使用 Codex 的 `PermissionRequest` lifecycle hook。它们不会截图、不会识别窗口标题，
也不会用 OCR 读取屏幕内容。

## 版本选择

只安装与你系统匹配的那个插件：

| 系统 | 要安装的插件 | 提示音命令 |
| --- | --- | --- |
| macOS | `permission-request-chime` | `/bin/sh` + `afplay` |
| Windows | `permission-request-chime-windows` | `powershell.exe` + Windows `.wav` 文件 |

`v0.1.0` 是 macOS-only。`v0.2.0` 开始拆成 macOS / Windows 双版本。
Windows 用户请使用 `v0.2.2` 或更新版本，里面的 `.wav` 播放 hook 更可靠。

## 安装

### 1. 添加 marketplace

推荐使用固定版本：

```text
codex plugin marketplace add WellingtinShi/permission-request-chime --ref v0.2.2
```

如果你想跟随最新开发版本，可以省略 `--ref`：

```text
codex plugin marketplace add WellingtinShi/permission-request-chime
```

不要两条都运行。第一条会固定到稳定 release tag，第二条会跟随仓库默认分支。

### 2. 安装对应插件

上面的命令只是在 Codex 中添加插件来源，也就是 marketplace。命令完成后，打开 Codex 的
plugin directory，只安装一个插件：

- macOS：安装 `permission-request-chime`。
- Windows：安装 `permission-request-chime-windows`。

不建议在同一台机器上同时安装两个版本，除非你明确想让两个 hook 都运行。

### 3. 重启并 trust

安装后重启 Codex。因为插件包含 command hook，第一次触发时 Codex 会要求你 review 并 trust
这个 hook。

## 让 Codex 帮你安装

可以把下面对应系统的文字粘贴到本地 Codex 对话框里。

macOS：

```text
请帮我添加 Permission Request Chime marketplace，并运行：

codex plugin marketplace add WellingtinShi/permission-request-chime --ref v0.2.2

运行完成后，请提醒我去 Codex plugin directory 安装 permission-request-chime。
```

Windows：

```text
请帮我添加 Permission Request Chime marketplace，并运行：

codex plugin marketplace add WellingtinShi/permission-request-chime --ref v0.2.2

运行完成后，请提醒我去 Codex plugin directory 安装 permission-request-chime-windows。
```

Codex 可能会弹出 permission request。确认你想添加这个插件来源后，批准即可。

## 它们会做什么

两个版本都会：

- 匹配所有 Codex `PermissionRequest` 事件，配置为 `matcher: "*"`。
- 在 Codex 创建审批请求时播放本地提示音。
- 第一次运行前需要 review / trust hook。

macOS 版：

- 默认用 `afplay` 播放 `/System/Library/Sounds/Glass.aiff`。
- 如果 `afplay` 不可用，会尝试 `osascript -e "beep 1"`。
- 如果还是不可用，会尝试 terminal bell。

Windows 版：

- 运行 `powershell.exe`。
- 如果 `CODEX_PERMISSION_CHIME_SOUND` 指向可读 `.wav` 文件，会播放该文件。
- 否则会尝试播放 `C:\Windows\Media` 里的常见 Windows `.wav` 文件。
- 如果失败，会尝试 `SystemSounds.Exclamation`。
- 最后 fallback 到 `[Console]::Beep(...)`。

## 自定义提示音

macOS：

```bash
export CODEX_PERMISSION_CHIME_SOUND=/System/Library/Sounds/Ping.aiff
```

常见 macOS 系统音效：

- `/System/Library/Sounds/Glass.aiff`
- `/System/Library/Sounds/Ping.aiff`
- `/System/Library/Sounds/Pop.aiff`
- `/System/Library/Sounds/Submarine.aiff`

Windows：

```powershell
$env:CODEX_PERMISSION_CHIME_SOUND = "C:\Windows\Media\Windows Notify System Generic.wav"
```

Windows 自定义声音建议使用 PowerShell 可读取的 `.wav` 文件。

如果你直接修改 hook 命令，需要重启 Codex，并重新 trust 更新后的 hook。

## 测试

可以让 Codex 触发一个无害的权限申请。

macOS：

```bash
/bin/date
```

Windows：

```powershell
powershell.exe -NoProfile -Command Get-Date
```

预期行为：

1. Codex 创建 permission request。
2. 你安装的插件 hook 播放提示音。
3. 你批准后，无害命令输出当前日期和时间。

更多排查说明见 `docs/testing.md`。

## 安全说明

这两个插件都包含非 managed command hook。Codex 会根据 hook 的精确内容记录 trust 状态，
所以 hook 内容变更后需要重新 review 和 trust。

默认 hook 命令只会尝试播放本地声音文件、系统声音、beep 或 terminal bell。trust 前可以先查看：

- macOS：`plugins/permission-request-chime/hooks/hooks.json`
- Windows：`plugins/permission-request-chime-windows/hooks/hooks.json`

## 仓库结构

```text
.
├── .agents/plugins/marketplace.json
├── README.md
├── README.zh-CN.md
├── docs/
│   ├── publishing.md
│   └── testing.md
└── plugins/
    ├── permission-request-chime/
    │   ├── .codex-plugin/plugin.json
    │   ├── README.md
    │   ├── hooks/hooks.json
    │   └── skills/permission-request-chime/SKILL.md
    └── permission-request-chime-windows/
        ├── .codex-plugin/plugin.json
        ├── README.md
        ├── hooks/hooks.json
        └── skills/permission-request-chime-windows/SKILL.md
```

## License

MIT
