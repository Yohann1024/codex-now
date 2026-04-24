# Codex Now

在 Finder 当前目录一键打开 Terminal，并自动运行：

```bash
codex --dangerously-bypass-approvals-and-sandbox
```

> Inspired by [Claude Code Now](https://github.com/orange2ai/claude-code-now), but built for OpenAI Codex CLI.

## 功能

- 从当前 Finder 窗口所在目录启动
- 打开 macOS Terminal，而不是 Codex 桌面 App
- 自动执行 `codex --dangerously-bypass-approvals-and-sandbox`
- 自动输入 `1` 并回车，确认 Codex CLI 的目录信任提示
- 可拖到 Dock 或 Finder 工具栏使用
- 使用 `assets/icon.jpg` 生成 App 图标

## 安装

```bash
git clone https://github.com/Yohann1024/codex-now.git
cd codex-now
./install.sh
```

安装后 App 位于：

```text
/Applications/Codex Now.app
```

## 使用

1. 打开 Finder，并进入你想运行 Codex 的项目文件夹。
2. 点击 `/Applications/Codex Now.app`。
3. Terminal 会在该目录打开，并自动运行 Codex。

你也可以：

- 把 `Codex Now.app` 拖到 Dock
- 按住 Command，把 `Codex Now.app` 拖到 Finder 工具栏

## 前置要求

需要已安装并登录 OpenAI Codex CLI：

```bash
codex --help
```

如果找不到 `codex`，请先安装或修复 PATH。

## 安全提示

本工具会运行：

```bash
codex --dangerously-bypass-approvals-and-sandbox
```

这个模式会跳过审批和沙箱限制。只建议在你信任的本机项目目录中使用。

## 卸载

```bash
rm -rf "/Applications/Codex Now.app"
rm -f ~/.codex-now-last-dir
```

## 调试

如果偶尔没有自动确认，查看日志：

```bash
tail -n 80 "$HOME/Library/Logs/Codex Now/launcher.log"
```

默认会在启动 Codex 后等待 0.4 秒并向新建 Terminal tab 输入 `1`。这是用全新 `/Volumes/D` 目录实测后的较快稳定值；如果你的机器较慢，可以调大：

```bash
CODEX_NOW_CONFIRM_DELAY=1 open -a "Codex Now"
```

## License

MIT
