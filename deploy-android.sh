#!/bin/sh

LOVE_ANDROID=../love-10.2-android-source

if [ -z "$1" -o "$1" != "debug" -a "$1" != "release" ]; then
  echo "'$1' is not valid. Either 'debug' or 'release' is required."
  exit -1
fi

# Write the debug/release configuration
echo "return '$1'" > build.lua
# Create the game zip. Must not contain the root folder
rm $LOVE_ANDROID/assets/game.love
zip -r $LOVE_ANDROID/assets/game.love build.lua version.lua game.lua main.lua resources conf.lua entities gamestates modules

if [ "$1" == "app" ]; then
  # Unlock the screen
  adb shell input keyevent 82
  adb shell input swipe 100 100 800 200

  adb shell am force-stop "org.love2d.android"

  # Upload the app on the sdcard
  adb push build/game.love /sdcard/game.love

  # Start the app Love passing the game file as parameter
  adb shell am start -S -n "org.love2d.android/.GameActivity" -d "file:///sdcard/game.love"
  # Show application log for the tag "SDL/APP" level "V" (verbose) and silence all other tag (*:S)
  adb logcat "SDL/APP":D *:S
  exit 0
fi

pushd ../love-10.2-android-source

# Build the native framework
# ndk-build clean
# ndk-build

# Build the APK and install/start the app
ant clean && ant $1 && \
adb uninstall org.love2d.android && \
adb install "bin/love-android-$1.apk" && \
adb shell am start -n "org.love2d.android/.GameActivity" && \
adb logcat "SDL/APP":D *:S
popd
