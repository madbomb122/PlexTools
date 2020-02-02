$PlexFolder = 'P:\Library\Application Support\Plex Media Server\Metadata\'
#path to your plex metadata folder above

$TV_or_Movie = 1
# 0 - movie
# 1 - tv shows

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
$Script_Version = '1.0.0'
$Script_Date = 'Feb-02-2020'
##########

$TestRun = If($Dryrun -eq 1){ $True } Else{ $False }
If($PlexFolder.Substring($PlexFolder.Length -1,1) -ne '\'){ $PlexFolder += '\' }

$ToM, $PlexFolder = If($TV_or_Movie -eq 1) {
	'tv_show'
	($PlexFolder + 'TV Shows\')
} ElseIf($TV_or_Movie -eq 0) {
	'Movie'
	($PlexFolder + 'Movies\')
}

$Count = 0
$Saved = 0

$list = Get-Childitem -Path $PlexFolder -directory 
ForEach($ls in $list){
	$base = "$PlexFolder$ls\"
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
				Write-Host "Would be deleted: $drm" -ForegroundColor 'Red' -BackgroundColor 'Black'
			}
			$Count++
		} Else {
			$Saved++
		}
	}
}
Write-Host "Total Removed: $Count"
Write-Host "  Total Saved: $Saved"
