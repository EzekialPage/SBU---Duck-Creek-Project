Write-Output "Second part:"
#This script will iterate through a file strucutre and verify that 
#the encoding line was removed from the top of the xml file 

$clientName = Read-Host -Prompt "Enter client name (ex. TESTCLIENT) "
$clientLOBName = Read-Host -Prompt "Enter client's LOB folder (ex. Property) "
$clientPath = 'C:\SaaS\' + $clientName + '\Policy\ManuScripts\DCTTemplates\' + $clientLOBName
#$clientPath ='C:\Users\ebpag\Desktop\DuckCreek\' + $clientName + '\'+ $clientLOBName 

#create arraylist of file names
function newestFileList($clPath){
    #usedNames will have a file name and the next index will have its maxversion array 
    $usedNames = [object][System.Collections.ArrayList]@()
    Get-ChildItem -Path $clPath | ForEach{
        $maxVer = @($null,$null,$null,$null)
        $currentVer = @($null,$null,$null,$null)
        $doubleArr = @($currentVer, $maxVer)
        #separate version number from title
        $name = ""
        $count=0
        $splitArr = ""
        $splitArr = $_.BaseName.Split("_") 
        for(($i = 0); ($i -lt $splitArr.Length);$i++){
            if($splitArr[$i] -match "^\d+$"){
                $currentVer[$count] = $splitArr[$i]
                $count++
            }else{
                if($name -eq ""){
                    $name += $splitArr[$i]
                }else{
                    $name += "_" + $splitArr[$i]
                }
            }
        }
        #update usedNames arraylist with file name and max version 
        $index = $usedNames.indexOf($name)
        if($index -lt 0){
            $usedNames.Add($name)
            $usedNames.Add($currentVer)
        }else{
            $maxVer = $usedNames[$index + 1]
            $doubleArr[0] = $currentVer
            $doubleArr[1] = $maxVer
            $compVal = compareVer($doubleArr)
            #Write-Host "COMPARE: " $doubleArr " CompVal: " $compVal
            if($compVal -eq 1){
                for($j = 0;$j -lt $maxVer.Length;$j++){
                    $maxVer[$j] = $CurrentVer[$j]
                }
                $usedNames[$index + 1] = $maxVer
            }
            <#elseif($compVal -ne 2){
                Write-Host $doubleArr
                Write-Host "Error in compare output: " $compVal
            }#>
        }
    }
    #Write-Host "UsedNames: " $usedNames "`n"
    $output = createFileList($usedNames)
    return $output
}

#function to compare version number arrays
#outputs 1 if first paramater is newer or 2 if second paramater is newer
function compareVer($inArr){
    $arr1= $inArr[0]
    $arr2 = $inArr[1]
    for($i = 0; $i -lt $arr1.count; $i++){
        #Write-Host "A1: " $arr1[$i]
        #Write-Host "A2: " $arr2[$i]
        if($arr1[$i] -gt $arr2[$i]){
            return 1
        }elseif($arr2[$i] -gt $arr1[$i]){
            return 2
        }
    }
}

#combines array containing file names and its most recent version into single array
function createFileList($arrList){
    $outArr = [System.Collections.ArrayList]@()
    for($i = 0; $i -lt (($arrList.count + 1) / 2); $i+=2){
    $versionString = ""
    $verArr = $arrList[$i + 1]
        for($j = 0; $j -lt $verArr.count;$j++){
            if($verArr[$j] -ne $null){
                $versionString += "_" + $verArr[$j]
            }
        }
    $fileName = $arrList[$i] + $versionString 
    $outArr.Add($fileName)
    }
    return $outArr
}

$flag = 0
#Iterate through folders in LOB    
Get-ChildItem -Path $clientPath | ForEach{
    $LobPath = $_.FullName
    $stateName = $_.Name
    $outString = "Folder: " + $stateName + "`n"
    $newFiles = newestFileList($LobPath)
    $ifFlag = 0
    Get-ChildItem -Path $LobPath | ForEach{ 
        if($newFiles -contains $_.BaseName){
            #determine if encoding line exists
            $encodingLine = Get-ChildItem -Path $_.FullName -ErrorAction stop | Select-String -Pattern 'encoding="utf-8"'

            #display results to user
            if ($encodingLine -ne $null) {

                #check for previous errors
                if($flag -eq 0){
                    Write-Host "Utf-8 encoding line found in the following files:" -ForegroundColor Red
                    $flag++
                }
                $fileName = $_.Name
                $outString += $fileName + "`n"
                $ifFlag++
            }
        }#end if
    }
    if($ifFlag -ne 0){
        Write-Host $outString
    }
}
#check to see if there were no errors
if($flag -eq 0){
        Write-Host "No Utf-8 encoding lines were found" -ForegroundColor Green
}
