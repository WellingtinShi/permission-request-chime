# 小红书发布文案（macOS / Windows 双版本）

## 推荐标题

我把 Codex 提示音插件拆成 macOS / Windows 两版

## 备选标题

- Codex 等你批准时，macOS 和 Windows 都能响一声了
- Permission Request Chime 现在有 Windows 版了
- 别让 Codex 在后台干等：提示音插件 v0.2.4

## 图片顺序

1. `assets/xiaohongshu-guizang/output/xhs-01.png` - 封面：现在分成两版
2. `assets/xiaohongshu-guizang/output/xhs-02.png` - 为什么拆两版
3. `assets/xiaohongshu-guizang/output/xhs-03.png` - macOS 版
4. `assets/xiaohongshu-guizang/output/xhs-04.png` - Windows 版
5. `assets/xiaohongshu-guizang/output/xhs-05.png` - 安装方式
6. `assets/xiaohongshu-guizang/output/xhs-06.png` - trust 前看 hook

## 正文

```text
之前这个小插件，默认其实更适合 macOS。

它用的是 afplay 和 macOS 系统声音。
Windows 用户直接装，很可能没有声音。

这点不能含糊。

我把 Permission Request Chime 改成两个版本了：

macOS：
permission-request-chime

Windows：
permission-request-chime-windows

用途还是那个用途。

Codex 把 permission request 交给你审批时，本地响一声。
听到声音，再回来点 Allow。
自动审批处理的请求保持安静。

不截图。
不识别窗口。
不跑 OCR。

用的是 Codex 自己的 PermissionRequest hook。

macOS 版走 /bin/sh + afplay。
默认播放 Glass.aiff。

Windows 版走 PowerShell。
优先播放 C:\Windows\Media 里的真实 .wav 文件。
也可以把 CODEX_PERMISSION_CHIME_SOUND 指到自己的 .wav 文件。

安装 marketplace：

codex plugin marketplace add WellingtinShi/permission-request-chime --ref v0.2.4

这条命令只是添加插件来源。

后面还要去 Codex plugin directory，按自己的系统安装一个：

macOS：
permission-request-chime

Windows：
permission-request-chime-windows

不要两个一起装。

第一次触发时，Codex 会让你 review / trust hook。
这个步骤要认真看。
两个版本的 hooks.json 都在开源仓库里。

GitHub：
https://github.com/WellingtinShi/permission-request-chime

中文说明：
https://github.com/WellingtinShi/permission-request-chime/blob/main/README.zh-CN.md
```

## 置顶评论

```text
安装命令：

codex plugin marketplace add WellingtinShi/permission-request-chime --ref v0.2.4

命令只是添加 marketplace。
之后去 Codex plugin directory 里按系统安装一个：

macOS：permission-request-chime
Windows：permission-request-chime-windows

安装后重启 Codex，首次触发时 trust hook。
```

## 评论区短回复

```text
Q：Windows 现在能直接用了吗？
A：用 Windows 版：permission-request-chime-windows。它走 powershell.exe，优先播放 Windows 自带 .wav 文件。

Q：macOS 还用原来的插件名吗？
A：对，macOS 还是 permission-request-chime。

Q：为什么不能一个插件同时兼容？
A：默认声音命令不同。macOS 用 afplay，Windows 用 PowerShell。拆开后更清楚，也更不容易装错。

Q：安全吗？
A：它是本地 command hook，所以第一次会要求 trust。默认命令只播放本地声音。trust 前可以看 hooks.json。
```

## 标签

```text
#Codex #AI编程 #程序员工具 #开源项目 #效率工具 #Windows工具 #macOS工具 #独立开发
```

## 发布建议

- 首图用 `xhs-01.png`。
- 正文第一屏先承认旧版偏 macOS，不绕。
- 安装命令放正文中段和置顶评论各一次。
- 有人问 Windows，直接回第 4 张图。
- 有人问安全，直接回第 6 张图。
