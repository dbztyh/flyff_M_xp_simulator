#Add some modules
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

#min - max gold
#location mobs

# Text variable to easy change language
$script:Tag = 1
#Tag value : 1 = FR , 3 = US
$script:ButtonCancel_Text = "" 
$script:ButtonOk_Text = "" 
$script:ButtonUpdate_Text = "" 
$script:FormLabelMonster_Text = "" 
$script:FormLabelLevel_Text = "" 
$script:FormLabelTime_Text = "" 
$script:FormLabelBonus_Text = "" 
$script:FormLabelAOE_Text = ""
$script:ExperienceMonster_Text = ""
$script:monsterkillbeforeup_Text = ""
$script:ExperienceMonsterMinute_Text = ""
$script:ExperienceMonsterHeure_Text = ""
$script:Timebeforeup_Text = ""
$script:MaxAttack_Text = ""
$script:MinAttack_Text = ""
$script:hp_Text = ""
$script:element_Text = ""
$script:update_Text = ""
$script:update_end_Text = ""

# Form variable
$script:ListForm = $null
$script:ListBoxMonster = $null
$script:ListBoxLevel = $null
$script:TextBoxTime = $null
$script:TextBoxBonus = $null
$script:TextBoxAOE = $null

#Path variable
$script:Path_parent = $PSScriptRoot.ToString()
$script:Path = $PSScriptRoot.ToString() + "\ressources"
$script:api_call = $PSScriptRoot.ToString() + "\call_api.ps1"
$script:Path_Name_Monster = $PSScriptRoot.ToString() + "\ressources\name_monster.txt"
$script:Path_Exp_Monster = $PSScriptRoot.ToString() + "\ressources\exp_monster.txt"
$script:Path_Location_Monster = $PSScriptRoot.ToString() + "\ressources\location_monster.txt"
$script:Path_Icon_Monster = $PSScriptRoot.ToString() + "\ressources\icon_monster.txt"

Function Choice_Language{
    if ($script:Tag -eq 3)
    {
       $script:ButtonCancel_Text = "EXIT"
       $script:ButtonOk_Text = "OK"
       $script:ButtonUpdate_Text = "UPDATE"
       $script:FormLabelMonster_Text = "monsters :"
       $script:FormLabelLevel_Text = "Player level :"
       $script:FormLabelTime_Text = "Time to kill a monster or make an AOE in secondes :"
       $script:FormLabelBonus_Text = "experience bonus in % (don't complete if you haven't bonus) :"
       $script:FormLabelAOE_Text = "Nomber of monster kill (if you make 1v1 don't complete this field) :"
       $script:ExperienceMonster_Text = "experience by monster/AOE make : "
       $script:monsterkillbeforeup_Text = "Number of monster to do before up : "
       $script:ExperienceMonsterMinute_Text = "experience by minute : "
       $script:ExperienceMonsterHeure_Text = "experience by hour : "
       $script:Timebeforeup_Text = "Time before up : "
       $script:MaxAttack_Text = "Max Attack : "
       $script:MinAttack_Text = "Min Attack : "
       $script:hp_Text = "hp : "
       $script:element_Text = "Element : "
       $script:update_Text = "Please wait, this loading during 1 minute max, click on OK to begin"
       $script:update_end_Text = "Update information on monsters are finish."
    }
    else
    {
       $script:ButtonCancel_Text = "SORTIR"
       $script:ButtonOk_Text = "OK"
       $script:ButtonUpdate_Text = "MISE A JOUR"
       $script:FormLabelMonster_Text = "monstres :"
       $script:FormLabelLevel_Text = "Level du joueur : "
       $script:FormLabelTime_Text = "Temps pour tuer un monstre/faire un AOE en secondes:"
       $script:FormLabelBonus_Text = "Bonus expérience en % (ne pas remplir si pas de bonus) :"
       $script:FormLabelAOE_Text = "Nombres de monstres tuer par AOE (ne pas remplir si 1V1) :"
       $script:ExperienceMonster_Text = "expérience par monstre/AOE tuer : "
       $script:monsterkillbeforeup_Text = "Nombre de monstre/AOE à faire avant de up :"
       $script:ExperienceMonsterMinute_Text = "expérience par minute : "
       $script:ExperienceMonsterHeure_Text = "expérience par heure : "
       $script:Timebeforeup_Text = "Temps avant de up : "
       $script:MaxAttack_Text = "Attaque Max : "
       $script:MinAttack_Text = "Attaque Min : " 
       $script:hp_Text = "pv : "
       $script:element_Text = "Element : "
       $script:update_Text = "Veuillez patienté cela peut prendre jusqu'a une minutes, cliquer sur OK pour commencer"
       $script:update_end_Text = "Mise à jour des informations sur les monstres terminée"
    }
}

