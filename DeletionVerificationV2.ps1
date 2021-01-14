Write-Output "Second part:"
#This script will iterate through a file strucutre and verify that 
#the encoding line was removed from the top of the xml file 

$clientName = Read-Host -Prompt "Enter client name (ex. TESTCLIENT) "
$clientLOBName = Read-Host -Prompt "Enter client's LOB folder (ex. property) "
#$clientPath = 'C:\SaaS\' + $clientName + '\Policy\ManuScripts\DCTTemplates\' + $clientLOBName
$clientPath ='C:\Users\ebpag\Desktop\DuckCreek\' + $clientName + '\'+ $clientLOBName 

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
    $stateName = $_.Name
    $old = $_.FullName+"\*.xml"
    $maxPath = newestPath($old)

    #determine if encoding line exists
    $encodingLine = Get-ChildItem -Path $maxPath -ErrorAction stop | Select-String -Pattern 'encoding="utf-8"'

    #display results to user
    if ($encodingLine -ne $null) {

        #check for previous errors
        if($flag -eq 0){
            Write-Host "Utf-8 encoding line found in the following files:" -ForegroundColor Red
            $flag++
        }
        Write-Host 'Folder: ' $stateName
        Write-Host $encodingLine.Filename
        Write-Host
    }
}
#check to see if there were no errors
if($flag -eq 0){
        Write-Host "No Utf-8 encoding lines were found"
}