#Add some modules
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing


Function Choice_Language{
    Param ($Tag)
    if ($Tag -eq "US")
    {
       $ButtonCancel_Text = "EXIT"
       $ButtonOk_Text = "OK"
       $ButtonUpdate_Text = "UPDATE"
       $FormLabelMonster_Text = "monsters :"
       $FormLabelLevel_Text = "Player level :"
       $FormLabelTime_Text = "Time to kill a monster or make an AOE in secondes :"
       $FormLabelBonus_Text = "experience bonus in % (don't complete if you haven't bonus) :"
       $FormLabelAOE_Text = "Nomber of monster kill (if you make 1v1 don't complete this field) :"
    }
    else
    {
       $ButtonCancel_Text = "SORTIR"
       $ButtonOk_Text = "OK"
       $ButtonUpdate_Text = "MISE A JOUR"
       $FormLabelMonster_Text = "monstres :"
       $FormLabelLevel_Text = "Level du joueur : "
       $FormLabelTime_Text = "Temps pour tuer un monstre/faire un AOE en secondes:"
       $FormLabelBonus_Text = "Bonus expérience en % (ne pas remplir si pas de bonus) :"
       $FormLabelAOE_Text = "Nombres de monstres tuer par AOE (ne pas remplir si 1V1) :"
    }
    #retour de fonction
    $return_list_language = $ButtonCancel_Text, $ButtonOk_Text, $ButtonUpdate_Text, $FormLabelMonster_Text, $FormLabelLevel_Text, $FormLabelTime_Text, $FormLabelBonus_Text, $FormLabelAOE_Text
    return $return_list_language
}

