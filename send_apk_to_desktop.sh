#!/bin/bash

flutter clean && flutter build apk lib/main.dart
if [[ $? == 0 ]]; then
    echo "Copying APK...."
    cp -f $PWD/build/app/outputs/apk/release/app-release.apk $HOME/Desktop/
    echo "APK copied."
    echo "Renaming APK...."
    mv $HOME/Desktop/app-release.apk $HOME/Desktop/SAMS-$(date +%F-%H:%M)V1.apk
else
    echo "Flutter APK Build Failed"
fi
