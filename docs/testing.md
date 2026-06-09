# Testing

## 安装验证

公开 marketplace 安装命令：

```bash
codex plugin marketplace add WellingtinShi/permission-request-chime
```

如果要固定稳定版本：

```bash
codex plugin marketplace add WellingtinShi/permission-request-chime --ref v0.1.0
```

然后在 Codex plugin directory 中安装 `permission-request-chime`，重启 Codex，
并在 hook review 中 trust 这个 `PermissionRequest` command hook。

## 无害权限申请测试

可以让 Codex 发起一个只读、无副作用的 escalated command，例如：

```bash
/bin/date
```

预期行为：

1. Codex 弹出 permission request 审批窗口。
2. `permission-request-chime` 的 `PermissionRequest` hook 被触发。
3. 系统播放 `/System/Library/Sounds/Glass.aiff`。
4. 用户批准后，命令输出当前时间。

## 如果没有声音

检查这些点：

- 插件是否已经安装并启用。
- Codex 是否已经重启。
- `PermissionRequest` hook 是否已经被 trust。
- 系统是否静音，输出设备是否可用。
- `hooks` 功能是否被配置关闭。
- 目标声音文件是否存在且可读。

## 手动检查 hook 命令

hook 配置在：

```text
plugins/permission-request-chime/hooks/hooks.json
```

默认命令会读取环境变量 `CODEX_PERMISSION_CHIME_SOUND`。如果没有设置，就使用：

```text
/System/Library/Sounds/Glass.aiff
```
