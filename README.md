# Logisly skills bootstrap

Public entrypoint for installing or updating private Logisly company skills. This repository contains only the shell/PowerShell bootstraps and these usage instructions. Company skills and policy remain private.

Requirements: Bash and curl, or Windows PowerShell 5.1/PowerShell 7; Git with access to `logisly/skills`, and Bun 1.4.2+. Run as your normal user without sudo, from any directory:

```sh
curl -fsSL https://raw.githubusercontent.com/logisly/skills-bootstrap/main/install.sh | bash
```

For Windows, use the same install/update format in PowerShell or Command Prompt:

```powershell
powershell -c "irm https://raw.githubusercontent.com/logisly/skills-bootstrap/main/install.ps1 -ErrorAction Stop|iex"
```

PowerShell 7 can use `pwsh` instead. To pass options inside PowerShell:

```powershell
& ([scriptblock]::Create((irm https://raw.githubusercontent.com/logisly/skills-bootstrap/main/install.ps1 -ErrorAction Stop))) --agent codex
```

The same command installs or updates. It uses `~/.logisly/skills`, detects an existing installation, preserves its selected agents and delegates to the private installer. That installer verifies its update flow and enables the current user's refresh scheduler. No credentials are embedded in the public script.

If agent detection is ambiguous, select one explicitly:

```sh
curl -fsSL https://raw.githubusercontent.com/logisly/skills-bootstrap/main/install.sh | bash -s -- --agent codex
```

Supported selections: `codex`, `cursor`, `claude-code`. Other installer options follow `bash -s --` or the PowerShell script-block invocation; use `--no-auto-update` only when another scheduler owns refresh. Automated callers should enable their shell's `pipefail` option to propagate curl failures.

Maintain `install.sh` and `install.ps1` from the reviewed private source through a pull request. Publish no private history, skills, policy or internal docs here. Before publication, check Bash/PowerShell syntax and run the private repository's functional distribution checks. After publication, anonymously download the raw URL and compare it byte-for-byte with the reviewed source. Company repository access controls changes to the executable script served from `main`.
