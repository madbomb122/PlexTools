##########
# Plex Add Casts
#
# Script By
#  Author: Madbomb122
# Website: https://GitHub.com/Madbomb122/PlexTools/
#
$Script_Version = '1.0.0'
$Script_Date = 'Mar-05-2020'
##########

$Copyright = ' The MIT License (MIT) + an added Condition                             
                                                                        
 Copyright (c) 2017-2020 Madbomb122                                     
                                                                        
 Permission is hereby granted, free of charge, to any person obtaining  
 a copy of this software and associated documentation files (the        
 "Software"), to deal in the Software without restriction, including    
 without limitation the rights to use, copy, modify, merge, publish,    
 distribute, sublicense, and/or sell copies of the Software, and to     
 permit persons to whom the Software is furnished to do so, subject to  
 the following conditions:                                              
                                                                        
 The above copyright notice(s), this permission notice and ANY original 
 donation link shall be included in all copies or substantial portions  
 of the Software.                                                       
                                                                        
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY  
 KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE 
 WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR    
 PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS 
 OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR   
 OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
 OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE  
 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.     
                                                            '

$FileBase = $(If($psISE -ne $Null){ Split-Path $psISE.CurrentFile.FullPath -Parent } Else{ $PSScriptRoot })
$File = $FileBase + '\PlexFolder.txt'

