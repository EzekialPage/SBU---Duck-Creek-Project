Write-Host "Fourth part:"
#This script will iterate through a file structure, find the newest version 
#of a product file (if any) and verify manuscripts table values

#Prompt user input and create pathing variables
$clientName = Read-Host -Prompt "Enter client name to verfiy there is a table or not (ex. TESTCLIENT)"
$clientLOB = Read-Host -Prompt "Enter LOB "
$tableLOB = '<table id="Manuscripts' + $clientLOB
$version = Read-Host -Prompt "Enter version Number (ex. 10_X_X_X)"
$clientPath = "C:\Users\ebpag\Desktop\DuckCreek\$clientName\$clientLOB"
$fileName = "*" +$clientLOB + "_Product_*.xml"

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
#iterate through client folder
Get-ChildItem -Path $clientPath | ForEach{
    #store output variables
    $ifTrue = "False"
    Write-Host "Folder: " $_.Name
    $old = $_.FullName+"\$fileName"
    $newPath = newestPath($old)

    #check for valid product file
    if($newPath -ne ""){
        #check for valid table
        $tableLine = Get-ChildItem -Path $newPath | Select-String -Pattern $tableLOB -Quiet
        if ($tableLine) {
            [XML]$tableData = Get-Content $newPath
            #iterate through xml file
            foreach($empDetail in $tableData.manuscript.model.object.table) {
                $tableName = $empDetail.id
                $targetName = "Manuscripts"+$clientLOB
                #look for table with correct name
                if($tableName -eq $targetName){
                    #stop and set flag true if valid version numbers found in table
                    $compareString = $empDetail.data.row.value
                    if ($compareString -match $version ) {
                        $ifTrue = "True"
                        break
                    }
                }
            }
            #output results of comparison
            if ($ifTrue -eq "True") {
                Write-Host "Manuscript table was successfully updated"
                Write-Host ""
            } else {
                Write-Host "Manuscript table failed to update successfully" -ForegroundColor Red
                Write-Host ""
            }
        } else {
            #no table was found in product file
            Write-Host "No table present" -ForegroundColor Red
            Write-Host ""
        }
    }else{
        #no product file was found in folder
        Write-Host "No product file found" -ForegroundColor Red
        Write-Host ""
    }
}