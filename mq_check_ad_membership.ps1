$SearchFilter = Read-Host "Active Directory Group Filter"
$ExportPath = Read-Host "Please provide export path"


$AdGroups = Get-ADGroup -filter {name -like $SearchFilter} | Select-Object name

$UserArray = @()
$UserArray += New-Object PSObject -Property @{User="";Group=""}
ForEach ($g in $AdGroups) {
    Write-Host -ForegroundColor Cyan "Checking AD group $($g.name)."
    $Users = Get-ADGroupMember -Identity $g.name | Select-Object name

    ForEach ($u in $Users) {
        $Index = [Array]::FindIndex($UserArray, [System.Predicate[PSCustomObject]]{$args[0].User -eq $u.name})

        if ($Index -ge 0) {
            Write-Host -ForegroundColor Yellow "Adding $($g.name) to $($u.name)"
            $UserArray[$Index].Group += ", $($g.name)"
        }
        else {
            Write-Host -ForegroundColor Green "Adding $($u.name) to table"
            $UserArray += New-Object PSObject -Property @{User=$u.name;Group=$g.name}
        }
    }
}
$UserArray | Export-Csv -NoTypeInformation -Path $ExportPath
Write-Host "Exported CSV to $ExportPath."