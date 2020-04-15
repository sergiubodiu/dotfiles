
# Profile for the Microsoft.Powershell Shell, only. (Not Visual Studio or other PoSh instances)
# ===========
# thanks:
# https://github.com/jayharris/dotfiles-windows

# Basic commands
#. $PSScriptRoot\functions.ps1
function which($name) { Get-Command $name -ErrorAction SilentlyContinue | Select-Object Definition }
function touch($file) { "" | Out-File $file -Encoding ASCII }
function md5sum($path) { return (Get-FileHash -Path $path -Algorithm MD5).Hash.ToLower() }
function sha256sum($path) { return (Get-FileHash -Path $path -Algorithm SHA256).Hash.ToLower() }

function Get-RecycleBin {
    (New-Object -ComObject Shell.Application).NameSpace(0x0a).Items() | Select-Object Name,Size,Path
}

# Create a new directory and enter it
function Set-NewCreateDirectory($path) {
    New-Item $path -ItemType Directory -ErrorAction SilentlyContinue; Set-Location $path
}

Set-PSReadlineOption -BellStyle None
# Set-PSReadLineOption -HistoryNoDuplicates
# Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineOption -HistorySaveStyle SaveIncrementally
Set-PSReadLineOption -MaximumHistoryCount 4000
# for a better history experience
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
# To enable bash style completion
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

# if ($host.Name -eq 'ConsoleHost') {
#     # Import-Module posh-shell
#     # Start-SshAgent -Quiet
# }

# Easier Navigation: .., ..., ...., ....., and ~
${function:~} = { Set-Location ~ }
# PoSh won't allow ${function:..} because of an invalid path error, so...
${function:Set-ParentLocation} = { Set-Location .. }; Set-Alias ".." Set-ParentLocation
${function:...} = { Set-Location ..\.. }
${function:....} = { Set-Location ..\..\.. }

# Navigation Shortcuts
${function:drop} = { Set-Location ~\Documents\Dropbox }
${function:d} = { Set-Location ~\Desktop }
${function:docs} = { Set-Location ~\Documents }
${function:dl} = { Set-Location ~\Downloads }
${function:work} = { Set-Location C:\workspace }
${function:empty-trash} = { Clear-RecycleBin -Force @args }

${function:la} = { Get-ChildItemColor -Force @args }
${function:lsd} = { Get-ChildItemColorFormatWide -Directory @args }
${function:l} = { Get-ChildItemColorFormatWide @args}

Set-Alias ll Get-ChildItemColor -option AllScope
# Missing Bash aliases
Set-Alias time Measure-Command
# Create a new directory and enter it
Set-Alias mkd Set-NewCreateDirectory
