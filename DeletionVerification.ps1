#validate deletion of encoding line at top of xml file
Write-Output "Second part:"

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