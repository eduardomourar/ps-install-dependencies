@{

    # Script module or binary module file associated with this manifest.
    RootModule        = 'PSInstallDependencies.psm1'

    # Version number of this module.
    ModuleVersion     = '0.2.1'

    # ID used to uniquely identify this module
    GUID              = 'ba204f00-7315-4316-8b80-958bdea4c582'

    # Author of this module
    Author            = 'Eduardo Rodrigues'

    # Copyright statement for this module
    Copyright         = '(c) 2018 Eduardo Rodrigues. All rights reserved.'

    # Description of the functionality provided by this module
    Description       = 'Powershell module to install any dependencies from external repository based on .PSD1 file specified. (Temporary fix for issue: https://github.com/PowerShell/PowerShellGet/issues/245)'

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion = '5.1'

    # Modules that must be imported into the global environment prior to importing this module
    RequiredModules   = @(
        @{
            ModuleName    = 'PowerShellGet'
            ModuleVersion = '1.6.7'
        }
    )

    # Functions to export from this module
    FunctionsToExport = @('Install-Dependencies', 'Register-Repository')

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData       = @{

        PSData = @{

            # A URL to the main website for this project.
            ProjectUri = 'https://github.com/eduardomourar/ps-install-dependencies'

        } # End of PSData hashtable

    } # End of PrivateData hashtable

}
