#Manuscript table validation
Write-Output "Fourth part:"

#lines about checking if table is present
$clientLOB = Read-Host -Prompt "Enter LOB: "
$tableLOB = '<table id="Manuscript' +$clientLOB
$tableLine = Get-ChildItem -Path C:\Users\Family\Desktop\TempDCT\PracTable.xml | Select-String -Pattern $tableLOB
#if there or not {
$compareString = ""
$XMLFile = 'C:\Users\Family\Desktop\TempDCT\PracTable.xml'
[XML]$tableData = Get-Content $XMLFile
foreach($empDetail in $tableData.table.data.row){
    #Write-Output $empDetail.value
    $compareString += $empDetail.value
}
Write-Output " "
$compareString2 = ""
$XMLFile2 = 'C:\Users\Family\Desktop\TempDCT\PracNewTable.xml'
[XML]$newTableData = Get-Content $XMLFile2
foreach($empDetail2 in $newTableData.table.data.row){
    #Write-Output $empDetail2.value
    $compareString2 += $empDetail2.value
}
$compareString.Equals($compareString2)

$compareString = ""
$XMLFile = 'C:\Users\Family\Desktop\TempDCT\PracTable.xml'
[XML]$tableData = Get-Content $XMLFile
foreach($empDetail in $tableData.table.data.row){
    #Write-Output $empDetail.value
    $compareString += $empDetail.value
}
Write-Output " "

$compareString2 = ""
$XMLFile2 = 'C:\Users\Family\Desktop\TempDCT\CopyPracTable.xml'
[XML]$newTableData = Get-Content $XMLFile2
foreach($empDetail2 in $newTableData.table.data.row){
    #Write-Output $empDetail2.value
    $compareString2 += $empDetail2.value
}
$compareString.Equals($compareString2)