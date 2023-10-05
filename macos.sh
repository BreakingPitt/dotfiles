#!/bin/zsh

set -o errexit
set -o pipefail

osascript -e 'tell application "System Preferences" to quit'

# Activity Monitor - Show the main window when launching.
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

# Activity Monitor- Visualize CPU usage in the Activity Monitor Dock icon.
defaults write com.apple.ActivityMonitor IconType -int 5

# Activity Monitor - Show all processes.
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# Activity Monitor - Sort Activity Monitor results by CPU usage.
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"

# Activity Monitor - Sort Activity Monitor results in desc order.
defaults write com.apple.ActivityMonitor SortDirection -int 0

# General - Automatically quit printer app once the print jobs complete.
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# General - Avoid creating .DS_Store files on network volumes.
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# General - Avoid creating .DS_Store files on USB volumes.
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Dock - Disable Dock magnification
defaults write com.apple.dock magnification -bool false

# Dock - Lock the Dock contents.
defaults write com.apple.Dock cotents-immutable -bool yes

# Dock - Lock the Dock size.
defaults write com.apple.Dock size-immutable -bool yes

# Dock - Set Dock size.
defaults write com.apple.dock tilesize -integer 34

# Dock - Show indicator lights for open apps in Dock.
defaults write com.apple.dock show-process-indicators -bool true

# Dock - Show instantly.
defaults write com.apple.dock autohide-delay -float 0

# Finder - Disable the “Are you sure you want to open this application?” dialog.
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Finder - Disable the warning before emptying the Trash.
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Finder - Disable the warning when changing a file extension.
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Finder - Disable Quick Look animation.
defaults write -g QLPanelAnimationDuration -float 0

# Finder - Disable Get Info animation.
defaults write com.apple.finder DisableAllAnimations -bool true

# Finder - Don't show Finder status bar.
defaults write com.apple.finder ShowStatusBar -bool false

# Finder - Don't show Finder path bar.
defaults write com.apple.finder ShowPathbar -bool false

# Finder - Expand save panel by default.
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Finder - Expand print panel by default.
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Finder - Keep folders on top when sorting by name.
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Finder - New window opens in home directory.
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

# Finder - Save to disk (not to iCloud) by default.
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Finder - Show the ~/Library folder.
chflags nohidden ~/Library

# Finder - Show the ~/Users folder.
chflags nohidden /Users

# Finder - Show /Volumes folder.
sudo chflags nohidden /Volumes

# Finder - Use column view in Finder by default.
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

# General - Disable automatic capitalization.
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# General - Disable automatic correction.
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# General - Diable automatic period substitution.
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# General - Disable disk image locked verification.
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true

# General - Disable disk image remote verification.
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

# General - Disable disk image verification.
defaults write com.apple.frameworks.diskimages skip-verify -bool true

# General - Disable smart dashes.
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# General - Disable smart quotes.
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# General - Disable the sound effects on boot.
sudo nvram SystemAudioVolume=" "

# General - Hide remaining battery time.
defaults write com.apple.menuextra.battery ShowTime -string "NO"

# General - Restart automatically on power loss.
sudo pmset -a autorestart 1

# General - Restart automatically if the computer freezes.
sudo systemsetup -setrestartfreeze on

# General - Set computer name.
sudo scutil --set ComputerName "Converge"
sudo scutil --set HostName "Converge"
sudo scutil --set LocalHostName "Converge"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "Converge"

# General - Set the timezone; see `systemsetup -listtimezones` for other values.
systemsetup -settimezone "Europe/Madrid" > /dev/null

# General - Show battery percentage.
defaults write com.apple.menuextra.battery ShowPercent -string "YES"

# Iterm2 - # Don’t display prompt when quitting iTerm2.
defaults write com.googlecode.iterm2 PromptOnQuit -bool false

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
