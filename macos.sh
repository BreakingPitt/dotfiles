#!/bin/zsh

set -o errexit
set -o pipefail

# General - Set computer name (as done via System Preferences → Sharing).
sudo scutil --set ComputerName "Converge"
sudo scutil --set HostName "Converge"
sudo scutil --set LocalHostName "Converge"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "Converge"

# General - Automatically quit printer app once the print jobs complete.
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# General - Disable the “Are you sure you want to open this application?” dialog.
defaults write com.apple.LaunchServices LSQuarantine -bool false

# General - Disable auto-correct.
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# General - Disable the sound effects on boot.
sudo nvram SystemAudioVolume=" "

# General - Disable the warning before emptying the Trash.
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# General - Expand save panel by default.
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# General - Expand print panel by default.
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# General - Save to disk (not to iCloud) by default.
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# General - Set the timezone; see `systemsetup -listtimezones` for other values.
systemsetup -settimezone "Europe/Madrid" > /dev/null

# General - Show the ~/Library folder
chflags nohidden ~/Library

# General - Show the ~/Users folder
chflags nohidden /Users

# Transmission - Don’t prompt for confirmation before downloading.
defaults write org.m0k.transmission DownloadAsk -bool false
defaults write org.m0k.transmission MagnetOpenAsk -bool false

# Transmission - Don’t prompt for confirmation before removing non-downloading active transfers.
defaults write org.m0k.transmission CheckRemoveDownloading -bool true

# Transmission - Hide the donate message.
defaults write org.m0k.transmission WarningDonate -bool false

# Transmission - Hide the legal disclaimer.
defaults write org.m0k.transmission WarningLegal -bool false

# Transmission - Ip block list.
defaults write org.m0k.transmission BlocklistNew -bool true
defaults write org.m0k.transmission BlocklistURL -string "http://john.bitsurge.net/public/biglist.p2p.gz"
defaults write org.m0k.transmission BlocklistAutoUpdate -bool true

# Transmission - Randomize port on launch.
defaults write org.m0k.transmission RandomPort -bool true

# Transmission - Trash original torrent files.
defaults write org.m0k.transmission DeleteOriginalTorrent -bool true

# Transmission - Use `~/Documents/Torrents` to store incomplete downloads.
defaults write org.m0k.transmission UseIncompleteDownloadFolder -bool true
defaults write org.m0k.transmission IncompleteDownloadFolder -string "${HOME}/Documents/Torrents"

# Transmission - Use `~/Downloads` to store completed downloads.
defaults write org.m0k.transmission DownloadLocationConstant -bool true
