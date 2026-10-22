#!/usr/bin/env bash
# Public bootstrap only; company guidance is fetched through the user's private Git access.
main() (
  set -euo pipefail
  fail() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }
  [[ "$UID" != 0 && "$EUID" != 0 && -z "${SUDO_USER:-}${SUDO_UID:-}" ]] || fail 'Run as your normal user without sudo'
  [[ "${HOME:-}" = /* ]] || fail 'HOME must be an absolute directory'
  local skills_dir="$HOME/.logisly/skills" current="$HOME/.logisly/skills"
  while [[ "$current" != / ]]; do
    [[ ! -L "$current" ]] || fail "Refusing symlink: $current"
    current="$(dirname "$current")"
  done
  for tool in git bun; do command -v "$tool" >/dev/null || fail "$tool is required"; done
  bun -e "process.exit(Bun.semver.satisfies(Bun.version, '>=1.4.2') ? 0 : 1)" || fail 'Bun 1.4.2+ is required'
  if [[ ! -e "$skills_dir" ]]; then git clone --branch main git@github.com:logisly/skills.git "$skills_dir"; fi
  # Reconnect prompts to the terminal instead of consuming the piped script.
  if [[ -t 1 ]] && { true </dev/tty; } 2>/dev/null; then
    bun "$skills_dir/scripts/bootstrap.js" "$@" </dev/tty
  else
    bun "$skills_dir/scripts/bootstrap.js" "$@"
  fi
)
main "$@"
