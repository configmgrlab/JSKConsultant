function New-JSKSamAccountName {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        # First name of the user.
        [Parameter(Mandatory, ParameterSetName = 'Default', Position = 0)]
        [Parameter(Mandatory, ParameterSetName = 'Automation', Position = 0)]
        [Parameter(Mandatory, ParameterSetName = 'Credential', Position = 0)]
        [string]
        $FirstName,

        # Last name of the user.
        [Parameter(Mandatory, ParameterSetName = 'Default', Position = 1)]
        [Parameter(Mandatory, ParameterSetName = 'Automation', Position = 1)]
        [Parameter(Mandatory, ParameterSetName = 'Credential', Position = 1)]
        [string]
        $LastName,

        # Server to be used.
        [Parameter(Mandatory, ParameterSetName = 'Automation', Position = 2)]
        [Parameter(Mandatory, ParameterSetName = 'Credential', Position = 2)]
        [string]
        $Server,

        # Credential to be used.
        [Parameter(Mandatory = $false, ParameterSetName = 'Credential', Position = 3)]
        [System.Management.Automation.PSCredential]
        $Credential
    )
    
    begin {
        
    }
    
    process {
        # Remove all non-alphanumeric characters from the first and last name.
        $First = ConvertTo-JSKCyrillicName -Name $FirstName
        $Last = ConvertTo-JSKCyrillicName -Name $LastName

        # Get the first 3 letters of firstname and lastname, if one of the names is short then take an extra letter from the other name.
        $First = $First.Substring(0, [math]::Min(3, $First.Length))
        $Last = $Last.Substring(0, [math]::Min(3, $Last.Length))

        # Make as many combinations as possible
        $Combinations = for ($i = 0; $i -lt 3; $i++) {
            for ($j = 0; $j -lt 3; $j++) {
                $First.Substring(0, $i + 1) + $Last.Substring(0, $j + 1) | Where-Object { $_.Length -ge 3 -and $_.Length -le 5 }
            }
        }

        # combinations must be unique
        $UniqueCombinations = ($Combinations | Select-Object -Unique ).ToUpper() | Sort-Object { $_.Length }

        switch ($PSCmdlet.ParameterSetName) {
            "Default" { 
                # Get first available SamAccountName
                foreach ($Combi in $UniqueCombinations) {
                    if (-not (Get-ADUser -Filter "SamAccountName -eq 'CONS_$Combi'" -ErrorAction Stop)) {
                        $SamAccountName = ('CONS_{0}' -f $Combi).ToString()
                        #Write-Output -InputObject $SamAccountName.ToString()
                        break
                    }
                }
            }
            "Automation" {
                # Get first available SamAccountName
                foreach ($Combi in $UniqueCombinations) {
                    if (-not (Get-ADUser -Filter "SamAccountName -eq 'CONS_$Combi'" -Server $Server -ErrorAction Stop)) {
                        $SamAccountName = ('CONS_{0}' -f $Combi).ToString()
                        #Write-Output -InputObject $SamAccountName.ToString()
                        break
                    }
                }
            }
            "Credential" {
                # Get first available SamAccountName
                foreach ($Combi in $UniqueCombinations) {
                    if (-not (Get-ADUser -Filter "SamAccountName -eq 'CONS_$Combi'" -Server $Server -Credential $Credential -ErrorAction Stop)) {
                        $SamAccountName = ('CONS_{0}' -f $Combi).ToString()
                        #Write-Output -InputObject $SamAccountName.ToString()
                        break
                    }
                }
            }
            
        }

        # Return the SamAccountName
        Write-Output -InputObject $SamAccountName
        
    }
    
    end {
        
    }
}