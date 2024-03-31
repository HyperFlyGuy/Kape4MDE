<#
.NOTES
It is a compilation of other projects that I have observed with some of my own flavor added in. Please read the README at "https://github.com/HyperFlyGuy/Kape4MDE" for a more complete explanation of usage and what is required.

.SYNOPSIS
This script allows you to use kape to acquire Windows forensics artifacts. 
The included executables in the packaged zip file are:
kape.exe
kape targets folder
kape modules folder
MRC.exe (included in kape modules folder)
7za.exe
#>
param (
[parameter(Mandatory=$false)]
[string]$collection = $null,
[parameter(Mandatory=$false)]
[string]$artifacts = $null
)

function SANSCollection {
    $zipFilePath = "C:\ProgramData\Microsoft\Windows Defender Advanced Threat Protection\Downloads\kape.zip"
    $extractPath = "C:\kape"
    # Check if the extraction directory exists, if not, create it
    if (-not (Test-Path -Path $extractPath -PathType Container)) {
        New-Item -ItemType Directory -Path $extractPath -Force | Out-Null
    }
    
    # Unzip the file using the built-in ComObject Shell.Application
    $shell = New-Object -ComObject Shell.Application
    $zipFile = $shell.NameSpace($zipFilePath)
    $destination = $shell.NameSpace($extractPath)
    $destination.CopyHere($zipFile.Items())
    
    # Wait for the extraction process to complete 
    while ($destination.Items().Count -ne $zipFile.Items().Count) {
        Start-Sleep -Seconds 1
    }
    # Execute the kape.exe with the given parameters
    C:\kape\kape.exe --tsource C:\ --tdest C:\kape\output --target !SANS_Triage --vhdx Triage 
}
function MemoryCollection {
    $zipFilePath = "C:\ProgramData\Microsoft\Windows Defender Advanced Threat Protection\Downloads\kape.zip"
    $extractPath = "C:\kape"
    
    # Check if the extraction directory exists, if not, create it
    if (-not (Test-Path -Path $extractPath -PathType Container)) {
        New-Item -ItemType Directory -Path $extractPath -Force | Out-Null
    }
    
    # Unzip the file using the built-in ComObject Shell.Application
    $shell = New-Object -ComObject Shell.Application
    $zipFile = $shell.NameSpace($zipFilePath)
    $destination = $shell.NameSpace($extractPath)
    $destination.CopyHere($zipFile.Items())
    
    # Wait for the extraction process to complete 
    while ($destination.Items().Count -ne $zipFile.Items().Count) {
        Start-Sleep -Seconds 1
    }
    
    # Execute the kape.exe with the given parameters
    C:\kape\kape.exe --tsource C:\ --tdest C:\kape\output --mdest C:\kape\output\memory  --target MemoryFiles --zip  --module MagnetForensics_RAMCapture    
}
function CustomArtifactCollection {
    $zipFilePath = "C:\ProgramData\Microsoft\Windows Defender Advanced Threat Protection\Downloads\kape.zip"
    $extractPath = "C:\kape"
    # Check if the extraction directory exists, if not, create it
    if (-not (Test-Path -Path $extractPath -PathType Container)) {
        New-Item -ItemType Directory -Path $extractPath -Force | Out-Null
    }
    
    # Unzip the file using the built-in ComObject Shell.Application
    $shell = New-Object -ComObject Shell.Application
    $zipFile = $shell.NameSpace($zipFilePath)
    $destination = $shell.NameSpace($extractPath)
    $destination.CopyHere($zipFile.Items())
    
    # Wait for the extraction process to complete 
    while ($destination.Items().Count -ne $zipFile.Items().Count) {
        Start-Sleep -Seconds 1
    }
    # Execute the kape.exe with the given parameters
    C:\kape\kape.exe --tsource C:\ --tdest C:\kape\output --vhdx Triage --target $Artifacts  
}
function Split {
#Handles all the zipping functionality
$source = "C:\kape\output"
$outputPath = "C:\kape\Done"
$baseName = "Complete"
# Check if the zipping directory exists and if it does will wipe it before starting the process, if not, create it
if (Test-Path -Path $outputPath ) {
    Remove-Item -Recurse -Force -path "C:\kape\Done"
    C:\kape\7za.exe a -tzip -v2g $outputPath\$baseName.zip $source -x!$outputPath\*
}
else{
    C:\kape\7za.exe a -tzip -v2g $outputPath\$baseName.zip $source -x!$outputPath\*
}
}
function Cleanup {
#Cleans up the output of the Kape collection
Write-Host ""
Write-Host "[*] Cleaning up Kape Collection [*]"

if(Test-Path "C:\kape"){
Remove-Item -Recurse -Force -path "C:\kape"
Write-Host "[*]The evidence generated from KAPE has been removed![*]"
}
else
{
Write-Host "[*]The evidence generated from KAPE was not present![*]"
}
Write-Host ""
Write-Host "[*] Clean up has been completed. Exiting now... [*]"
}


if ($collection -eq $null -and $artifacts -eq $null){
    Write-Host "You need to specify either a collection or a set of Kape artifacts. Please review the forensics documentation. Below you will find example commands that are compatible with the MDE Live Response Console:"`n`n"run kape.ps1 -parameters `"-collection triage`""`n"run kape.ps1 -parameters `"-collection memory`""`n"run kape.ps1 -parameters `"-collection cleanup`""`n"run kape.ps1 -parameters `"-collection split`""`n"run kape.ps1 -parameters `"-collection all`""`n"run kape.ps1 -parameters `"-collection custom -artifacts RegistryHivesSystem`""
}
elseif (-not ($collection -eq $null)) {
    switch ($collection.ToLower()){
        triage{SANSCollection}
        memory{MemoryCollection}
        split{Split}
        cleanup{Cleanup}
        custom{CustomArtifactCollection}
        all{
            SANSCollection
            MemoryCollection
            Zip
        }
        Default{Write-Host "You need to specify either a collection or a set of Kape artifacts. Please review the forensics documentation. Below you will find example commands that are compatible with the MDE Live Response Console:"`n`n"run kape.ps1 -parameters `"-collection triage`" "`n"run kape.ps1 -parameters `"-collection memory`" "`n"run kape.ps1 -parameters `"-collection cleanup`""`n"run kape.ps1 -parameters `"-collection split`""`n"run kape.ps1 -parameters `"-collection all`""`n"run kape.ps1 -parameters `"-collection custom -artifacts RegistryHivesSystem`""} 
}
}