Function Init{
    Choice_Language

    #Ouvre la boite de dialogue
    $script:ListForm = New-Object System.Windows.Forms.Form
    $script:ListForm.Text = "Flyff_M_xp_simulator"
    $script:ListForm.Size = New-Object System.Drawing.Size(800,600)
    $script:ListForm.StartPosition = "CenterScreen"
    $script:ListForm.BackColor = "#303030"
    $script:ListForm.TopMost = $True

    #Ouvre la boite de dialogue apres avoir appuyer button OK
    $script:ListFormOK = New-Object System.Windows.Forms.Form
    $script:ListFormOK.Text = "Flyff_M_xp_simulator"
    $script:ListFormOK.Size = New-Object System.Drawing.Size(800,600)
    $script:ListFormOK.StartPosition = "CenterScreen"
    $script:ListFormOK.BackColor = "#303030"
    $script:ListFormOK.TopMost = $True

    
    #cree le label exp monstre
    $script:FormLabelExp = New-Object System.Windows.Forms.Label
    $script:FormLabelExp.Location = New-Object System.Drawing.Point(10,10)
    $script:FormLabelExp.Size = New-Object System.Drawing.Size(350,150)
    $script:FormLabelExp.ForeColor = "#FFFFFF"
    $script:FormLabelExp.Text = ""

    #cree le label info monstre
    $script:FormLabelInfo = New-Object System.Windows.Forms.Label
    $script:FormLabelInfo.Location = New-Object System.Drawing.Point(410,10)
    $script:FormLabelInfo.Size = New-Object System.Drawing.Size(350,100)
    $script:FormLabelInfo.ForeColor = "#FFFFFF"
    $script:FormLabelInfo.Text = ""

    $script:pictureBoxMonster = new-object Windows.Forms.PictureBox
    $script:pictureBoxMonster.Location = New-Object System.Drawing.Size(410,120)

    #Cancel button
    $ButtonCancel = New-Object System.Windows.Forms.Button
    $ButtonCancel.Location = New-Object System.Drawing.Point(520,520)
    $ButtonCancel.Size = New-Object System.Drawing.Size(75,23)
    $ButtonCancel.Text = "$script:ButtonCancel_Text"
    $ButtonCancel.BackColor = "#FFDF00"
    $ButtonCancel.DialogResult = [System.Windows.Forms.DialogResult]::Cancel

    #Ok button
    $ButtonOk = New-Object System.Windows.Forms.Button
    $ButtonOk.Location = New-Object System.Drawing.Point(180,520)
    $ButtonOk.Size = New-Object System.Drawing.Size(75,23)
    $ButtonOk.Text = "$script:ButtonOk_Text"
    $ButtonOk.BackColor = "#FFDF00"
    $ButtonOk.DialogResult = [System.Windows.Forms.DialogResult]::OK

    #Update button
    $ButtonUpdate = New-Object System.Windows.Forms.Button
    $ButtonUpdate.Location = New-Object System.Drawing.Point(325,520)
    $ButtonUpdate.Size = New-Object System.Drawing.Size(150,23)
    $ButtonUpdate.Text = "$script:ButtonUpdate_Text"
    $ButtonUpdate.BackColor = "#0072A0"
    $ButtonUpdate.DialogResult = [System.Windows.Forms.DialogResult]::Retry

    #FR button
    $ButtonFR = New-Object System.Windows.Forms.Button
    $ButtonFR.Location = New-Object System.Drawing.Point(320,20)
    $ButtonFR.Size = New-Object System.Drawing.Size(45,30)
    $imageFR = [System.Drawing.Image]::FromFile($Path_parent +"\FR2.png")
    $ButtonFR.Image = $imageFR
    $ButtonFR.DialogResult = [System.Windows.Forms.DialogResult]::Yes

    #US button
    $ButtonUS = New-Object System.Windows.Forms.Button
    $ButtonUS.Location = New-Object System.Drawing.Point(420, 20)
    $ButtonUS.Size = New-Object System.Drawing.Size(57,30)
    $imageUS = [System.Drawing.Image]::FromFile($Path_parent +"\US2.png")
    $ButtonUS.Image = $imageUS
    $ButtonUS.DialogResult = [System.Windows.Forms.DialogResult]::No

    #cree le label Monster
    $FormLabelMonster = New-Object System.Windows.Forms.Label
    $FormLabelMonster.Location = New-Object System.Drawing.Point(10,70)
    $FormLabelMonster.Size = New-Object System.Drawing.Size(350,20)
    $FormLabelMonster.ForeColor = "#FFFFFF"
    $FormLabelMonster.Text = "$script:FormLabelMonster_Text"

    #cree la liste Monster
    $script:ListBoxMonster = New-Object System.Windows.Forms.ListBox 
    $script:ListBoxMonster.Location = New-Object System.Drawing.Size(10,90) 
    $script:ListBoxMonster.Size = New-Object System.Drawing.Size(350,300) 
    $script:ListBoxMonster.Height = 300

    #cree le label Level
    $FormLabelLevel = New-Object System.Windows.Forms.Label
    $FormLabelLevel.Location = New-Object System.Drawing.Point(420,70)
    $FormLabelLevel.Size = New-Object System.Drawing.Size(350,20)
    $FormLabelLevel.ForeColor = "#FFFFFF"
    $FormLabelLevel.Text = "$script:FormLabelLevel_Text"

    #cree la liste Level
    $script:ListBoxLevel = New-Object System.Windows.Forms.ListBox 
    $script:ListBoxLevel.Location = New-Object System.Drawing.Size(420,90) 
    $script:ListBoxLevel.Size = New-Object System.Drawing.Size(350,300) 
    $script:ListBoxLevel.Height = 300

    #cree le label Time
    $FormLabelTime = New-Object System.Windows.Forms.Label
    $FormLabelTime.Location = New-Object System.Drawing.Point(10,400)
    $FormLabelTime.Size = New-Object System.Drawing.Size(350,20)
    $FormLabelTime.ForeColor = "#FFFFFF"
    $FormLabelTime.Text = "$script:FormLabelTime_Text"

    #cree l edit box Time
    $script:TextBoxTime = New-Object System.Windows.Forms.TextBox
    $script:TextBoxTime.Location = New-Object System.Drawing.Point(10,420)
    $script:TextBoxTime.Size = New-Object System.Drawing.Size(350,20)

    #cree le label Bonus
    $FormLabelBonus = New-Object System.Windows.Forms.Label
    $FormLabelBonus.Location = New-Object System.Drawing.Point(420,400)
    $FormLabelBonus.Size = New-Object System.Drawing.Size(350,20)
    $FormLabelBonus.ForeColor = "#FFFFFF"
    $FormLabelBonus.Text = "$script:FormLabelBonus_Text"

    #cree l edit box Bonus
    $script:TextBoxBonus = New-Object System.Windows.Forms.TextBox
    $script:TextBoxBonus.Location = New-Object System.Drawing.Point(420,420)
    $script:TextBoxBonus.Size = New-Object System.Drawing.Size(350,20)

    #cree le label AOE
    $FormLabelAOE = New-Object System.Windows.Forms.Label
    $FormLabelAOE.Location = New-Object System.Drawing.Point(10,460)
    $FormLabelAOE.Size = New-Object System.Drawing.Size(350,20)
    $FormLabelAOE.ForeColor = "#FFFFFF"
    $FormLabelAOE.Text = "$script:FormLabelAOE_Text"

    #cree l edit box AOE
    $script:TextBoxAOE = New-Object System.Windows.Forms.TextBox
    $script:TextBoxAOE.Location = New-Object System.Drawing.Point(10,480)
    $script:TextBoxAOE.Size = New-Object System.Drawing.Size(350,20)

    #List de tuple (item1 = level, item2 = name) du monstre
    $myList = New-Object System.Collections.ArrayList
    #remplir la liste Monster
    foreach($line in [System.IO.File]::ReadLines("$script:Path\name_monster.txt"))
    {
        $name = $line -split { $_ -eq "=" -or $_ -eq ";" -or $_ -eq "}" }
        $myList.Add([Tuple]::Create([Int]($name[5]),$name[$script:Tag])) | Out-Null
       
    }
    #trier la liste
    $myList = $myList | Sort-Object

    foreach($level_name in $myList)
    {
        $script:ListBoxMonster.Items.Add($level_name) | Out-Null
    }

    #remplir la liste level
    $val = 1
    while($val -ne 121)
    {
        $script:ListBoxLevel.Items.Add("$val") | Out-Null
        $val++
    }

    #ajout des elements a la boite de dialogue
    $script:ListForm.Controls.Add($ButtonOk)
    $script:ListForm.Controls.Add($ButtonCancel)
    $script:ListForm.Controls.Add($ButtonUpdate)
    $script:ListForm.Controls.Add($ButtonFR)
    $script:ListForm.Controls.Add($ButtonUS)
    $script:ListForm.Controls.Add($FormLabelMonster)
    $script:ListForm.Controls.Add($FormLabelLevel) 
    $script:ListForm.Controls.Add($FormLabelTime)
    $script:ListForm.Controls.Add($FormLabelBonus)
    $script:ListForm.Controls.Add($FormLabelAOE)
    $script:ListForm.Controls.Add($script:ListBoxMonster)
    $script:ListForm.Controls.Add($script:ListBoxLevel)
    $script:ListForm.Controls.Add($script:TextBoxTime)
    $script:ListForm.Controls.Add($script:TextBoxBonus)
    $script:ListForm.Controls.Add($script:TextBoxAOE)
}

