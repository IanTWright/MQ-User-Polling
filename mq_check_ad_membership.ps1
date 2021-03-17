$AdGroups = Get-ADGroup -filter {name -like '*-MQ-*'} | Select-Object Name

$UserArray = @()
ForEach ($g in $AdGroups) {
    Write-Host -ForegroundColor Cyan "Checking AD group $($g.Name)."
    $Users = Get-ADGroupMember -Identity $g.Name | Select-Object name

    ForEach ($u in $Users) {
    If(!($UserArray -contains $u.name)){
        $UserArray += $u.name
        Write-Host -ForegroundColor Green "Adding $($u.name) to UserArray."
        }
    Elseif ($UserArray -contains $u.name) {
        Write-Host -ForegroundColor Yellow "UserArray already contains $($u.name). Skipping..."
        continue
        }
    }
}

$UserArray | Out-File C:\Users\itw2a0\Desktop\DataArk_Users.csv