Get-InstalledModule

# Check your PowerShell version by executing
$PSVersionTable.PSVersion

# On Windows, script execution policy must be set to either RemoteSigned or Unrestricted.
# Check the script execution policy setting by executing
Get-ExecutionPolicy
# If the policy is not set to one of the two required values, run PowerShell as Administrator and execute
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Confirm

[environment]::setEnvironmentVariable('SCOOP','C:\workspace\scoop','User')
$env:SCOOP='C:\worksapce\scoop'
iex (new-object net.webclient).downloadstring('https://get.scoop.sh')

scoop install 7zip curl git openssh cmder
scoop install grep sed less touch unzip nano
scoop bucket add extras
scoop install go nodejs

scoop reset 7zip curl git openssh cmder grep sed less touch nano go
