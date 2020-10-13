#Encoding Checker:
#Validate encoding of file based on BOM (Byte Order Mark)
#Based on code from https://gist.github.com/jpoehls/2406504
Write-Output "First part:"
function Get-FileEncoding {
  [CmdletBinding()] 
  Param (
    [Parameter(Mandatory = $True, ValueFromPipelineByPropertyName = $True)] 
    [string]$Path
  )
  #Write-Host Bytes: $byte[0] $byte[1] $byte[2] $byte[3]
  [byte[]]$byte = get-content -Encoding byte -ReadCount 4 -TotalCount 4 -Path $Path
  # EF BB BF (UTF8)
  if ( $byte[0] -eq 0xef -and $byte[1] -eq 0xbb -and $byte[2] -eq 0xbf ) {
    Write-Output 'UTF-8 with BOM'
  } else { 
    Write-Output 'Wrong encoding or no BOM' 
  }
}

$clientName = Read-Host -Prompt "Enter client name: "
$clientPath = 'C:\Users\ebpag\Desktop\Temp\' +$clientName+ '\*.xml'
try {
Get-ChildItem  -Path $clientPath -ErrorAction stop | Select Name, @{n='Encoding';e={Get-FileEncoding $_.FullName}}
}
catch [System.Exception]{
Write-Host "An error occured: "
Write-Host $_
}


Write-Output " "
Write-Output " "
Write-Output "Second part:"
#for the first part we are working under the assumption the master script always puts the first line there, and our encoding check is based off of that
$noEncodingLine = Get-ChildItem -Path C:\Users\Family\Desktop\TempDCT\*.xml | Where-Object {!($_ | Select-String 'encoding="utf-8' -Quiet) }
$encodingLine = Get-ChildItem -Path C:\Users\Family\Desktop\TempDCT\*.xml | Select-String -Pattern 'encoding="utf-8"'
if ($encodingLine -eq $null) {
    "No encoding line found in the files"
} else {
    "Encoding line found in the following files: "
    $encodingLine | foreach {$_.FileName}
    Write-Output " "
    "No encoding line found in the following files: "
    $noEncodingLine | foreach {$_.Name}

}


#$clientName = Read-Host -Prompt "Enter client name: "
#$clientPath = 'C:\Users\Family\Desktop\TempDCT' +$clientName+ '*.xml'
#try{
#Get-ChildItem -Path $clientPath -ErrorAction stop
#}
#catch[System.Exception]{
#Write-Host"An error occured: "
#Write-Host$_
#}
#finally{"finally reached"}



Write-Output " "
Write-Output " "
Write-Output "Third part:"
$prevFile = "C:\Users\Family\Desktop\TempDCT\PracScript.xml"
Write-Output $prevFile
$newFile = "C:\Users\Family\Desktop\TempDCT\DiffPracScript.xml"
Write-Output $newFile.
if (Compare-Object -ReferenceObject  $(Get-Content $prevFile) -DifferenceObject $(Get-Content $newFile)) {
    "The files had different contents"
    } else {
        "The files were the same"
    }
Write-Output " "
$prevFile = "C:\Users\Family\Desktop\TempDCT\PracScript.xml"
Write-Output $prevFile
$newFile = "C:\Users\Family\Desktop\TempDCT\EmptyPracScript.xml"
Write-Output $newFile.
if (Compare-Object -ReferenceObject  $(Get-Content $prevFile) -DifferenceObject $(Get-Content $newFile)) {
    "The files had different contents"
} else {
        "The files were the same"
}



Write-Output " "
Write-Output " "
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




#Get-ChildItem "C:\Users\Family\Desktop\TempDCT"  | Select Name, `
#  @{ n = 'Folder'; e = { Convert-Path $_.PSParentPath } }, `
#  @{ n = 'Foldername'; e = { ($_.PSPath -split '[\\]')[-2] } } ,
#  FullName

#USING A VARIABLE INSTEAD A DIRECT PATH - TO BE USED WITH CONCATENATION
#$testFileName = "C:\Users\Family\Desktop\TempDCT\*.xml"
#$invalidResults = Get-ChildItem -Path $testFileName | Where-Object {!($_ | Select-String 'encoding="utf-8"' -Quiet) }