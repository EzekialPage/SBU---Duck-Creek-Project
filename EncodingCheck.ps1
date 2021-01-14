Write-Output "First part"
#Validate encoding of file based on BOM (Byte Order Mark)
#Based on code from https://gist.github.com/jpoehls/2406504

#input from employee of state + version number. only wanting to run say 9/20 state folders
$clientName = Read-Host -Prompt "Enter client name (ex. TESTCLIENT) "
$clientLOBName = Read-Host -Prompt "Enter client's LOB folder (ex. property) "
$clientPath = 'C:\Users\ebpag\Desktop\DuckCreek\' + $clientName + '\'+ $clientLOBName

#function to check file for UTF-8 encoding
function getEncoding($fileName){
    $ret = ""
     [byte[]]$byte = get-content -Encoding byte -ReadCount 4 -TotalCount 4 -Path $fileName
    # EF BB BF (UTF8)
     if ( $byte[0] -eq 0xef -and $byte[1] -eq 0xbb -and $byte[2] -eq 0xbf ) {
        $ret =  'UTF-8 with BOM'
    } else { 
        $ret = 'Wrong encoding or no BOM'
    }
    return $ret
}

#Determine path of newest version
function newestPath($clPath){
    $newestPath = ""
    Get-ChildItem -Path $clPath | ForEach{
        if($_.Name -gt $newestPath){
            $newestPath = $_.FullName
        }
    }
    return $newestPath
}

$flag = 0
#Iterate through folders in LOB    
Get-ChildItem -Path $clientPath | ForEach{
    $old = $_.FullName+"\*.xml"
    $maxPath = newestPath($old)

    #store output variable names
    $stateName = $_.Name
    $fileInfo = Get-ChildItem -Path $maxPath
    $fileName = $fileInfo.Name
    
    #store file encoding result in variable
    $encodingCheck = getEncoding($maxPath)

    #check for incorrect encoding
    if ($encodingCheck -ne 'UTF-8 with BOM') {
        #check for previous errors
        if($flag -eq 0){
            Write-Host "The following files have incorrect encoding:" -ForegroundColor Red
            $flag++
        }
        Write-Host 'Folder: ' $stateName
        Write-Host $fileName
        Write-Host
    }
}
#check to see if there were no errors
if($flag -eq 0){
        Write-Host "All files have UTF-8 with BOM"
}