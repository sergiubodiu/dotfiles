# SSH Agent Functions
# Mark Embling (http://www.markembling.info/)
#
# How to use:
# - Place this file into %USERPROFILE%\Documents\WindowsPowershell (or location of choice)
# - Import into your profile.ps1:
#   e.g. ". (Resolve-Path ~/.dotfiles/windows/ssh-agent-utils.ps1)" [without quotes]
# - Enjoy
#
# Note: ensure you have ssh and ssh-agent available on your path, from Git's Unix tools or Cygwin.

# Retrieve the current SSH agent PID (or zero). Can be used to determine if there
# is a running agent.

function setenv {
    param(
        [Parameter()]
        [string]
        $key,

        [Parameter()]
        [string]
        $value,

        [Parameter()]
        [ValidateSet("Process", "User")]
        [string]
        $Scope = "Process"
    )
    [void][Environment]::SetEnvironmentVariable($key, $value, $Scope)
    Set-TempEnv $key $value
}

function Get-TempEnv($key) {
    $path = Get-TempEnvPath($key)
    if (Test-Path $path) {
        $value =  Get-Content $path
        [void][Environment]::SetEnvironmentVariable($key, $value)
    }
}

function Set-TempEnv($key, $value) {
    $path = Get-TempEnvPath($key)
    if ($null -eq $value) {
        if (Test-Path $path) {
            Remove-Item $path
        }
    }
    else {
        New-Item $path -Force -ItemType File > $null
        $value | Out-File -FilePath $path -Encoding ascii -Force
    }
}

function Get-TempEnvPath($key){
    $path = Join-Path ([System.IO.Path]::GetTempPath()) ".ssh\$key.env"
    return $path
}

function Get-SshAgent() {
    $agentPid = $Env:SSH_AGENT_PID
    if ($agentPid) {
        $sshAgentProcess = Get-Process | Where-Object { ($_.Id -eq $agentPid) -and ($_.Name -eq 'ssh-agent') }
        if ($null -ne $sshAgentProcess) {
            return $agentPid
        }
        else {
            # It is not running (this is an error). Remove env vars and return 0 for no agent.
            setenv 'SSH_AGENT_PID' $null
            setenv 'SSH_AUTH_SOCK' $null
        }
    }
    return 0
}

# Loosely based on bash script from http://help.github.com/ssh-key-passphrases/
function Start-SshAgent {
    param(
        [Parameter(Position = 0)]
        [ValidateSet("Automatic", "Boot", "Disabled", "Manual", "System")]
        [string]
        $StartupType = "Manual",

        [Parameter()]
        [switch]
        $Quiet,

        [Parameter()]
        [ValidateSet("Process", "User")]
        [string]
        $Scope = "Process"
    )

    [int]$agentPid = Get-SshAgent
    if ($agentPid -gt 0) {
        if (!$Quiet) {
            $agentName = Get-Process -Id $agentPid | Select-Object -ExpandProperty Name
            if (!$agentName) { $agentName = "SSH Agent" }
            Write-Host "$agentName is already running (pid $($agentPid))"
        }
        return
    }

    $sshAgent = Get-Command ssh-agent -TotalCount 1 -ErrorAction SilentlyContinue
    & $sshAgent | ForEach-Object {
        if ($_ -match '(?<key>[^=]+)=(?<value>[^;]+);') {
            setenv $Matches['key'] $Matches['value'] $Scope
        }
}
    & $sshAgent
}

# Stop a running SSH agent
function Stop-SshAgent() {
    [int]$agentPid = Get-SshAgent
    if ($agentPid -gt 0) {
        # Stop agent process
        $proc = Get-Process -Id $agentPid -ErrorAction SilentlyContinue
        if ($null -ne $proc) {
            Stop-Process $agentPid
        }
        # It is not running (this is an error). Remove env vars and return 0 for no agent.
        setenv 'SSH_AGENT_PID' $null
        setenv 'SSH_AUTH_SOCK' $null
    }
}

# Add a key to the SSH agent
function Add-SshKey([switch]$Quiet) {
    $sshAdd = Get-Command ssh-add -TotalCount 1 -ErrorAction SilentlyContinue

    if ($args.Count -eq 0) {
        # Otherwise just run without args, so it'll add the default key.
        & $sshAdd
    }
    else {
        foreach ($value in $args) {
            & $sshAdd $value
        }
    }
}


