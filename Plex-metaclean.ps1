$TV_or_Movie = 2
# 0 - movies
# 1 - tv shows
# 2 - movies & tv shows 

$Dryrun = 1
# 0 - delete the items
# 1 - see what will be deleted (dryrun/whatif)

##########
# Plex Metadata Folder Clean Up
#
# Script By
#  Author: Madbomb122
# Website: https://GitHub.com/Madbomb122/PlexTools/
#
$Script_Version = '1.0.1'
$Script_Date = 'Feb-04-2020'
##########

$FileBase = $(If($psISE -ne $Null){ Split-Path $psISE.CurrentFile.FullPath -Parent } Else{ $PSScriptRoot })
$File = $FileBase + '\PlexFolder.txt'

If(Test-Path -LiteralPath $File) {
	$tmp = Get-Content $File
	If($tmp -ne $null -and (Test-Path -LiteralPath $tmp)) {
		$PlexFolder = $tmp
		If($PlexFolder.Substring($PlexFolder.Length -1,1) -ne '\'){ $PlexFolder += '\' }
	} Else {
		Write-Host 'Path not found or is incorrect'
		Write-Host "Please put path to your plex metadata folder in 'PlexFolder.txt'"
		Write-Host 'Example: P:\Library\Application Support\Plex Media Server\Metadata\'
		Read-Host 'Press any key to exit'
		Exit
	}
} Else {
	Write-Host "File 'PlexFolder.txt' not found"
	Write-Host 'Please do the following'
	Write-Host '1 .Please create the file'
	Write-Host "2. Put path to your plex metadata folder in it"
	Write-Host 'Example: P:\Library\Application Support\Plex Media Server\Metadata\'
	Read-Host 'Press any key to exit'
	Exit
}

$TestRun = If($Dryrun -eq 1){ $True } Else{ $False }

$Script:Count = 0
$Script:Saved = 0
Function PlexMetaClean {
	Param(
		[String]$ToM,
		[String]$PlexToM
	)	
	$PlexFolderToM = ($PlexFolder + $PlexToM + '\')
	$list = Get-Childitem -Path $PlexFolderToM -directory 
	ForEach($ls in $list){
		$base = "$PlexFolderToM$ls\"
		Write-Host "Testing in: $base" -ForegroundColor 'Green' -BackgroundColor 'Black'
		$dirs = Get-Childitem -Path $base -directory
		ForEach($dr in $dirs){
			$drm = $base + $dr
			$xmlpath = "$drm\Contents\_combined\Info.xml"
			$Title = If(Test-Path $xmlpath) {
				[xml]$tmpxml = get-content $xmlpath
				$tmpxml.$ToM.Title
			}
			If(!$Title -or $Title -eq ''){
				If(!$TestRun) {
					Remove-Item -LiteralPath $drm -Force -Recurse
				} Else {
					Write-Host "--Would be deleted: $drm" -ForegroundColor 'Red' -BackgroundColor 'Black'
				}
				$Script:Count++
			} Else {
				$Script:Saved++
			}
		}
	}
}

If($TV_or_Movie -In 0,2){ PlexMetaClean 'Movie' 'Movies' }
If($TV_or_Movie -In 1,2){ PlexMetaClean 'tv_show' 'TV Shows' }

Write-Host "Total Removed: $Count"
Write-Host "  Total Saved: $Saved"
