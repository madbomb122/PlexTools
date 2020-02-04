##########
# Plex Folder to Title
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

Function GetPlexInfo {
	Param(
		[String]$ToM,
		[String]$PlexToM
	)
	$PlexFolderToM = ($PlexFolder + $PlexToM + '\')
	$list = Get-Childitem -Path $PlexFolderToM -directory 
	$FunList = ForEach($ls in $list){
		$base = "$PlexFolderToM$ls\"
		$dirs = Get-Childitem -Path $base -directory
		Write-Host "Scanning: $base" -ForegroundColor 'Green' -BackgroundColor 'Black'
		ForEach($dr in $dirs){
			$drm = $base + $dr
			$xmlpath = "$drm\Contents\_combined\Info.xml"
			If(Test-Path $xmlpath) {
				[xml]$tmpxml = get-content $xmlpath
				$Title = $tmpxml.$ToM.Title
				If($Title){
					[PSCustomObject] @{ Title = $Title ;Folder = "$PlexToM\$ls\$dr" ;TvMovie = $ToM }
				}
			}
		}
	}
	Return $FunList
}
$TvMovieList = GetPlexInfo 'tv_show' 'TV Shows'
$TvMovieList += GetPlexInfo 'Movie' 'Movies'

$TvMovieList| Out-GridView
Read-Host 'Showing list, press any key to close'
