# Conversation Summary

## 背景

用户发现 Codex 在出现 permission request 审批弹窗时没有明显提示音，担心错过需要批准的操作。

## 讨论结论

最稳妥的方案不是监听屏幕或识别弹窗，而是使用 Codex 支持的 lifecycle hook：
`PermissionRequest`。这个 hook 会在 Codex 创建权限申请时触发，matcher 可以匹配所有工具名。

## 当前产品设计

`v0.1.0` 是 macOS-only。`v0.2.0` 改成双版本，`v0.2.2` 改进 Windows hook：

- macOS：`permission-request-chime`
- Windows：`permission-request-chime-windows`

用户添加同一个 marketplace，然后在 Codex plugin directory 中按系统安装一个插件。不要两个一起装，
除非明确想让两个 hook 都运行。

## 已实现内容

- `.agents/plugins/marketplace.json` 中包含两个插件入口。
- macOS 插件位于 `plugins/permission-request-chime/`。
- Windows 插件位于 `plugins/permission-request-chime-windows/`。
- 两个插件都使用 `PermissionRequest` 事件和 `matcher: "*"`。
- macOS hook 使用 `/bin/sh`、`afplay`、`/System/Library/Sounds/Glass.aiff`，并 fallback 到
  `osascript -e "beep 1"` 和 terminal bell。
- Windows hook 使用 `powershell.exe`，优先播放 `CODEX_PERMISSION_CHIME_SOUND` 指向的 `.wav`
  文件，否则尝试 `C:\Windows\Media` 中的常见 `.wav` 文件，再 fallback 到
  `SystemSounds.Exclamation` 和 `[Console]::Beep(...)`。
- 顶层 README、中文 README、插件内 README、testing/publishing 文档都已改为双版本说明。
- X 宣传文案和配图已改为 macOS / Windows 双版本。
- 小红书文案和 6 张 Guizang/Swiss 风格配图已改为 macOS / Windows 双版本。

## 验证记录

- JSON 文件可解析。
- macOS hook shell 命令可做语法检查。
- Windows hook PowerShell 命令已写入插件，但需要在 Windows 机器上做真实播放验证。
- 小红书配图尺寸为 1080x1440，guizang 自动版式检查为 0 fail。
- X 配图尺寸为 1600x900，并已人工检查无文字截断。

## 安装命令

固定版本：

```text
codex plugin marketplace add WellingtinShi/permission-request-chime --ref v0.2.2
```

安装插件：

- macOS：`permission-request-chime`
- Windows：`permission-request-chime-windows`

## 关闭方式

推荐方式：在 Codex app 的 Plugins 管理页面中 Disable 或 Uninstall 对应插件，再重启 Codex。

备选方式：在 hook 管理界面中禁用对应的 `PermissionRequest` hook。
