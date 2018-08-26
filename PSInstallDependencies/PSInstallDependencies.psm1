<#
    .SYNOPSIS
        This function install any dependencies from external repository based on .PSD1 file specified.

    .PARAMETER path
        Path for the .PSD1 file.

    .PARAMETER repository
        Specifies the friendly name of a repository that has been registered.

    .PARAMETER user
        Username to be used for authentication with repository.

    .PARAMETER password
        Password to be used for authentication with repository.

    .EXAMPLE
        Install-Dependencies -Path ./configuration.psd1 -Repository 'sample' -Credential $credential
#>

function Install-Dependencies
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $path,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $repository,

        [Parameter()]
        [PSCredential]
        $credential
    )

    $psDataFile = Import-PowershellDataFile -Path $path
    $requiredModules = $psDataFile['RequiredModules']

    if ($null -ne $requiredModules)
    {
        foreach ($module in $requiredModules)
        {
            $moduleName = $module['ModuleName']
            if (-not $moduleName)
            {
                $moduleName = $module
            }
            $moduleInfo = @{
                Name        = $moduleName
                Repository  = $repository
                ErrorAction = 'SilentlyContinue'
            }
            if ($credential)
            {
                $moduleInfo['Credential'] = $credential
            }
            if ($module['ModuleVersion'])
            {
                $moduleInfo['RequiredVersion'] = $module['ModuleVersion']
            }
            if (-not (Get-Module -Name $moduleName -ListAvailable))
            {
                Write-Output "Installing module $moduleName from repository $repository..."
                Install-Module @moduleInfo -SkipPublisherCheck -Force
            }
        }
    }
}

<#
    .SYNOPSIS
        This function registers the PowerShell repository and sets to "Trusted".

    .PARAMETER uri
        URI of the repository.

    .PARAMETER name
        Specifies the friendly name of a repository to be registered.

    .PARAMETER credential
        PSCredential to be used for authentication with repository.

    .EXAMPLE
        Register-Repository -Uri 'sample' -Name 'sample' -Credential $credential
#>

function Register-Repository
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $uri,

        [Parameter()]
        [String]
        $name = 'repository',

        [Parameter()]
        [PSCredential]
        $credential
    )

    Write-Output "Registering powershell modules repository $name..."

    Get-PSRepository -WarningAction SilentlyContinue | Where-Object { $_.Name -eq $name} | Unregister-PSRepository
    $repo = @{
        Name                      = "$name"
        SourceLocation            = "$uri"
        PublishLocation           = "$uri"
        PackageManagementProvider = 'NuGet'
    }
    if ($credential)
    {
        $repo['Credential'] = $credential
    }

    Register-PSRepository @repo
    Set-PSRepository -Name "$name" -InstallationPolicy 'Trusted'

    $user = $credential.GetNetworkCredential().UserName
    $password = $credential.GetNetworkCredential().Password
    & nuget sources Remove -Name "$name"
    & nuget sources Add -Name "$name" -Source "$uri" -UserName "$user" -Password "$password"
}

Export-ModuleMember -Function @('Install-Dependencies', 'Register-Repository')
