<##>
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
if($IsPatched[0]){
    Write-Host "Patch: $($IsPatched[1]) is installed for CVE-2022-34713."
}else{
    Write-Host "No patch installed for CVE-2022-34713."
}