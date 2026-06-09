# Testing

## 安装验证

普通用户推荐固定到 `v0.2.1` 或更新版本：

```text
codex plugin marketplace add WellingtinShi/permission-request-chime --ref v0.2.1
```

开发或跟随最新 `main` 分支时，可以省略 `--ref`：

```text
codex plugin marketplace add WellingtinShi/permission-request-chime
```

不要两条都运行。第一条会固定在稳定 release tag，第二条会跟随默认分支。

marketplace 命令只负责添加插件来源。然后在 Codex plugin directory 中按系统安装一个插件：

- macOS：`permission-request-chime`
- Windows：`permission-request-chime-windows`

安装后重启 Codex，并在 hook review 中 trust 对应的 `PermissionRequest` command hook。

## 无害权限申请测试

可以让 Codex 发起一个只读、无副作用的 escalated command。

macOS：

```bash
/bin/date
```

Windows：

```powershell
powershell.exe -NoProfile -Command Get-Date
```

预期行为：

1. Codex 弹出 permission request 审批窗口。
2. 已安装插件的 `PermissionRequest` hook 被触发。
3. 系统播放提示音。
4. 用户批准后，命令输出当前时间。

## 如果没有声音

检查这些点：

- 是否安装了与你系统匹配的插件。
- 是否只安装了一个版本。
- Codex 是否已经重启。
- `PermissionRequest` hook 是否已经被 trust。
- 系统是否静音，输出设备是否可用。
- hooks 功能是否被配置关闭。
- 自定义声音文件是否存在且可读。

macOS 额外检查：

- `/usr/bin/afplay` 是否可用。
- 默认声音文件 `/System/Library/Sounds/Glass.aiff` 是否存在。

Windows 额外检查：

- `powershell.exe` 是否可用。
- 如果设置了 `CODEX_PERMISSION_CHIME_SOUND`，它是否指向 `.wav` 文件。
- Windows focus assist 或系统静音是否拦截提示音。

## 手动检查 hook 命令

macOS hook：

```text
plugins/permission-request-chime/hooks/hooks.json
```

Windows hook：

```text
plugins/permission-request-chime-windows/hooks/hooks.json
```

默认命令会读取环境变量 `CODEX_PERMISSION_CHIME_SOUND`。如果没有设置，macOS 会使用
`/System/Library/Sounds/Glass.aiff`，Windows 会优先使用 `CODEX_PERMISSION_CHIME_SOUND`
或 `C:\Windows\Media` 里的常见 `.wav` 文件。
