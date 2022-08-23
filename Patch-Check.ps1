<#
.SYNOPSIS
This script is intended to be deployed from a RMM console to run accross
multiple machines to check if the patch for CVE-2022-34713 (AKA "DogWalk")
has been installed for Windows machines. This will check all relevant patches
for Windows 7 64/32 bit, Windows 8/8.1 RT/64/32/ bit, all versions of Windows 10 64/32 bit,
all versions of Windows 11 ARM/64/32 bit, and Windows Server 2008, 2012, 2016, 2019, and 2022.
#>
$patchArr = @(
                "KB5016622",
                "KB5016623",
                "KB5016616",
                "KB5016639",
                "KB5016629",
                "KB5016676",
                "KB5016679",
                "KB5016681",
                "KB5016683",
                "KB5016618",
                "KB5016672",
                "KB5016684",
                "KB5016627"
            )

Function Compare-Patches(){
    param(
        [System.Object]$array
    )
    $patched = $false
    $patchID = ""
    $instPacs = get-wmiobject -class win32_quickfixengineering
    for($i=0;$i -lt $instPacs.Length;$i++){
        $tempPac = $instPacs[$i].HotFixID
        for($j=0;$j -lt $array.length;$j++){
            if($tempPac -eq $array[$j]){
                $patched = $true
                $patchID = $array[$j]
                break
            }
        }
    }
    $info = @($patched, $patchID)
    return $info
}

$IsPatched = Compare-Patches -array $patchArr
$window = New-Object -ComObject Wscript.Shell
if($IsPatched[0]){
    Write-Host "Patch: $($IsPatched[1]) is installed for CVE-2022-34713."
    $window.Popup("Patch: $($IsPatched[1]) is installed for CVE-2022-34713.",0,"Patch Installed",64)
}else{
    Write-Host "No patch installed for CVE-2022-34713."
    $window.Popup("No patch installed for CVE-2022-34713!",0,"Patch NOT Installed",48)
}