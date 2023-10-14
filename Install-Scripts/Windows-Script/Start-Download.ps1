# asking the user what they want to download, and then download those programs
function Start-Download { 
    param(
        [switch]$all,
        [switch]$developerTools,
        [switch]$essentialPackages,
        [switch]$gamingPackages,
        [switch]$productivityTools,
        [switch]$powerTools
    )   

    . .\Check-Pre-Conditions.ps1
    Test-Pre-Conditions

    $menu = @(
        "1 - develop tools",
        "2 - essential packages",
        "3 - gaming packages",
        "5 - power tools",
        "4 - productivity tools"
    )
    $files = @{
        1 = "Developer-Tools/for-Windows.txt"
        2 = "Essential-Packages/for-Windows.txt"
        3 = "Gaming-Packages/for-Windows.txt"
        4 = "Power-Tools/for-Windows.txt"
        5 = "Productivity-Tools/for-Windows.txt"
    }
    Write-Host "`nPlease choose one or more options (separated by commas):`n"
    foreach ($option in $menu) {
        Write-Host $option
    }

    $chosenCatagories = Read-Host
    $commas = (",")
    $chosenCatagories = $choice.Split($commas)
    foreach ($catagory in $chosenCatagories) {
        $relitivePathToFiles = ("../../Lists-of-Programs/")
        $path = ($relitivePathToFiles + $catagory)
        Add-Programms-from-File -path $path
        
    }

    Write-Host "Done installing apps using chocolatey!"
    Add-Finder
}

function Add-Programms-from-File {
    param (
        [String]$path
    )

    $file = ($relitivePathToFiles + $files[[int]$catagory])
    $fileDoesNotExist = -not (Test-Path $file)
    if ($fileDoesNotExist) {
        Write-Error "Error, File not found: $file"
        exit $withErrorBecauseOfMissingFile
    }

    $programms = Get-Content $file
    foreach ($program in $programms) {

        $programIsAlreadyInstalled = (Get-Command $program -ErrorAction SilentlyContinue)
        if ($programIsAlreadyInstalled) {
            Write-Host "The program `"$program`" is installed."
            continue # to the next program on the list
        } 

        $command = "choco install $program -y"
        Invoke-Expression $command
    }
}

function Add-Finder { 
    
    # creates a link to the explorer aplication named "finder" 
    # and puts this into the start menu so that it can be searched
    # for using "powerRun" aka spotlight for windows. (see PowerToys)

    Write-Host "Now adding Finder to the start menu."
    $WshShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\finder.lnk")
    $Shortcut.TargetPath = "C:\Path\To\Your\Program.exe"
    $Shortcut.IconLocation = (
        "~\OneDrive - TU Eindhoven\Documents\Personal\Projects-and-Hobbies\Coding\Utilities\Finder.ico")
    $Shortcut.Save()
}