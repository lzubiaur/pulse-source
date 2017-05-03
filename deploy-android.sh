# Create the game zip. Must not contain the root folder
zip -r build/game.love game.lua	main.lua resources conf.lua entities gamestates modules

# Upload the app on the sdcard
adb push build/game.love /sdcard/game.love

# Start the app Love passing the game file as parameter
adb shell am start -S -n "org.love2d.android/.GameActivity" -d "file:///sdcard/game.love"

# Show application log for the tag "SDL/APP" level "V" (verbose) and silence all other tag (*:S)
adb logcat "SDL/APP":D *:S
