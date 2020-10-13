#Compare versions of carrier pages
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