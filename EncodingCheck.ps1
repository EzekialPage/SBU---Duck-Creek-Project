Write-Output "First part"
#Validate encoding of file based on BOM (Byte Order Mark)
#Based on code from https://gist.github.com/jpoehls/2406504

#input from employee
$clientName = Read-Host -Prompt "Enter client name (ex. TESTCLIENT) "
$clientLOB = Read-Host -Prompt "Enter client's LOB folder (ex. Property) "
#$clientPath = 'C:\Users\ebpag\Desktop\DuckCreek\' + $clientName + '\'+ $clientLOB
$clientPath = "C:\SaaS\$clientName\Policy\ManuScripts\DCTTemplates\$clientLOB"

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

#function to check file for UTF-8 encoding
function getEncoding($fileName){
    $ret = ""
     [byte[]]$byte = get-content -Encoding byte -ReadCount 4 -TotalCount 4 -Path $fileName -ErrorAction SilentlyContinue
     if($Error[0].Exception -is [System.UnauthorizedAccessException]){
        $ret = "Access to " + $fileName + " was denied."
     }
    # EF BB BF (UTF8)
    if($byte -ne $null){
        if ( $byte[0] -eq 0xef -and $byte[1] -eq 0xbb -and $byte[2] -eq 0xbf  ) {
            $ret =  'UTF-8 with BOM'
        } else { 
            $ret = 'Wrong encoding or no BOM'
        }
    }
    return $ret
}

$flag = 0
#Iterate through folders in LOB    
Get-ChildItem -Path $clientPath | ForEach{
    $LobPath = $_.FullName
    $stateName = $_.Name
    $outString = "Folder: " + $stateName + "`n"
    $newFiles = newestFileList($LobPath)
    #Write-Host $newFiles
    $ifFlag = 0
    Get-ChildItem -Path $LobPath | ForEach{ 
        if($newFiles -contains $_.BaseName){
            #store output variable names
            $fileInfo = Get-ChildItem -Path $_.FullName
            $fileName = $fileInfo.Name
            #store file encoding result in variable
            $encodingCheck = getEncoding($_.FullName)

            #check for incorrect encoding
            if ($encodingCheck -eq 'Wrong encoding or no BOM' ) {
                #check for previous errors
                if($flag -eq 0){
                    Write-Host "The following files have incorrect encoding:" -ForegroundColor Red
                    $flag++
                }
                $outString += $fileName + "`n"
                $ifFlag++
            }ElseIf($encodingCheck -ne 'UTF-8 with BOM'){
                Write-Host $encodingCheck
            }
        }
    }
    if($ifFlag -ne 0){
        Write-Host $outString
    }
}
#check to see if there were no errors
if($flag -eq 0){
        Write-Host "All files have UTF-8 with BOM" -ForegroundColor Green
}