Function Init{
    Param ($Tag)
    $return_list_language = Choice_Language $Tag
    $ButtonCancel_Text = $return_list_language[0] 
    $ButtonOk_Text = $return_list_language[1] 
    $ButtonUpdate_Text = $return_list_language[2] 
    $FormLabelMonster_Text = $return_list_language[3] 
    $FormLabelLevel_Text = $return_list_language[4] 
    $FormLabelTime_Text = $return_list_language[5] 
    $FormLabelBonus_Text = $return_list_language[6] 
    $FormLabelAOE_Text = $return_list_language[7] 
    $Path_parent = $PSScriptRoot.ToString()
    $Path = $PSScriptRoot.ToString() + "\ressources"
    if (-not ( Test-Path -Path $Path ))
    {
        mkdir $Path
        $api_call = $PSScriptRoot.ToString() + "\call_api.ps1"
        powershell -file "$api_call"
    }

    #check if assembly file exist and remove if exist to avoid some collision


    #Ouvre la boite de dialogue
    $ListForm = New-Object System.Windows.Forms.Form
    $ListForm.Text = "Test Formulaire"
    $ListForm.Size = New-Object System.Drawing.Size(800,500)
    $ListForm.StartPosition = "CenterScreen"
    $ListForm.TopMost = $True

    #Cancel button
    $ButtonCancel = New-Object System.Windows.Forms.Button
    $ButtonCancel.Location = New-Object System.Drawing.Point(520,420)
    $ButtonCancel.Size = New-Object System.Drawing.Size(75,23)
    $ButtonCancel.Text = "$ButtonCancel_Text"
    $ButtonCancel.BackColor = "#FFDF00"
    $ButtonCancel.DialogResult = [System.Windows.Forms.DialogResult]::Cancel

    #Ok button
    $ButtonOk = New-Object System.Windows.Forms.Button
    $ButtonOk.Location = New-Object System.Drawing.Point(180,420)
    $ButtonOk.Size = New-Object System.Drawing.Size(75,23)
    $ButtonOk.Text = "$ButtonOk_Text"
    $ButtonOk.BackColor = "#FFDF00"
    $ButtonOk.DialogResult = [System.Windows.Forms.DialogResult]::OK

    #Update button
    $ButtonUpdate = New-Object System.Windows.Forms.Button
    $ButtonUpdate.Location = New-Object System.Drawing.Point(325,420)
    $ButtonUpdate.Size = New-Object System.Drawing.Size(150,23)
    $ButtonUpdate.Text = "$ButtonUpdate_Text"
    $ButtonUpdate.BackColor = "#0072A0"
    $ButtonUpdate.DialogResult = [System.Windows.Forms.DialogResult]::Retry

    #FR button
    $ButtonFR = New-Object System.Windows.Forms.Button
    $ButtonFR.Location = New-Object System.Drawing.Point(5,5)
    $ButtonFR.Size = New-Object System.Drawing.Size(45,30)
    $imageFR = [System.Drawing.Image]::FromFile($Path_parent +"\FR2.png")
    $ButtonFR.Image = $imageFR
    $ButtonFR.DialogResult = [System.Windows.Forms.DialogResult]::Yes

    #US button
    $ButtonUS = New-Object System.Windows.Forms.Button
    $ButtonUS.Location = New-Object System.Drawing.Point(325,5)
    $ButtonUS.Size = New-Object System.Drawing.Size(57,30)
    $imageUS = [System.Drawing.Image]::FromFile($Path_parent +"\US2.png")
    $ButtonUS.Image = $imageUS
    $ButtonUS.DialogResult = [System.Windows.Forms.DialogResult]::No

    #cree le label Monster
    $FormLabelMonster = New-Object System.Windows.Forms.Label
    $FormLabelMonster.Location = New-Object System.Drawing.Point(10,20)
    $FormLabelMonster.Size = New-Object System.Drawing.Size(350,20)
    $FormLabelMonster.Text = "$FormLabelMonster_Text"

    #cree la liste Monster
    $ListBoxMonster = New-Object System.Windows.Forms.ListBox 
    $ListBoxMonster.Location = New-Object System.Drawing.Size(10,40) 
    $ListBoxMonster.Size = New-Object System.Drawing.Size(350,250) 
    $ListBoxMonster.Height = 250

    #cree le label Level
    $FormLabelLevel = New-Object System.Windows.Forms.Label
    $FormLabelLevel.Location = New-Object System.Drawing.Point(420,20)
    $FormLabelLevel.Size = New-Object System.Drawing.Size(350,20)
    $FormLabelLevel.Text = "$FormLabelLevel_Text"

    #cree la liste Level
    $ListBoxLevel = New-Object System.Windows.Forms.ListBox 
    $ListBoxLevel.Location = New-Object System.Drawing.Size(420,40) 
    $ListBoxLevel.Size = New-Object System.Drawing.Size(350,250) 
    $ListBoxLevel.Height = 250

    #cree le label Time
    $FormLabelTime = New-Object System.Windows.Forms.Label
    $FormLabelTime.Location = New-Object System.Drawing.Point(10,300)
    $FormLabelTime.Size = New-Object System.Drawing.Size(350,20)
    $FormLabelTime.Text = "$FormLabelTime_Text"

    #cree l edit box Time
    $TextBoxTime = New-Object System.Windows.Forms.TextBox
    $TextBoxTime.Location = New-Object System.Drawing.Point(10,320)
    $TextBoxTime.Size = New-Object System.Drawing.Size(350,20)

    #cree le label Bonus
    $FormLabelBonus = New-Object System.Windows.Forms.Label
    $FormLabelBonus.Location = New-Object System.Drawing.Point(420,300)
    $FormLabelBonus.Size = New-Object System.Drawing.Size(350,20)
    $FormLabelBonus.Text = "$FormLabelBonus_Text"

    #cree l edit box Bonus
    $TextBoxBonus = New-Object System.Windows.Forms.TextBox
    $TextBoxBonus.Location = New-Object System.Drawing.Point(420,320)
    $TextBoxBonus.Size = New-Object System.Drawing.Size(350,20)

    #cree le label AOE
    $FormLabelAOE = New-Object System.Windows.Forms.Label
    $FormLabelAOE.Location = New-Object System.Drawing.Point(10,360)
    $FormLabelAOE.Size = New-Object System.Drawing.Size(350,20)
    $FormLabelAOE.Text = "$FormLabelAOE_Text"

    #cree l edit box AOE
    $TextBoxAOE = New-Object System.Windows.Forms.TextBox
    $TextBoxAOE.Location = New-Object System.Drawing.Point(10,380)
    $TextBoxAOE.Size = New-Object System.Drawing.Size(350,20)

    #List de tuple (item1 = level, item2 = name) du monstre
    $myList = New-Object System.Collections.ArrayList

    #remplir la liste Monster
    foreach($line in [System.IO.File]::ReadLines("$Path\name_monster.txt"))
    {
        $name = $line -split { $_ -eq "=" -or $_ -eq ";" -or $_ -eq "}" }
        $myList.Add([Tuple]::Create([Int]($name[3]),$name[1])) | Out-Null
       
    }
    #trier la liste
    $myList = $myList | Sort-Object

    foreach($level_name in $myList)
    {
        $ListBoxMonster.Items.Add($level_name) | Out-Null
    }

    #remplir la liste level
    $val = 1
    while($val -ne 121)
    {
        $ListBoxLevel.Items.Add("$val") | Out-Null
        $val++
    }

    #ajout des elements a la boite de dialogue
    $ListForm.Controls.Add($ButtonOk)
    $ListForm.Controls.Add($ButtonCancel)
    $ListForm.Controls.Add($ButtonUpdate)
    $ListForm.Controls.Add($ButtonFR)
    $ListForm.Controls.Add($ButtonUS)
    $ListForm.Controls.Add($FormLabelMonster)
    $ListForm.Controls.Add($FormLabelLevel) 
    $ListForm.Controls.Add($FormLabelTime)
    $ListForm.Controls.Add($FormLabelBonus)
    $ListForm.Controls.Add($FormLabelAOE)
    $ListForm.Controls.Add($ListBoxMonster)
    $ListForm.Controls.Add($ListBoxLevel)
    $ListForm.Controls.Add($TextBoxTime)
    $ListForm.Controls.Add($TextBoxBonus)
    $ListForm.Controls.Add($TextBoxAOE)

    #retour de fonction
    $return_list_init = $ListForm, $ListBoxMonster, $ListBoxLevel, $Path, $TextBoxTime, $TextBoxBonus, $TextBoxAOE
    return $return_list_init
}
$Tag = "FR"
$return_list_init = Init $Tag
$ListForm = $return_list_init[0]
$ListBoxMonster = $return_list_init[1]
$ListBoxLevel = $return_list_init[2]
$Path = $return_list_init[3]
$TextBoxTime = $return_list_init[4]
$TextBoxBonus = $return_list_init[5]
$TextBoxAOE = $return_list_init[6]
while (1)
{
    #display dialogue with actual load element
    $Result = $ListForm.ShowDialog()

    #Action si bouton ok appuye
    If ($Result -eq [System.Windows.Forms.DialogResult]::OK) {
        $SelectItemMonster = [string]$ListBoxMonster.SelectedItem
        $SelectItemLevel = [string]$ListBoxLevel.SelectedItem

        foreach($line in [System.IO.File]::ReadLines("$Path\name_monster.txt"))
        {
            $name = $line -split { $_ -eq "=" -or $_ -eq ";" -or $_ -eq "}" }
            $test = "("+ $name[3] + ", " + $name[1] + ")"
            if ($SelectItemMonster -eq $test)
            {
                $ExperienceMonsterList = $name[4] -split { $_ -eq " " }
            }
        }
        if ($SelectItemMonster -ne "" -and $SelectItemLevel -ne "")
        {
            $SelectTime = $TextBoxTime.Text
            $SelectBonus = $TextBoxBonus.Text
            $SelectAOE = $TextBoxAOE.Text
            if ($SelectAOE -eq ""){$SelectAOE = 1}
            if ($SelectTime -eq ""){$SelectTime = 1}
            if ($SelectBonus -eq ""){$SelectBonus = 0}
            $ExperienceMonster = $ExperienceMonsterList[$SelectItemLevel - 1]
            #Write-Output("expmonster : " + $ExperienceMonster)
            #Write-Output("selectbonus : " + $SelectBonus)
            #Write-Output("selectaoe : " + $SelectAOE)
            #Write-Output("slecttime : " + $SelectTime)
            #calcul all ouput result
            $ExperienceMonster = $ExperienceMonster.Replace(',', '.')
            $ExperienceMonster = (([double] $ExperienceMonster) + (([double] $ExperienceMonster) * ($SelectBonus / 100))) * $SelectAOE
            $monsterkillbeforeup = 100 / ([double] $ExperienceMonster)
            $monsterkillbeforeup = [math]::ceiling($monsterkillbeforeup)
            $ExperienceMonsterMinute = (([double] $ExperienceMonster) * 60) / $SelectTime
            $ExperienceMonsterHeure = $ExperienceMonsterMinute * 60
            $Timebeforeup = $monsterkillbeforeup * $SelectTime
            $TimebeforeupHeu = $Timebeforeup / 3600
            $TimebeforeupMin = ($Timebeforeup / 60) % 60
            $TimebeforeupSec = $Timebeforeup % 60

            #round result
            $ExperienceMonster = [math]::Round($ExperienceMonster, 3)
            #$monsterkillbeforeup = [math]::ceiling($monsterkillbeforeup)
            $ExperienceMonsterMinute = [math]::Round($ExperienceMonsterMinute, 3)
            $ExperienceMonsterHeure = [math]::Round($ExperienceMonsterHeure, 3)
            $TimebeforeupHeu = [math]::Floor($TimebeforeupHeu)
            $TimebeforeupMin = [math]::Floor($TimebeforeupMin)
            $TimebeforeupSec = [math]::Floor($TimebeforeupSec)
            [System.Windows.Forms.MessageBox]::Show( "Nombre de monstre/AOE à faire avant de up : $monsterkillbeforeup" + "`r`n" + "expérience par monstre/AOE tuer : $ExperienceMonster%" + "`r`n" + "expérience par minute : $ExperienceMonsterMinute%" + "`r`n" + "expérience par heure : $ExperienceMonsterHeure%" + "`r`n" + "Temps avant de up : $TimebeforeupHeu h $TimebeforeupMin m $TimebeforeupSec s", "$SelectItemMonster", 0)
            #display dialogue with actual load element
        }
        else
        {
            [System.Windows.Forms.MessageBox]::Show( "Veuillez Selectionner un monstre et un level du joueur", "ERROR", 0) 
        }       
    }
    Elseif ($Result -eq [System.Windows.Forms.DialogResult]::Retry) {
        [System.Windows.Forms.MessageBox]::Show( "Veuillez patienté cela peut prendre une dizaine de minutes, cliquer sur OK pour commencer", "INFO", 0)
        $api_call = $PSScriptRoot.ToString() + "\call_api.ps1"
        powershell -file "$api_call"
        $return_list = Init
        $Listform = $return_list[0]
        $ListBoxMonster = $return_list[1]
        $ListBoxLevel = $return_list[2]
        $Path = $return_list[3]
        $TextBoxTime = $return_list[4]
        $TextBoxBonus = $return_list[5]
        $TextBoxAOE = $return_list[6]
        [System.Windows.Forms.MessageBox]::Show( "update des informations sur les monstres terminée", "INFO", 0) 
    }
    Elseif ($Result -eq [System.Windows.Forms.DialogResult]::Cancel) {
        Exit
    }
}