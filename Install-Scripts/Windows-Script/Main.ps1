param (
    [string]$action,
    [switch]$help,
    [switch]$version
)

#explanation of constants
$withSucces = 0
$withError = 2

$helpText = @(
    " - install [[-h xor --help] xor [-v xor --version] xor [-a xor --all]]"
    " - check [[-h xor --help] xor [-v xor --version]]"
    " - create [[-h xor --help] xor [-v xor --version]]"
    ""
    "These are the exit codes that the program maintains:"
    " - 0 all good"
    " - 1 pre-conditions failed"
    " - 2 unknown, or illegal combinations of arguments")
$errorCount = 0

if ($version) {
    Write-Host "1.0.0" -ForegroundColor Green
} elseif ($action -eq "install") {
    if ($help) {
        Write-Host "You can use this to install a set of programs. Installing already installed programs will result in an update if possible, otherwise nothing happens."
    } else {
        . .\Start-Download.ps1
        Start-Download
        Write-Host "Succes!" -ForegroundColor Green
        Write-Host "All the Programs you selected were processed."
    }
} elseif ($action -eq "check") {
    if ($help) {
        Write-Host "This checks if the pre-conditions are met and if not will exit with an exit code of 1, if they are met it will exit with exit code 0."
    } else {
        . .\Check-Pre-Conditions.ps1
        Test-Pre-Conditions
        Write-Host "Succes!" -ForegroundColor Green
        Write-Host "Everthing is checking out, you are good to go."
    }
} elseif ($action -eq "create") {
    if ($help) {
        Write-Host "Installs all avalible software and executes all commands that are stored."
    } else {
        . .\Check-Pre-Conditions.ps1
        Test-Pre-Conditions
        Write-Host "Succes!" -ForegroundColor Green
        Write-Host "Everthing is checking out, you are good to go."
    }
} elseif ($help) {
    foreach ($line in $helpText) {
        Write-Host $line
    }
} else {
    Write-Host "Invalid action or missing action. Use: "
    foreach ($line in $helpText) {
        Write-Host $line
    }
    exit $withError
}
exit $withSucces
