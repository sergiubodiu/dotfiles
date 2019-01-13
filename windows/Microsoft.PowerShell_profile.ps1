
# Profile for the Microsoft.Powershell Shell, only. (Not Visual Studio or other PoSh instances)
# ===========
# thanks:
# https://github.com/jayharris/dotfiles-windows

. $PSScriptRoot\functions.ps1

Set-PSReadlineOption -BellStyle None
Set-PSReadLineOption -HistoryNoDuplicates
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineOption -HistorySaveStyle SaveIncrementally
Set-PSReadLineOption -MaximumHistoryCount 4000
# for a better history experience
# Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
# Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
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
${function:.....} = { Set-Location ..\..\..\.. }
${function:......} = { Set-Location ..\..\..\..\.. }

# Navigation Shortcuts
${function:drop} = { Set-Location ~\Documents\Dropbox }
${function:d} = { Set-Location ~\Desktop }
${function:docs} = { Set-Location ~\Documents }
${function:dl} = { Set-Location ~\Downloads }
${function:work} = { Set-Location C:\workspace }

Set-Alias cd Set-LocationDash -option AllScope
Set-Alias ll Get-ChildItemColor -option AllScope
Set-Alias ls Get-ChildItemColorFormatWide -option AllScope

${function:la} = { Get-ChildItemColor -Force @args }
${function:lsd} = { Get-ChildItemColorFormatWide -Directory @args }

# curl: Use `curl.exe` if available
if (Get-Command curl.exe -ErrorAction SilentlyContinue | Test-Path) {
    Remove-Item alias:curl -ErrorAction SilentlyContinue
    ${function:curl} = { curl.exe @args }
}

# Missing Bash aliases
Set-Alias time Measure-Command
# Create a new directory and enter it
Set-Alias mkd CreateAndSet-Directory
# Misc
Set-Alias g git
