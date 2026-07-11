#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q go-configure-sw-hub | awk '{print $2; exit}') # example command to get version of application here
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/icons/hicolor/512x512/apps/icon-launcher-dev.png
export DESKTOP=/usr/share/applications/GreenPAK_designer_launcher.desktop

# Deploy dependencies

quick-sharun \
    /opt/go-configure-sw-hub \
    /usr/bin/GPLauncher

# Additional changes can be done in between here
#mkdir -p ./AppDir/usr/local/go-configure-sw-hub
#cp -vr /usr/local/go-configure-sw-hub/* ./AppDir/usr/local/go-configure-sw-hub

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --test ./dist/*.AppImage
