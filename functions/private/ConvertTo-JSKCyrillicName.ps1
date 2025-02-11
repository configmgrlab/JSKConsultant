function ConvertTo-JSKCyrillicName {

    <#
    .SYNOPSIS
    This advanced function is used to convert a given name by replacing special characters.

    .DESCRIPTION
    This advanced function is used to convert a given name by replacing special characters.

    .PARAMETER Name
    The name to be converted.

    .EXAMPLE
    ConvertTo-CyrillicName -Name "Kjærgaard"
    This example will convert the name "Kjærgaard" to "Kjargaard".

    .INPUTS
    String

    .OUTPUTS
    String

    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Name
    )
    
    begin {} #
    
    process {
        # Convert the name (Removing specials characters).
        $Converted = [System.Text.Encoding]::ASCII.GetString([System.Text.Encoding]::GetEncoding("Cyrillic").GetBytes($Name))
        $ConvertedName = $Converted -replace '[^a-zA-Z0-9]'

        # Return the converted name
        Write-Output -InputObject $ConvertedName
    }
    
    end {}
}