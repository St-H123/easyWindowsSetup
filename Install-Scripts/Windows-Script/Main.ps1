<#
.SYNOPSIS
   Get a windows instance ready for use by installing all proper software, and executing commands
   to make the instance more how you would like it.

.DESCRIPTION
   This script installs software form the chocolatey reposistory (it does sometimes use winget, or scoop)
   if chocolatey does not have the package. It asks the user what software they would like to install. Or
   if the create action is used then the script will install all software and execute some under the hood
   commands such that the computer is set up.

.PARAMETER help
   Use -h, -?, or --help to display this help message.

.PARAMETER action
   Specify the action you want to perform, for example:
   - install,
   - check,
   - create

.PARAMETER version
   Include this switch to get the version of the script

.PARAMETER all
   Include this switch to download all content

.EXAMPLE
   .\MyScript.ps1 --version

   This command output the version of the script

.EXAMPLE
   .\MyScript.ps1 --help

   Display the help message for the script.

.EXAMPLE
   .\MyScript.ps1 install -all

   this message will install all software the script knows.
#>
param (
    [Parameter()][Alias("--help", "-h")][switch]$help,
    [Parameter()][Alias("--version", "-v")][switch]$version,
    [Parameter()][string]$action="",
    [Parameter()][Alias("--all", "-a")][switch]$all
)

[String]$ProgramVersion = "1.0.0"

#explanation of constants
. .\Constants.ps1

# Variables
$helpText = @(
    " - install [[-h xor --help] xor [-v xor --version] xor [-a xor --all]]"
    " - check [[-h xor --help] xor [-v xor --version]]"
    " - create [[-h xor --help] xor [-v xor --version]]"
    ""
    "These are the exit codes that the program maintains:"
    " - 0 all good"
    " - 1 pre-conditions failed"
    " - 2 unknown, or illegal combinations of arguments")
[int]$errorCount = 0

function Start-Execution { # sent the execution to the right place in the program based on the users choices

    $userWantsHelp = ($help)

    $illegalArgumentsWhereMade = ($help -and $version)
    if ($illegalArgumentsWhereMade) {exit $withErrorBecauseOfIllegalArguments}

    $actionIsNotInstall = (-not ($action -eq "install"))
    $allParameterIsused = ($all)
    $illegalArgumentsWhereMade = ($actionIsNotInstall -and $allParameterIsused)
    if ($illegalArgumentsWhereMade) {exit $withErrorBecauseOfIllegalArguments}

    $userWantsToKnowTheVersion = ($version)
    if ($userWantsToKnowTheVersion) {
        Write-Host $ProgramVersion -ForegroundColor Green
        exit $withSucces
    } 
    
    $userWantsToInstallProgramms = ($action -eq "install")
    if ($userWantsToInstallProgramms) {
        if ($userWantsHelp) {
            $message = (
                "You can use this to install a set of programs. " +
                "Installing already installed programs will result " +
                "in an update if possible, otherwise nothing happens.")
            Write-Host $message
        } else {
            . .\Start-Download.ps1
            Start-Download
            Write-Host "Succes!" -ForegroundColor Green
            Write-Host "All the Programs you selected were processed."
        }
        exit $withSucces
    } 

    $userWantsToCheckPreConditions = ($action -eq "check")
    if ($userWantsToCheckPreConditions) {
        if ($userWantsHelp) {
            $message = (
                "This checks if the pre-conditions are met and if not " +
                "will exit with an exit code of 1, if they are met it " +
                "will exit with exit code 0.")
            Write-Host $message
        } else {
            . .\Check-Pre-Conditions.ps1
            Test-Pre-Conditions
            Write-Host "Succes!" -ForegroundColor Green
            Write-Host "Everthing is checking out, you are good to go."
        }
        exit $withSucces
    } 
    
    $userWantsToCreateInstance = ($action -eq "create")
    if ($userWantsToCreateInstance) {
        if ($userWantsHelp) {
            $message = (
                "Installs all avalible software and executes all " +
                "commands that are stored.")
            Write-Host $message
        } else {
            . .\Check-Pre-Conditions.ps1
            Test-Pre-Conditions
            Write-Host "Succes!" -ForegroundColor Green
            Write-Host "Everthing is checking out, you are good to go."
        }
        exit $withSucces
    } 
      
    if ($userWantsHelp) {
        foreach ($line in $helpText) {
            Write-Host $line
        }
        exit $withSucces
    }

    Write-Host "Invalid action or missing action. Use: " -ForegroundColor Red
    foreach ($line in $helpText) {Write-Host $line -ForegroundColor Red}
    exit $withErrorBecauseOfIllegalArguments
}

Start-Execution
