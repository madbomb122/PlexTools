[![Donate](https://img.shields.io/badge/Donate-Amazon-yellowgreen.svg?style=plastic)](https://www.amazon.com/gp/registry/wishlist/YBAYWBJES5DE/)
[![GitHub Release](https://img.shields.io/github/release/madbomb122/PlexTools.svg?style=plastic)](https://github.com/madbomb122/PlexTools/releases)
[![GitHub Release Date](https://img.shields.io/github/release-date/madbomb122/PlexTools.svg?style=plastic)](https://github.com/madbomb122/PlexTools/releases)
[![GitHub Issues](https://img.shields.io/github/issues/madbomb122/PlexTools.svg?style=plastic)](https://github.com/madbomb122/PlexTools/issues)
# 
To Download go to -> [Plex Tools -Release](https://github.com/madbomb122/PlexTools/releases)  

**Current Version**   
**Meta Clean:** `1.1.1` (Febuary 08, 2020)   
**Title List:** `1.0.1` (Febuary 04, 2020)   

## Contents
 - [Description](#description)
 - [Working On](#working-on)
 - [Usage Meta Clean](#usage-meta-clean)
 - [Usage Titles](#usage-titles)
 - [Notes](#notes)
 - [FAQ](#faq)

## Description
Various powershell scripts for plex servers.   

`plex-metaclean.ps1` -Removes metadata folders (TV Shows and/or Movies) that meet the following conditions
1. Folder does not have the following file `\Contents\_combined\Info.xml`
2. There is no tile in the file above

`Plex-titles.ps1` -Gets you a list of items in your library and shows what tv/movie corresponds to what metadata folder

## Working On
Im currently writing a Script to help add cast members to `TV Shows` and `Movies`. It is almot done (should be out within 24 hours, if no issues are found)

## Usage Meta Clean
1. Run the script  
`powershell.exe -NoProfile -ExecutionPolicy Bypass -File c:/plex-metaclean.ps1`  
*For the above, Please note you need change the c:/ to the fullpath of your file*  

or use a switch/argument for automation

|     Switch     |                                   Description                                            |
| :------------- | :----------------------------------------------------------------------------------------|
| -movie         | Cleans the movie metadata folder                                                         |
| -tv            | Cleans the tv metadata folder                                                            |
| -dry           | Runs and shows what will be deleted w/o the -dry switch (need to do a switch above too)  |

Example: 
`powershell.exe -NoProfile -ExecutionPolicy Bypass -File c:/plex-metaclean.ps1 -argument -dry -tv -movie`  

2. Enjoy a cleaner metadata folder  

## Usage Titles
1. Run the script  
`powershell.exe -NoProfile -ExecutionPolicy Bypass -File c:/plex-titles.ps1`  
*For the above, Please note you need change the c:/ to the fullpath of your file*  

## Notes
I have tested this on a NAS running the plex server, I DO NOT know if this works on other plex servers ATM. I recommend you first use the dryrun option to make sure it works fine.  

I may make improvements to the script to make it easier to use.

## FAQ
**Q:** The script file looks all messy in notepad, How do I view it?   
**A:** Try using wordpad or what I recommend, Notepad++ [https://notepad-plus-plus.org/](https://notepad-plus-plus.org/) 

**Q:** Do you accept any donations?   
**A:** If you would like to donate to me Please pick an item/giftcard from my amazon wishlist or Contact me about donating, Thanks. BTW The giftcard amount can be changed to a min of $1.   
**Wishlist:** [https://www.amazon.com/gp/registry/wishlist/YBAYWBJES5DE/](https://www.amazon.com/gp/registry/wishlist/YBAYWBJES5DE/)  

**Q:** How can I contact you?  
**A:** You can also PM me on reddit or email me  
         1. reddit /u/madbomb122 [https://www.reddit.com/user/madbomb122](https://www.reddit.com/user/madbomb122)  
         2. You can email me @ madbomb122@gmail.com.  
**Note** Before contacting me, please make sure you have ALL the needed files.

**Q:** Can I run the script safely?   
**A:** `Ples-titles` - is 100% safe.  
       `Plex-metaclean` - unlikly to cause issues but, can cause a show/movie to not be listed if it accidently deletes a wrong folder.  

**Q:** I have a Suggestion/Issue for the script, how do I suggest it?   
**A:** Do a pull request with the change or submit it as an issue with the suggestion.   

**Q:** I cant access the plex folder to run thus script?   
**A:** You may have to give yourself permission on the plex folder.   
