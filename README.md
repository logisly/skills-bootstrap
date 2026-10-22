# Logisly skills bootstrap

Public entrypoint for installing or updating private Logisly company skills. This repository contains only the bootstrap and these usage instructions. Company skills and policy remain private.

Requirements: Bash, curl, Git with access to `logisly/skills`, and Bun 1.4.2+. Run as your normal user without sudo, from any directory:

```sh
curl -fsSL https://raw.githubusercontent.com/logisly/skills-bootstrap/main/install.sh | bash
```

The same command installs or updates. It uses `~/.logisly/skills`, detects an existing installation, preserves its selected agents and delegates to the private installer. That installer verifies its update flow and enables the current user's refresh scheduler. No credentials are embedded in the public script.

If agent detection is ambiguous, select one explicitly:

```sh
curl -fsSL https://raw.githubusercontent.com/logisly/skills-bootstrap/main/install.sh | bash -s -- --agent codex
```

Supported selections: `codex`, `cursor`, `claude-code`. Other installer options follow `bash -s --`; use `--no-auto-update` only when another scheduler owns refresh. Automated callers should enable their shell's `pipefail` option to propagate curl failures.

Maintain `install.sh` from the reviewed private source through a pull request. Publish no private history, skills, policy or internal docs here. Before publication, run `bash -n install.sh` and the private repository's functional distribution checks. After publication, anonymously download the raw URL and compare it byte-for-byte with the reviewed source. Company repository access controls changes to the executable script served from `main`.
