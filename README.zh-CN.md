# Permission Request Chime

[English](README.md) | 简体中文

Permission Request Chime 是一个 Codex 插件。它会在 Codex 创建 permission
request 审批请求时播放一声本地提示音，避免你切到其他窗口后错过审批弹窗。

这个插件使用 Codex 的 `PermissionRequest` lifecycle hook。它不会截图、不会识别窗口标题，
也不会用 OCR 读取屏幕内容。

## 安装

请选择一种安装方式。

### 方式一：在终端运行

大多数用户推荐使用固定版本安装。打开 Terminal / iTerm，运行：

```bash
codex plugin marketplace add WellingtinShi/permission-request-chime --ref v0.1.0
```

如果你想跟随最新开发版本，可以省略 `--ref`：

```bash
codex plugin marketplace add WellingtinShi/permission-request-chime
```

不要两条都运行。第一条会固定到稳定 release tag，第二条会跟随仓库默认分支。

### 方式二：让 Codex 帮你运行

你也可以把下面这段话粘贴到本地 Codex 对话框里，让 Codex 代为执行安装命令：

```text
请帮我安装 Permission Request Chime 插件 marketplace，并运行：

codex plugin marketplace add WellingtinShi/permission-request-chime --ref v0.1.0
```

Codex 可能会弹出 permission request。确认你想安装这个插件来源后，批准即可。

### 完成安装

上面的命令只是在 Codex 中添加插件来源，也就是 marketplace。命令完成后，还需要：

1. 打开 Codex 的 plugin directory。
2. 选择 `Permission Request Chime` marketplace。
3. 安装 `permission-request-chime` 插件。
4. 重启 Codex。
5. 第一次触发时，review 并 trust 这个 command hook。

## 它会做什么

- 匹配所有 Codex `PermissionRequest` 事件，配置为 `matcher: "*"`。
- 在 macOS 上默认用 `afplay` 播放 `/System/Library/Sounds/Glass.aiff`。
- 如果 `afplay` 不可用，会尝试 `osascript -e "beep 1"`。
- 如果还是不可用，会尝试 terminal bell。

hook 配置文件在：

```text
plugins/permission-request-chime/hooks/hooks.json
```

## 自定义提示音

启动 Codex 前设置 `CODEX_PERMISSION_CHIME_SOUND`：

```bash
export CODEX_PERMISSION_CHIME_SOUND=/System/Library/Sounds/Ping.aiff
```

常见 macOS 系统音效：

- `/System/Library/Sounds/Glass.aiff`
- `/System/Library/Sounds/Ping.aiff`
- `/System/Library/Sounds/Pop.aiff`
- `/System/Library/Sounds/Submarine.aiff`

如果你直接修改 hook 命令，需要重启 Codex，并重新 trust 更新后的 hook。

## 测试

可以让 Codex 触发一个无害的权限申请，例如请求它运行：

```bash
/bin/date
```

预期行为：

1. Codex 创建 permission request。
2. 插件 hook 播放提示音。
3. 你批准后，`/bin/date` 输出当前日期和时间。

更多排查说明见 `docs/testing.md`。

## 安全说明

这个插件包含一个非 managed command hook。Codex 会根据 hook 的精确内容记录 trust 状态，
所以 hook 内容变更后需要重新 review 和 trust。

默认 hook 命令只会尝试播放本地声音文件、系统 beep 或 terminal bell。trust 前可以先查看：

```text
plugins/permission-request-chime/hooks/hooks.json
```

## 仓库结构

```text
.
├── .agents/plugins/marketplace.json
├── README.md
├── README.zh-CN.md
├── docs/
│   ├── conversation-summary.md
│   └── testing.md
└── plugins/
    └── permission-request-chime/
        ├── .codex-plugin/plugin.json
        ├── README.md
        ├── hooks/hooks.json
        └── skills/permission-request-chime/SKILL.md
```

## License

MIT
