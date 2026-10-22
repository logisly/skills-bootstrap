# Public bootstrap only; company guidance is fetched through the user's private Git access.
& {
  $ErrorActionPreference = 'Stop'
  if ($env:SUDO_USER -or $env:SUDO_UID) { throw 'Run as your normal user without sudo' }
  if ([Environment]::OSVersion.Platform -eq [PlatformID]::Win32NT) {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($identity)
    if ($principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) { throw 'Run as your normal user without elevation' }
  }
  if (!$HOME -or ![IO.Path]::IsPathRooted($HOME)) { throw 'Home must be an absolute directory' }
  $skillsDir = Join-Path $HOME '.logisly/skills'
  $current = $skillsDir
  while ($current) {
    if ((Test-Path -LiteralPath $current) -and ((Get-Item -LiteralPath $current -Force).Attributes -band [IO.FileAttributes]::ReparsePoint)) { throw "Refusing linked destination: $current" }
    $parent = [IO.Directory]::GetParent($current)
    $current = if ($parent) { $parent.FullName } else { $null }
  }
  $git = @(Get-Command git -CommandType Application -ErrorAction Stop)[0].Source
  $bun = @(Get-Command bun -CommandType Application -ErrorAction Stop)[0].Source
  & $bun -e "process.exit(Bun.semver.satisfies(Bun.version, '>=1.4.2') ? 0 : 1)"
  if ($LASTEXITCODE -ne 0) { throw 'Bun 1.4.2+ is required' }
  if (!(Test-Path -LiteralPath $skillsDir)) {
    & $git clone --branch main git@github.com:logisly/skills.git $skillsDir
    if ($LASTEXITCODE -ne 0) { throw 'Git clone failed' }
  }
  & $bun (Join-Path $skillsDir 'scripts/bootstrap.js') @args
  if ($LASTEXITCODE -ne 0) { throw 'Company skills installation/update failed' }
} @args
