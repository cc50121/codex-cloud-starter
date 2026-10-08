# Codex Cloud Starter

一个可以直接放到 GitHub、同时支持以下两种工作方式的项目模板：

- **Codex Cloud**：由 Codex 在云端克隆仓库、准备依赖并执行任务。
- **GitHub Codespaces + Codex CLI**：在浏览器中启动完整开发机，并直接运行 `codex`。

模板默认提供 Python 3.12、Node.js 22、GitHub CLI、常用命令行工具，以及面向 Codex 的仓库说明与安全默认值。

## 最快开始

### 1. 上传到 GitHub

在 GitHub 新建一个空仓库（建议命名为 `codex-cloud-starter`），然后在本目录执行：

```bash
git remote add origin git@github.com:cc50121/codex-cloud-starter.git
git push -u origin main
```

如果希望以后从它创建新项目，在仓库的 **Settings > General** 中勾选 **Template repository**。

### 2. 作为 Codex Cloud 环境使用

1. 在 Codex 新任务中选择 **Work in > Cloud > Select environment > Create environment**。
2. 连接 GitHub，并选择这个仓库或由它生成的项目仓库。
3. 让环境安装流程执行：

   ```bash
   bash scripts/setup-project.sh
   ```

4. 让 Codex 运行 `bash scripts/check.sh` 验证环境。
5. 检查配置后选择 **Publish**。以后创建云端任务时选择这个已发布环境即可。

Codex Cloud 会为每个任务创建隔离工作区。环境变量、网络权限和密钥应在 Codex Cloud 的环境设置或 Personal vault 中配置，不要写进 Git 仓库。

### 3. 作为 GitHub Codespaces 环境使用

1. 打开 GitHub 仓库的 **Code > Codespaces > Create codespace on main**。
2. 等待 `.devcontainer/post-create.sh` 完成；它会安装最新版 Codex CLI 并准备项目依赖。
3. 在终端登录：

   ```bash
   codex login --device-auth
   ```

4. 检查环境并启动 Codex：

   ```bash
   bash scripts/doctor.sh
   codex
   ```

如果你要开发调用 OpenAI API 的程序，可在 GitHub **Settings > Codespaces > Secrets** 中添加 `OPENAI_API_KEY`。仅使用 ChatGPT 账号登录 Codex CLI 时，不需要把 API key 放进项目。

## 目录结构

```text
.
├── .codex/config.toml              # 仓库级 Codex 默认设置
├── .devcontainer/devcontainer.json # Codespaces / Dev Container 定义
├── .devcontainer/post-create.sh    # 云开发机首次创建后的初始化
├── .github/workflows/validate.yml  # 模板自身的持续验证
├── scripts/setup-project.sh        # Codex Cloud 与本地共用的依赖安装入口
├── scripts/check.sh                # 自动发现并运行常见检查
├── scripts/doctor.sh               # 环境诊断
└── AGENTS.md                       # Codex 在本仓库中的长期协作规则
```

## 开始一个新项目

从这个模板创建仓库后：

1. 把项目代码放在仓库根目录。
2. 提交语言对应的依赖与锁文件，例如 `pyproject.toml`、`requirements.txt`、`package-lock.json`、`pnpm-lock.yaml`、`go.mod` 或 `Cargo.toml`。
3. 根据项目修改 `AGENTS.md` 中的构建、测试和架构约定。
4. 如有额外系统依赖，在 `.devcontainer/devcontainer.json` 中增加 Feature，或扩展 `scripts/setup-project.sh`。
5. 运行 `bash scripts/check.sh`，确保 Codex 能用一条稳定命令验证工作。

## 安全约定

- 不提交 `.env`、API key、访问令牌或 `~/.codex/auth.json`。
- 项目默认使用 `workspace-write` 沙箱和按需审批。
- 密钥通过 Codespaces Secrets、Codex Cloud 环境变量或 Personal vault 提供。
- 在提交前查看 `git diff`，并运行与改动相关的测试。

## 常用命令

```bash
# 安装或刷新项目依赖
bash scripts/setup-project.sh

# 检查工具版本和认证状态
bash scripts/doctor.sh

# 运行自动发现的 lint / test / build
bash scripts/check.sh

# 更新 Codex CLI
npm install -g @openai/codex@latest
```

