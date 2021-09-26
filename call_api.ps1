$ressources = $PSScriptRoot.ToString() + "\ressources"

If ( -not (Test-Path "$ressources"))
{
   $nothing = mkdir "$ressources"
}

Invoke-RestMethod -Uri https://flyff-api.sniegu.fr/monster -Outfile "$ressources\monsters.txt"

$string_list_monsters = Get-Content "$ressources\monsters.txt"
$string_list_monsters = $string_list_monsters.Trim([char]0x005b, [char]0x005d) # char '[' and ']'

Invoke-RestMethod -Uri "https://flyff-api.sniegu.fr/monster/$string_list_monsters" -Outfile "$ressources\monsters_list.txt"


#Get content of file and convert in 2 assembly file with needed fields

$info_monster = Get-Content "$ressources\monsters_list.txt"
$info_monster = $info_monster | ConvertFrom-Json

$experience_monster = $info_monster | select experienceTable
$experience_monster = $experience_monster | Foreach {"$($_.experienceTable)"}
$experience_monster = $experience_monster | Out-String -Stream

$NameAndExp = $info_monster |  Select-Object -Property @{Name="name_fr"; Expression = {$_.name.fr}}, @{Name="name_en"; Expression = {$_.name.en}},level

Add-Content "$ressources\name_monster.txt" $NameAndExp
Add-Content "$ressources\exp_monster.txt" $experience_monster

