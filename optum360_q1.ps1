param ( 
    [parameter(Mandatory = $true)] 
    [string] $rgNumber,
	 
    [parameter(Mandatory = $false)] 
    [string] $rgName,

    [Parameter(Mandatory = $true)]
    [ValidateSet("eastus", "eastus2", "centralus")]
    [string]$location

) 

Import-Module Az

if ($rgNumber -eq 0 -or $rgNumber -lt 0 ) {
    throw "Please enter a valid number of rg value"
}
 
#$allResourceGroups = @("my-test-candidate-eastus2-3", "my-test-candidate-centralus-2", "my-test-candidate-eastus2 -4")

$allResourceGroups = Get-AzResourceGroup | Where-Object $_.ResourceGroupName

try {
    for ($i = 1; $i -le $rgNumber; $i++) {
        $rgName = "my-test-candidate-$($location)-$($i)"
    
        if ($allResourceGroups -ieq $Null -or $allResourceGroups -notcontains $rgName ) {

            $rg = New-AzResourceGroup -Name $rgName -Location $location
            if ($rg.ResourceGroupName -ieq $rgName) {
                Write-Output "created RG $($rgName)"
            }
        }
        else {
    
            Write-Output " RG $($rgName) already exists"
    
        }
    }
}

catch {
    if ($ignoreError -eq $true) {
        Write-Warning "$($_)"
    }
    else {
        throw $_
    }
}


