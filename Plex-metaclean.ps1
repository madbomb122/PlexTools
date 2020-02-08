##########
# Plex Metadata Folder Clean Up
#
# Script By
#  Author: Madbomb122
# Website: https://GitHub.com/Madbomb122/PlexTools/
#
$Script_Version = '1.1.1'
$Script_Date = 'Feb-08-2020'
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
	Write-Host '1. Please create the file'
	Write-Host "2. Put path to your plex metadata folder in it"
	Write-Host 'Example: P:\Library\Application Support\Plex Media Server\Metadata\'
	Read-Host 'Press any key to exit'
	Exit
}

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
		$testing = "\$PlexToM\$ls\"
		Write-Host "Testing in: $base" -ForegroundColor 'Green' -BackgroundColor 'Black'
		$dirs = Get-Childitem -Path $base -directory
		ForEach($dr in $dirs){
			$drm = $base + $dr
			$xmlpath = "$drm\Contents\_combined\Info.xml"
			$Title = If(Test-Path $xmlpath) {
				[xml]$tmpxml = Get-Content $xmlpath
				$tmpxml.$ToM.Title
			}
			If(!$Title -or $Title -eq ''){
				If(!$TestRun) {
					Try {
						Remove-Item -LiteralPath $drm -Force -Recurse
						Write-Host "--Deleting : $testing$dr" -ForegroundColor 'Yellow' -BackgroundColor 'Black'
					} Catch {
						Write-Host "--Unable to delete : $testing$dr" -ForegroundColor 'Red' -BackgroundColor 'Black'
					}
				} Else {
					Write-Host "--Would be deleted: $testing$dr" -ForegroundColor 'Red' -BackgroundColor 'Black'
				}
				$Script:Count++
			} Else {
				$Script:Saved++
			}
		}
	}
}

Function GuiStart {
[xml]$XAML =@"
	<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
	  Title="Plex Metaclean By: MadBomb122" Height="250" Width="220" BorderBrush="Black" Background="White">
		<Window.Effect><DropShadowEffect/></Window.Effect>
		<Grid>
			<Grid.RowDefinitions>
				<RowDefinition Height="*"/>
				<RowDefinition Height="*"/>
				<RowDefinition Height="5*"/>
				<RowDefinition Height="1.5*"/>
			</Grid.RowDefinitions>
			<Label Grid.Row="0" Content="Plex Metaclean by: Madbomb122" HorizontalAlignment="Center" VerticalAlignment="Center"/>
			<TextBlock Grid.Row="1" TextWrapping="Wrap" Text="v.$Script_Version ($Script_Date)" HorizontalAlignment="Center" VerticalAlignment="Center" IsEnabled="False"/>
			<GroupBox Grid.Row="2" Header="Options" Margin="2">
				<Grid>
					<Grid.RowDefinitions>
						<RowDefinition Height="*"/>
						<RowDefinition Height="*"/>
						<RowDefinition Height="*"/>
						<RowDefinition Height="*"/>
					</Grid.RowDefinitions>
					<CheckBox Grid.Row="0" Margin="5" HorizontalAlignment="Left" VerticalAlignment="Center" Name="TV_CB" Content="Tv Shows"/>
					<CheckBox Grid.Row="1" Margin="5" HorizontalAlignment="Left" VerticalAlignment="Center" Name="Movie_CB" Content="Movies"/>
					<CheckBox Grid.Row="3" Margin="5" HorizontalAlignment="Left" VerticalAlignment="Center" Name="Dryrun_CB" Content="Dryrun/What if"/>
				</Grid>
			</GroupBox>
			<Button Grid.Row="3" Margin="5" Name="RunButton" Content="Run Plex Metaclean"/>
		</Grid>
	</Window>
"@

	[Void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
	$Form = [Windows.Markup.XamlReader]::Load( (New-Object System.Xml.XmlNodeReader $xaml) )
	$xaml.SelectNodes('//*[@Name]').ForEach{Set-Variable -Name "WPF_$($_.Name)" -Value $Form.FindName($_.Name) -Scope Script}
	[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms') | Out-Null

	$WPF_RunButton.Add_Click{
		$Form.close()
		$TestRun = $WPF_Dryrun_CB.IsChecked
		If($WPF_Movie_CB.IsChecked){ PlexMetaClean 'movie' 'Movies' }
		If($WPF_TV_CB.IsChecked){ PlexMetaClean 'tv_show' 'TV Shows' }
		If(!$TestRun){
			Write-Host "Total Removed: $Count"
			Write-Host "  Total Saved: $Saved"
		} Else {
			Write-Host "Would be Removed: $Count"
			Write-Host "  Would be Saved: $Saved"
		}
		Read-Host "Done, Press any key to exit"
	}

	$Form.ShowDialog() | Out-Null
}

If($args[0]){
	If($args -Contains '-Dry'){ $TestRun = $True }
	If($args -Contains '-Movie'){ PlexMetaClean 'movie' 'Movies' }
	If($args -Contains '-Tv'){ PlexMetaClean 'tv_show' 'TV Shows' }
	If(!$TestRun){
		Write-Host "Total Removed: $Count"
		Write-Host "  Total Saved: $Saved"
	} Else {
		Write-Host "Would be Removed: $Count"
		Write-Host "  Would be Saved: $Saved"		
	}
} Else {
	GuiStart
}
 
