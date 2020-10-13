#Ezekial Page
#Validate encoding of file based on BOM (Byte Order Mark)
#Based on code from https://gist.github.com/jpoehls/2406504

function Get-FileEncoding
{
  [CmdletBinding()] 
  Param (
    [Parameter(Mandatory = $True, ValueFromPipelineByPropertyName = $True)] 
    [string]$Path
  )

  #Write-Host Bytes: $byte[0] $byte[1] $byte[2] $byte[3]
  [byte[]]$byte = get-content -Encoding byte -ReadCount 4 -TotalCount 4 -Path $Path

  # EF BB BF (UTF8)
  if ( $byte[0] -eq 0xef -and $byte[1] -eq 0xbb -and $byte[2] -eq 0xbf )
  {
    Write-Output 'UTF-8 with BOM'
  }
  else
  { 
    Write-Output 'Wrong encoding or no BOM' 
  }
}

Get-ChildItem  -Path C:\Users\ebpag\Desktop\Temp\*.xml | Select Name, @{n='Encoding';e={Get-FileEncoding $_.FullName}}