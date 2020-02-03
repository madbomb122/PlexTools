$PlexFolder = 'P:\Library\Application Support\Plex Media Server\Metadata\'
#path to your plex metadata folder above

##########
# Plex Folder to Title
#
# Script By
#  Author: Madbomb122
# Website: https://GitHub.com/Madbomb122/PlexTools/
#
$Script_Version = '1.0.0'
$Script_Date = 'Feb-02-2020'
##########

If($PlexFolder.Substring($PlexFolder.Length -1,1) -ne '\'){ $PlexFolder += '\' }

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
