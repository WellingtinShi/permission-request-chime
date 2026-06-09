# Testing

## 安装验证

普通用户推荐在终端运行固定版本安装命令：

```bash
codex plugin marketplace add WellingtinShi/permission-request-chime --ref v0.1.0
```

开发或跟随最新 `main` 分支时，可以省略 `--ref`：

```bash
codex plugin marketplace add WellingtinShi/permission-request-chime
```

不要两条都运行。第一条会固定在稳定 release tag，第二条会跟随默认分支。

也可以把下面这段粘贴到本地 Codex 对话里，让 Codex 代为执行命令：

```text
Please install the Permission Request Chime plugin marketplace by running:

codex plugin marketplace add WellingtinShi/permission-request-chime --ref v0.1.0
```

如果 Codex 弹出 permission request，需要批准后才会真正运行命令。

marketplace 命令只负责添加插件来源。然后还需要在 Codex plugin directory 中安装
`permission-request-chime`，重启 Codex，并在 hook review 中 trust 这个
`PermissionRequest` command hook。

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