If(Test-Path -LiteralPath $File) {
	$tmp = Get-Content $File
	If($tmp -ne $null -and (Test-Path -LiteralPath $tmp)) {
		$FileBase = $tmp
		If($FileBase.Substring($FileBase.Length -1,1) -ne '\'){ $FileBase += '\' }
	}
}

$MySite = 'https://GitHub.com/madbomb122/PlexTools'
$Donate_Url = 'https://www.amazon.com/gp/registry/wishlist/YBAYWBJES5DE/'

[xml]$template = @"
<?xml version='1.0' encoding='utf-8'?>
  <roles>
    <item index="0">
      <photo>Delete Me</photo>
      <role>Delete Me</role>
      <name>Delete Me</name>
    </item>
  </roles>
"@

Function StartGui {
[xml]$XAML =@"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
  Title="Plex Cast Adder Script By: MadBomb122" Height="540" Width="720" BorderBrush="Black" Background="White">
	<Window.Effect>
		<DropShadowEffect/>
	</Window.Effect>
	<Grid>
		<Grid.RowDefinitions>
			<RowDefinition Height="20"/>
			<RowDefinition Height="*"/>
			<RowDefinition Height="20"/>
		</Grid.RowDefinitions>
		<Menu Grid.Row="0" IsMainMenu="True">
			<MenuItem Header="File">
				<MenuItem Name="OpenFile" Header="Open..."/>
				<MenuItem Name="SaveFile" Header="Save"/>
				<MenuItem Name="SaveAsFile" Header="Save As..."/>
			</MenuItem>
			<MenuItem Header="Help">
				<MenuItem Name="FeedbackButton" Header="Feedback/Bug Report"/>
				<MenuItem Name="FAQButton" Header="FAQ"/>
				<MenuItem Name="AboutButton" Header="About"/>
				<MenuItem Name="CopyrightButton" Header="Copyright"/>
				<MenuItem Name="ContactButton" Header="Contact Me"/>
			</MenuItem>
			<MenuItem Name="DonateButton" Header="Donate to Me" Background="Orange" FontWeight="Bold"/>
			<MenuItem Name="Madbomb122WSButton" Header="Madbomb122's GitHub" Background="Gold" FontWeight="Bold"/>
		</Menu>
		<DataGrid Grid.Row="1" Name="dataGrid" AutoGenerateColumns="False" AlternationCount="2" HeadersVisibility="Column" CanUserResizeRows="False" CanUserAddRows="True" SelectionMode="Extended">
			<DataGrid.RowStyle>
				<Style TargetType="{ x:Type DataGridRow }">
					<Style.Triggers>
						<Trigger Property="AlternationIndex" Value="0">
							<Setter Property="Background" Value="White"/>
						</Trigger>
						<Trigger Property="AlternationIndex" Value="1">
							<Setter Property="Background" Value="#FFD8D8D8"/>
						</Trigger>
					</Style.Triggers>
				</Style>
			</DataGrid.RowStyle>
			<DataGrid.Columns>
				<DataGridTemplateColumn SortMemberPath="checkboxChecked" CanUserSort="True">
					<DataGridTemplateColumn.CellTemplate>
						<DataTemplate>
							<CheckBox IsChecked="{Binding checkboxChecked,Mode=TwoWay,UpdateSourceTrigger=PropertyChanged,NotifyOnTargetUpdated=True}"/>
						</DataTemplate>
					</DataGridTemplateColumn.CellTemplate>
				</DataGridTemplateColumn>
				<DataGridTextColumn Header="Name" Width="120" Binding="{Binding Name}"/>
				<DataGridTextColumn Header="Role" Width="121" Binding="{Binding Role}"/>
				<DataGridTextColumn Header="Photo" Width="200" Binding="{Binding Photo}"/>
			</DataGrid.Columns>
		</DataGrid>
		<Button Grid.Row="2" Name="AddCast" Content="Add Cast Member" IsEnabled="False"/>
	</Grid>
</Window>
"@
	[Void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
	$Form = [Windows.Markup.XamlReader]::Load( (New-Object System.Xml.XmlNodeReader $xaml) )
	$xaml.SelectNodes('//*[@Name]').ForEach{Set-Variable -Name "WPF_$($_.Name)" -Value $Form.FindName($_.Name) -Scope Script}
	[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms') | Out-Null

	$WPF_OpenFile.Add_Click{ OpenSaveDiaglog 0 }
	$WPF_SaveFile.Add_Click{ SaveFile $FileOpened }
	$WPF_SaveAsFile.Add_Click{ OpenSaveDiaglog 1 }
	$WPF_ContactButton.Add_Click{ Start 'mailto:madbomb122@gmail.com' }
	$WPF_Madbomb122WSButton.Add_Click{ Start 'https://GitHub.com/madbomb122/' }
	$WPF_FeedbackButton.Add_Click{ Start "$MySite/issues" }
	$WPF_FAQButton.Add_Click{ Start "$MySite/blob/master/README.md" }
	$WPF_DonateButton.Add_Click{ Start $Donate_Url }
	$WPF_CopyrightButton.Add_Click{ [Windows.Forms.Messagebox]::Show($Copyright,'Copyright', 'OK') | Out-Null }
	$WPF_AboutButton.Add_Click{ [Windows.Forms.Messagebox]::Show("This script lets you add or remove cast members from a 'TV Show' or 'Movie' in one of plex's metadata xml file.`n`nThis script was created by MadBomb122.",'About', 'OK') | Out-Null }
	$WPF_AddCast.Add_Click{ PopWindow }

	$Form.ShowDialog() | Out-Null
}

Function PopWindow {
[xml]$XAMLPW = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
  Title="Cast Add" Height="150" Width="285" BorderBrush="Black" Background="White" WindowStyle="ToolWindow">
	<Grid>
		<Grid.RowDefinitions>
			<RowDefinition Height="3*"/>
			<RowDefinition Height="3*"/>
			<RowDefinition Height="3*"/>
			<RowDefinition Height="3*"/>
		</Grid.RowDefinitions>
		<Grid.ColumnDefinitions>
			<ColumnDefinition Width="*"/>
			<ColumnDefinition Width="2*"/>
		</Grid.ColumnDefinitions>
		<TextBlock Grid.Row="0" Grid.Column="0" FontWeight="Bold" VerticalAlignment="Center" TextAlignment="Right">Name:</TextBlock>
		<TextBox Grid.Row="0" Grid.Column="1" Margin="5" VerticalAlignment="Center" Name="NameInput" TextAlignment="Left" Text="" MinWidth="100"/>
		<TextBlock Grid.Row="1" Grid.Column="0" FontWeight="Bold" VerticalAlignment="Center" TextAlignment="Right">Role:</TextBlock>
		<TextBox Grid.Row="1" Grid.Column="1" Margin="5" VerticalAlignment="Center" Name="RoleInput" TextAlignment="Left" Text="" MinWidth="100"/>
		<TextBlock Grid.Row="2" Grid.Column="0" FontWeight="Bold" VerticalAlignment="Center" TextAlignment="Right">Photo:</TextBlock>
		<TextBox Grid.Row="2" Grid.Column="1" Margin="5" VerticalAlignment="Center" Name="PhotoInput" TextAlignment="Left" Text="" MinWidth="100"/>
		<Grid Grid.Row="3" Grid.ColumnSpan="2">
			<Grid.ColumnDefinitions>
				<ColumnDefinition Width="*"/>
				<ColumnDefinition Width="*"/>
			</Grid.ColumnDefinitions>
			<Button Grid.Column="0" Name="Button0" Content="Add" Margin="5" VerticalAlignment="Top" Width="76"/>
			<Button Grid.Column="1" Name="Button1" Content="Cancel" Margin="5" VerticalAlignment="Top" Width="76"/>
		</Grid>
	</Grid>
</Window>
"@

	[Void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
	$FormPW = [Windows.Markup.XamlReader]::Load( (New-Object System.Xml.XmlNodeReader $XAMLPW) )
	$XAMLPW.SelectNodes('//*[@Name]').ForEach{Set-Variable -Name "WPFPW_$($_.Name)" -Value $FormPW.FindName($_.Name) -Scope Script}

	$WPFPW_Button0.Add_Click{
		$Script:role += [PSCustomObject] @{ Role = $WPFPW_RoleInput.text; Name = $WPFPW_NameInput.text; Photo = $WPFPW_PhotoInput.text; checkboxChecked = $True }
		$WPF_dataGrid.ItemsSource = $role
		$FormPW.Close()
	}
	$WPFPW_Button1.Add_Click{ $FormPW.Close() }
	$FormPW.ShowDialog() | Out-Null
}

Function ClearRoles{ $script:imp.SelectNodes("/$ToM/roles/item") | ForEach{$_.ParentNode.RemoveChild($_)} | Out-Null }

Function OpenSaveDiaglog([Int]$SorO) {
	$SOFileDialog = If($SorO -eq 0){ New-Object System.Windows.Forms.OpenFileDialog } Else{ New-Object System.Windows.Forms.SaveFileDialog }
	$SOFileDialog.InitialDirectory = $FileBase
	$SOFileDialog.Filter = 'Xml (*.xml)| *.xml'
	$SOFileDialog.ShowDialog()
	$SOFPath = $SOFileDialog.Filename
	If($SOFPath) {
		If($SorO -eq 0) {
			$Script:FileOpened = $SOFPath
			If(Test-Path -LiteralPath $FileOpened){ OpenFile $FileOpened }
		} ElseIf($SorO -eq 1) {
			SaveFile $SOFPath
		}
	}
}

Function OpenFile([String]$OFile) {
	$Script:imp = [xml](Get-Content $OFile)
	$Script:ToM = If($imp.Tv_Show){ 'TV_Show' } Else{ 'Movie' }
	$Script:role = $imp.SelectNodes("/$ToM/roles/item") | ForEach{
		[PSCustomObject] @{
			role = $_.role
			photo = $_.photo
			name = $_.name
			checkboxChecked = $True
		}
	}
	ClearRoles
	$WPF_dataGrid.ItemsSource = $role
	$WPF_AddCast.IsEnabled = $True
}

Function SaveFile([String]$SFile) {
	$node = $template.SelectSingleNode("/roles")
	ClearRoles
	$tmpRole = $Role.where{$_.checkboxChecked -eq $True}
	$act = $template.SelectSingleNode("/roles/item[@index='0']")
	$act.role = $tmpRole.role[0]
	$act.photo = $tmpRole.photo[0]
	$act.name = $tmpRole.name[0]
	$act.index = [string]0
	$node.Appendchild($act)

	For($i=1 ;$i -lt $tmpRole.get_Count() ;$i++) {
		$act = $template.SelectSingleNode("/roles/item[@index='0']").CloneNode($True)
		$act.role = $tmpRole.role[$i]
		$act.photo = $tmpRole.photo[$i]
		$act.name = $tmpRole.name[$i]
		$act.index = [string]$i
		$node.Appendchild($act)
	}

	$imp.DocumentElement.AppendChild($imp.ImportNode($template.get_DocumentElement(), $True)) | Out-Null
	$imp.Save($SFile)
}

StartGui