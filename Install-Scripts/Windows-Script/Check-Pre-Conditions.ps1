# check if the pre-conditions have been met for any of the functions
function Test-Pre-Conditions {

    # Checking Windows Version Minimum Requirements
    $windowsVersion = ([Environment]::OSVersion.Version)
    $windowsVersionIsAtleastVersion7 = ($windowsVersion -lt [Version]"6.1")
    if ($windowsVersionIsAtleastVersion7) {
        $message = (
            "You must have Windows 7 or higher to use Chocolatey.`n" +
            "You are using Windows version: $windowsVersion.")
        Write-Error $message
        exit $withErrorBecauseOfFailedPreConditions
    }

    # Checking Powershell Version Minimum Requirements
    $powerShellVersion = ($PSVersionTable.PSVersion.Major)
    $powerShellIsVersion2OrHigher = ($powerShellVersion -lt 2)
    if ($powerShellIsVersion2OrHigher) {
        $message = (
            "You must have PowerShell v2 or higher to use Chocolatey.`n" +
            "You are using PowerShellVersion $powerShellVersion.")
        Write-Error $message
        exit $withErrorBecauseOfFailedPreConditions
    }

    try { # Checking .NET Version Minimum Requirements
        $dotNetVersion = [Environment]::Version
    } catch {
        $runtimeDirectory = [System.Runtime.InteropServices.RuntimeEnvironment]::GetRuntimeDirectory()
        $mscorlibFilePath = $runtimeDirectory + "mscorlib.dll"
        $dotNetVersion = [System.Diagnostics.FileVersionInfo]::GetVersionInfo($mscorlibFilePath).FileVersion} 
    $dotNetVersionIsAtLeast4Point8 = ([Version]$dotNetVersion -lt [Version]"4.8")
    if ($dotNetVersionIsAtLeast4Point8) {
        $message = (
            "You must have .NET Framework 4.8 or higher to use Chocolatey.`n" +
            "You are using .NET Framework Version $dotNetVersion.")
        Write-Error $message
        exit $withErrorBecauseOfFailedPreConditions
    }

    # Checking if running as root/administrator
    $CurrentSecurityLevel = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent())
    $runningAsAdministrator = ($CurrentSecurityLevel.IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
    if (-not $runningAsAdministrator) {
        $message = ("You must run this script as an Administrator.")
        Write-Error $message
        exit $withErrorBecauseOfFailedPreConditions
    }

    # Checking if Chocolatey is installed
    $chocoleteyIsNotInstalled = -not (Get-Command choco -ErrorAction SilentlyContinue)
    if ($chocoleteyIsNotInstalled) {
        Write-Host "Chocolatey is not installed. Now installing chocolatey." -ForegroundColor Yellow
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        $chocoInstallScript = ('https://community.chocolatey.org/install.ps1')
        (New-Object System.Net.WebClient).DownloadString($chocoInstallScript) | Invoke-Expression
    }
}
