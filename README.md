# InterestingTools

一些日常使用的小工具脚本合集。

## 目录

```text
InterestingTools/
├── BrowserJavaScript/
├── DjiSrtFile2Txt/
├── Win11BackupMenueSetup/
└── README.md
```

## BrowserJavaScript

### Bilibili：显示关注 UP 最近投稿时间

脚本文件：

```text
BrowserJavaScript/bilibili_follow_last_upload_time_iframe.user.js
```

功能：

- 适用于 B 站关注页：`https://space.bilibili.com/*/relation/follow`
- 自动读取关注 UP 的最近投稿时间；
- 支持 `11-01`、`2024-12-23`、`1小时前` 等时间格式；
- 在关注卡片下方显示相对时间与精确时间；
- 使用隐藏 iframe 串行加载，减少 CORS 和风控问题。

## DjiSrtFile2Txt

### DJI SRT → XYZ → 方位角/俯仰角 → 可视化

用于处理 DJI Mini 3 Pro 拍摄时生成的 `.SRT` 轨迹文件。

### 1. SRT 转 XYZ

脚本：

```text
DjiSrtFile2Txt/SRT2TXT.py
```

功能：

- 读取 `raw_file/` 中的 `.SRT` 文件；
- 提取经纬度、高度等轨迹信息；
- 转换为以起点为原点的三维 `(X, Y, Z)` 轨迹；
- 输出到 `local_file/`，文件后缀为 `_xyz.txt`。

### 2. XYZ 转方位角/俯仰角

脚本：

```text
DjiSrtFile2Txt/XYZ2PY.py
```

功能：

- 以脚本中设置的观测点为参考；
- 将三维轨迹转换为方位角 azimuth 和俯仰角 elevation；
- 输出到 `local_file/`，文件后缀为 `_py.txt`。

### 3. 轨迹可视化

脚本：

```text
DjiSrtFile2Txt/ShowXYZ.py
```

功能：

- 绘制三维轨迹；
- 绘制 X-Y 平面轨迹；
- 绘制方位角、俯仰角曲线；
- 用于快速检查轨迹数据是否合理。

> `local_file/` 为本地生成目录，已通过 `.gitignore` 排除，不提交到 GitHub。

## Win11BackupMenueSetup

### Windows 11 右键备份菜单

脚本文件：

```text
Win11BackupMenueSetup/Win11BackupMenuSetup.bat
```

功能：

- 在 Windows 右键菜单中添加：`Back up to D:\backup\Files`
- 右键任意文件即可复制到：`D:\backup\Files`
- 备份文件自动添加时间戳，格式为：`originalname_yyyyMMdd_HHmmss.ext`
- 若文件名重复，会自动追加序号；
- 同时切换 Windows 11 为经典右键菜单样式；
- 支持卸载并恢复默认 Windows 11 右键菜单。

### 安装

双击运行：

```text
Win11BackupMenueSetup/Win11BackupMenuSetup.bat
```

安装完成后会重启资源管理器。若菜单未生效，可重启 Windows。

### 卸载

在命令行中进入脚本目录后运行：

```bat
Win11BackupMenuSetup.bat --uninstall
```

卸载后会移除右键备份菜单，并恢复 Windows 11 默认右键菜单。

## 说明

本仓库主要用于存放个人常用脚本和小工具，偏向实用、轻量、可直接运行。
