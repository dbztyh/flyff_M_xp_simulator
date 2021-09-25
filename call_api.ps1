$ressources = $PSScriptRoot.ToString() + "\ressources"

Invoke-RestMethod -Uri https://flyff-api.sniegu.fr/monster -Outfile "$ressources\monsters.txt"

$string_list_monsters = Get-Content "$ressources\monsters.txt"
$string_list_monsters = $string_list_monsters.Trim([char]0x005b, [char]0x005d) # char '[' and ']'
$list_monsters = $string_list_monsters.Split(',').Split(' ')
Foreach($element in $list_monsters)
{
    Invoke-RestMethod -Uri "https://flyff-api.sniegu.fr/monster/$element" -Outfile "$ressources\monsters_$element.txt"
    Start-Sleep -s 1
}

If (Test-Path "$ressources\name_monster.txt")
{
    Remove-Item "$ressources\name_monster.txt"
}
If (Test-Path "$ressources\monsters.txt")
{
    Remove-Item "$ressources\monsters.txt"
}
$files = Get-ChildItem "$ressources"
#Get content of all files and convert in 1 assembly file with needed fields
ForEach ($file in $files)
{
    $info_monster = Get-Content "$ressources\$file"
    $info_monster = $info_monster | ConvertFrom-Json

    $experience_monster = $info_monster | select experienceTable
    $experience_monster = $experience_monster | Foreach {"$($_.experienceTable)"}
    $experience_monster = $experience_monster | Out-String -Stream

    $NameAndExp = $info_monster |  Select-Object -Property @{Name="name"; Expression = {$_.name.fr}},level
    $NameAndExp = [system.String]::join(";", $NameAndExp)
    $NameAndExp = $NameAndExp + $experience_monster

    Add-Content "$ressources\name_monster.txt" $NameAndExp
}
