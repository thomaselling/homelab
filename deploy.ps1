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
        [string]$Server,

        [Parameter(Mandatory = $false,
        HelpMessage = 'Local path to iso.')]
        [string]$Uploadpath,

        [Parameter(Mandatory = $false,
        HelpMessage = 'Target folder for iso on esxi server.')]
        [string]$Targetfolder,

        [Parameter(Mandatory = $false,
        HelpMessage = 'Target datastore on esxi server.')]
        [string]$Datastore

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

        # Connect to server
        try {
            Connect-VIServer -Server $Server -Protocol https -User $Username -Password $Password
        } catch {
            $ErrorMessage = $_.Exception.Message
            Write-Host $ErrorMessage
        }
    }

    Process
    {

        # Upload ISO
        $tempds = Get-VMHost -Name $Server | Get-Datastore $Datastore | Select -ExpandProperty DatastoreBrowserPath
        New-PSDrive -Root "$tempds\" -Name tempds -PSProvider VimDatastore > $null

        if (!(Test-Path -Path "$tempds\$($Targetfolder)")) {
            New-Item -ItemType Directory -Path "$tempds\$($Targetfolder)" > $null
        }

        Copy-DatastoreItem -Item $Uploadpath -Destination "$tempds\$($Targetfolder)"
        Remove-PSDrive -Name tempds -Confirm:$false

        # Create VM
        New-VM -Name test -VMHost $Server -Datastore $Datastore -DiskGB 25 -MemoryGB 8 -NumCpu 2 -NetworkName "VM Network" -Location test
        $isopath = Split-Path $Uploadpath -leaf

        # Assign iso to cd drive
        New-CDDrive -VM test -IsoPath "$tempds\$($Targetfolder)\$($isopath)"

    }

    End
    {
        Disconnect-VIServer -Server $Server -Force
    }
}