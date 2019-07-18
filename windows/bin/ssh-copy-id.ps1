<#
 .NAME
    ssh-copy-id.ps1
 .SYNOPSIS
    Copy public key to remote hosts
 .DESCRIPTION
    See Synopsis
 .SYNTAX
    Invoke directly from the powershell command line
 .EXAMPLES
    .\Scriptname -i idtest.pub user@example.com password
    .\Scriptname -i idtest.pub user@example.com password -Debug
    .\ScriptName user@example.com password
.NOTES
    AUTHOR: VijayS
    DATE:   2014-01-23
    COMMENT:
    DEPENDENCIES:
        plink.exe
        type
 .HELPURL
    http://stackoverflow.com
 .SEEALSO
 .REFERENCE
    http://www.christowles.com/2011/06/how-to-ssh-from-powershell-using.html
#>

Param(
    [Parameter(Position=0,Mandatory=$true)]
    [String]$user_at_hostname,

    [Parameter(Position=1)]
    [String]$Password,

    [Parameter(HelpMessage="The public key file to copy")]
    [ValidateScript({Test-Path $_})]
    [Alias("i")]
    [String]$identity="id_rsa.pub"
)

####################################
Function Get-SSHCommands ([switch] $AcceptHostKey=$true) {

	$plinkoptions = "`-noagent -ssh $user_at_hostname"
	if ($Password) {
		$plinkoptions += " `-pw $Password "
	}

	$Plink = Get-Command plink -TotalCount 1 -ErrorAction SilentlyContinue

	if ($AcceptHostKey) {
		$PlinkCommand  = [string]::Format("echo y | & '{0}' {1} exit", $Plink, $plinkoptions )
		Write-Debug "$PlinkCommand"
		Invoke-Expression $PlinkCommand
	}

	#from http://serverfault.com/questions/224810/is-there-an-equivalent-to-ssh-copy-id-for-windows
	$remoteCommand = "umask 077; test -d .ssh || mkdir .ssh ; cat >> .ssh/authorized_keys; exit"
    return [string]::Format('{0} {1} "{2}"', $Plink, $plinkoptions , $remoteCommand)
}

$ErrorActionPreference = "Stop" # "Continue" "SilentlyContinue" "Stop" "Inquire"
$DebugPreference = "Continue"
trap { Write-Error "ERROR: $_" } #Stop on all errors

Try {
	[String]$cmdline = Get-SSHCommands
	$cmdline = "& Get-Content ""$identity"" | " + $cmdline
	# Write-Debug $cmdline
	Invoke-Expression $cmdline
}
Catch {
    Write-Error "$($_.Exception.Message)"
}
