# Used to connect to esxi instance and deploy a vm
Function Test-Connection
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true,
        HelpMessage = 'Username for esxi connection.')]
        [string]$Username,

        [Parameter(Mandatory = $true,
        HelpMessage = 'Password for esxi connection.')]
        [string]$Password,

        [Parameter(Mandatory = $true,
        HelpMessage = 'Esxi server to connect to.')]
        [string]$Server

    )

    Begin
    {
        # Check if module installed
        if (Get-Module -ListAvailable -Name VMware.PowerCLI) {
            Write-Host "VMware.PowerCLI module exists."
        } else {
            Write-Host "VMware.PowerCLI module does not exist. Install it."
            exit
        }
    }

    Process
    {
        # Connect to server
        try {
            Connect-VIServer -Server $Server -Protocol https -User $Username -Password $Password
        } catch {
            $ErrorMessage = $_.Exception.Message
            Write-Host $ErrorMessage
        }

        Get-VM
        Get-Inventory

    }

    End
    {
        Disconnect-VIServer -Server $Server -Force
    }
}