#check if assembly file exist
If ((-not(Test-Path "$script:Path_Name_Monster")) -or (-not(Test-Path "$script:Path_Exp_Monster")))
{
   powershell -file "$script:api_call"
}

Init

while (1)
{
    #display dialogue with actual load element
    $Result = $script:ListForm.ShowDialog()

    #Action si bouton ok appuye
    If ($Result -eq [System.Windows.Forms.DialogResult]::OK) {
        $SelectItemMonster = [string]$script:ListBoxMonster.SelectedItem
        $SelectItemLevel = [string]$script:ListBoxLevel.SelectedItem
        $indexline = 0
        $indexline_bis = 0
        foreach($line in $file_name_monster = [System.IO.File]::ReadLines("$script:Path_Name_Monster"))
        {
            $indexline = $indexline + 1
            $name = $line -split { $_ -eq "=" -or $_ -eq ";" -or $_ -eq "}" }
            $test = "("+ $name[5] + ", " + $name[$script:Tag] + ")"
            if ($SelectItemMonster -eq $test)
            {
                $script:minAttack = $name[7]
                $script:maxAttack = $name[9]
                $script:hp = $name[11]
                $script:element = $name[13]
                $script:icon = $name[15]
                $indexline_bis = $indexline
            }
        }
        $indexline_tmp = 0
        foreach($line in $file_exp_monster = [System.IO.File]::ReadLines("$script:Path_Exp_Monster"))
        {
            $indexline_tmp = $indexline_tmp + 1
            if ($indexline_bis -eq $indexline_tmp)
            {
                $ExperienceMonsterList = $line -split { $_ -eq " " }

            }
        }
        $indexline_tmp = 0
        foreach($line in $file_exp_monster = [System.IO.File]::ReadLines("$script:Path_Location_Monster"))
        {
            $indexline_tmp = $indexline_tmp + 1
            if (($indexline_bis + 3) -eq $indexline_tmp)
            {
                $LocationMonster = $line -split { $_ -eq " " }
                Write-Output("location : $LocationMonster")
            }
        }
        $indexline_tmp = 0
        foreach($line in $file_exp_monster = [System.IO.File]::ReadLines("$script:Path_Icon_Monster"))
        {
            $indexline_tmp = $indexline_tmp + 1
            if ($indexline_bis -eq $indexline_tmp)
            {
                $icon_name_split = $line -split { $_ -eq "=" -or $_ -eq "}" }
                $icon_name = $icon_name_split[1] 
            }
        }
        if ($SelectItemMonster -ne "" -and $SelectItemLevel -ne "")
        {
            $SelectTime = $script:TextBoxTime.Text
            $SelectBonus = $script:TextBoxBonus.Text
            $SelectAOE = $script:TextBoxAOE.Text
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

            $img = [System.Drawing.Image]::Fromfile("$script:Path\$icon_name")
            #$script:pictureBoxMonster.Size = New-Object System.Drawing.Size(350,250)
            $script:pictureBoxMonster.Size = New-Object System.Drawing.Size($img.Width,$img.Height)
            $script:pictureBoxMonster.Image = $img
            $script:FormLabelExp.Text = "$script:monsterkillbeforeup_Text $monsterkillbeforeup" + "`r`n" + "$script:ExperienceMonster_Text $ExperienceMonster%" + "`r`n" + "$script:ExperienceMonsterMinute_Text $ExperienceMonsterMinute%" + "`r`n" + "$script:ExperienceMonsterHeure_Text $ExperienceMonsterHeure%" + "`r`n" + "$script:Timebeforeup_Text $TimebeforeupHeu h $TimebeforeupMin m $TimebeforeupSec s"
            $script:FormLabelInfo.Text = "$script:hp_Text $script:hp" + "`r`n" + "$script:MaxAttack_Text $script:maxAttack" + "`r`n" + "$script:MinAttack_Text $script:minAttack" + "`r`n" + "$script:element_Text $script:element"
            $script:ListFormOK.Controls.Add($script:FormLabelExp)
            $script:ListFormOK.Controls.Add($script:FormLabelInfo)
            $script:ListFormOK.Controls.Add($script:pictureBoxMonster)
            $script:ListFormOK.ShowDialog()
            
            #[System.Windows.Forms.MessageBox]::Show( "$script:monsterkillbeforeup_Text $monsterkillbeforeup" + "`r`n" + "$script:ExperienceMonster_Text $ExperienceMonster%" + "`r`n" + "$script:ExperienceMonsterMinute_Text $ExperienceMonsterMinute%" + "`r`n" + "$script:ExperienceMonsterHeure_Text $ExperienceMonsterHeure%" + "`r`n" + "$script:Timebeforeup_Text $TimebeforeupHeu h $TimebeforeupMin m $TimebeforeupSec s", "$SelectItemMonster", 0)
            #display dialogue with actual load element
        }
        else
        {
            [System.Windows.Forms.MessageBox]::Show( "Veuillez Selectionner un monstre et un level du joueur", "ERROR", 0) 
        }       
    }
    Elseif ($Result -eq [System.Windows.Forms.DialogResult]::Retry) {
        [System.Windows.Forms.MessageBox]::Show( "$script:update_Text", "INFO", 0)
        powershell -file "$script:api_call"
        Init
        [System.Windows.Forms.MessageBox]::Show( "$script:update_end_Text", "INFO", 0) 
    }
    Elseif ($Result -eq [System.Windows.Forms.DialogResult]::Yes) {
        $script:Tag = 1
        Init
    }
    Elseif ($Result -eq [System.Windows.Forms.DialogResult]::No) {
        $script:Tag = 3
        Init
    }
    Elseif ($Result -eq [System.Windows.Forms.DialogResult]::Cancel) {
        Exit
    }
}