# Install-Module Get-ChildItemColor -Scope CurrentUser
# Install-Module posh-sshell -Scope CurrentUser

$profileDir = Split-Path -parent $profile

New-Item $profileDir -ItemType Directory -Force -ErrorAction SilentlyContinue

Push-Location $PSScriptRoot
Copy-Item -Path ./*.ps1 -Destination $profileDir -Exclude "bootstrap.ps1"
Copy-Item -Path ./bin/** -Destination $home/bin  -Include **
Pop-Location

Remove-Variable profileDir
