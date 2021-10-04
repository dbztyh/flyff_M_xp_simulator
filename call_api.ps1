$ressources = $PSScriptRoot.ToString() + "\ressources"

If ( -not (Test-Path "$ressources"))
{
   $nothing = mkdir "$ressources"
}
else
{
  Remove-Item -Force "$ressources\*.txt"
  Remove-Item -Force "$ressources\maps\*.txt"
#  $nothing = mkdir "$ressources"
}

Invoke-RestMethod -Uri https://flyff-api.sniegu.fr/monster -Outfile "$ressources\monsters.txt"

$string_list_monsters = Get-Content "$ressources\monsters.txt"
$string_list_monsters = $string_list_monsters.Trim([char]0x005b, [char]0x005d) # char '[' and ']'

Invoke-RestMethod -Uri "https://flyff-api.sniegu.fr/monster/$string_list_monsters" -Outfile "$ressources\monsters_list.txt"


#Get content of file and convert in 2 assembly file with needed fields
$info_monster = (Get-Content "$ressources\monsters_list.txt") | ConvertFrom-Json


$experience_monster = $info_monster | select experienceTable
$experience_monster = $experience_monster | Foreach {"$($_.experienceTable)"}
$experience_monster = $experience_monster | Out-String -Stream

$NameAndExp = $info_monster |  Select-Object -Property @{Name="name_fr"; Expression = {$_.name.fr}}, @{Name="name_en"; Expression = {$_.name.en}},level,minAttack,maxAttack,hp,element, @{Name="world"; Expression = {$_.location.world}}
$icon_monster = $info_monster | Select-Object icon
Add-Content "$ressources\icon_monster.txt" $icon_monster

foreach($line in [System.IO.File]::ReadLines("$ressources\icon_monster.txt"))
{
    $icon_name_split = $line -split { $_ -eq "=" -or $_ -eq "}" }
    $icon_name = $icon_name_split[1]
    if ( -not (Test-Path "$ressources\$icon_name"))
    {
        Write-Output("$ressources\$icon_name")
        Invoke-RestMethod -Uri "https://flyff-api.sniegu.fr/image/monster/$icon_name" -OutFile "$ressources\$icon_name"
        sleep -Seconds 0.2
        while ( -not (Test-Path "$ressources\$icon_name"))
        {
            Invoke-RestMethod -Uri "https://flyff-api.sniegu.fr/image/monster/$icon_name" -OutFile "$ressources\$icon_name"
            sleep -Seconds 0.2
        }
    }      
}


Invoke-RestMethod -Uri https://flyff-api.sniegu.fr/world/ -Outfile "$ressources\world_monsters.txt"
sleep -Seconds 0.2

$string_list_world = Get-Content "$ressources\world_monsters.txt"
$string_list_world = $string_list_world.Trim([char]0x005b, [char]0x005d) # char '[' and ']'
Invoke-RestMethod -Uri "https://flyff-api.sniegu.fr/world/$string_list_world" -Outfile "$ressources\maps\world_monsters_list.txt"
sleep -Seconds 0.2

$tilename_world = Get-Content "$ressources\maps\world_monsters_list.txt" | ConvertFrom-Json | foreach {"$($_.tileName)"}
$tilename_world = $tilename_world.split(" ");
$width_world = Get-Content "$ressources\maps\world_monsters_list.txt" | ConvertFrom-Json | foreach {"$($_.width)"}
$width_world = $width_world.split(" ");
$height_world = Get-Content "$ressources\maps\world_monsters_list.txt" | ConvertFrom-Json | foreach {"$($_.height)"}
$height_world = $height_world.split(" ");
$width = @()
$height = @()
foreach ($w in $width_world)
{
  $width += (([int]$w) / 512)
}
foreach ($h in $height_world)
{
  $height += (([int]$h) / 512)
}

$j=0
foreach ($i in $tilename_world)
{ 
    $x = 0
    $y = 0
    if ( -not (Test-Path "$ressources\maps\$i"))
    {
        mkdir "$ressources\maps\$i"
    }
    while ($x -ne $width[$j])
    {
        $y = 0
        while ($y -ne $height[$j])
        { 
            $outpt = "$ressources\maps\" + $i + "\tile" + $x + "-" + $y + ".png"
            if ( -not (Test-Path "$outpt"))
            {
                $uri = "https://flyff-api.sniegu.fr/image/world/" +$i + $x + "-" + $y + "-0.png"
                Invoke-RestMethod -Uri $uri -OutFile $outpt
                sleep -Seconds 0.2
                while ( -not (Test-Path "$outpt"))
                {
                    Invoke-RestMethod -Uri $uri -OutFile $outpt
                    sleep -Seconds 0.2
                }
            }
            $y = $y + 1
        }
        $x = $x + 1
    }
    $j = $j + 1
}

$SpawnLocation = $info_monster | Select-Object location
$SpawnLocation = $SpawnLocation | Out-String  -Stream

Add-Content "$ressources\name_monster.txt" $NameAndExp
Add-Content "$ressources\exp_monster.txt" $experience_monster
Add-Content "$ressources\location_monster.txt" $SpawnLocation



