将此目录放到 `$XDG_CONFIG_HOME/nvim`（默认 `~/.config/nvim`）。

## Java / jdtls

通过 `:MasonInstall jdtls` 安装语言服务器。JDK 需要单独安装；当前 jdtls
启动需要 Java 21+，项目可以使用 Java 8+。

JDK 安装位置由本机环境提供，公共配置不扫描安装目录，也不自动选择最高版本：

- `JDTLS_JAVA_HOME`：可选，指定启动 jdtls 的 JDK 根目录，通过 launcher 的
  `--java-executable` 参数生效。路径或版本不符合要求时直接报错。
- 未设置 `JDTLS_JAVA_HOME` 时，由 launcher 按 `JAVA_HOME`、`PATH` 选择 Java。
- 项目 JDK 从 `JAVA_HOME` 或 `PATH` 中的 Java 查询得到，并注册到
  `java.configuration.runtimes`；只有完整 JDK（包含 `javac`）才会被注册。
  探测在 Java 服务启动时执行，支持版本管理器的 shim 和 Java 8 的 `jre` 子目录。

例如项目使用 Java 17 时，在启动 Neovim 的环境中分别指定两个 JDK：

```sh
export JAVA_HOME="/本机/项目的-jdk-17"
export JDTLS_JAVA_HOME="/本机/启动服务的-jdk-21"
nvim
```

这些变量也可以由 SDKMAN、mise 等版本管理器提供。切换环境后重新启动 Neovim。
Maven / Gradle 配置仍负责项目的语言级别和 toolchain；自动注册的 `default`
运行时用于独立 Java 文件。

同一 Neovim 会话需要多个项目 JDK 时，通过 `vim.lsp.config("jdtls", ...)`
设置 `settings.java.configuration.runtimes`。显式列表（包括空列表）优先，
不会被自动探测覆盖。

参考：[nvim-jdtls](https://github.com/mfussenegger/nvim-jdtls#configuration)、
[jdtls launcher](https://github.com/eclipse-jdtls/eclipse.jdt.ls/blob/main/org.eclipse.jdt.ls.product/scripts/jdtls.py)。
