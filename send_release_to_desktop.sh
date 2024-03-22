#!/bin/bash

flutter clean && flutter build appbundle lib/main.dart
if [[ $? == 0 ]]; then
    echo "Copying APK...."
    cp -f $PWD/build/app/outputs/bundle/release/app-release.aab $HOME/Desktop/
    echo "APK copied."
    echo "Renaming APK...."
    mv $HOME/Desktop/app-release.aab $HOME/Desktop/CMS-$(date +%F-%H:%M)V1.aab
else
    echo "Flutter APK Build Failed"
fi
