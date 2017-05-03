zip -r build/game.love game.lua	main.lua resources conf.lua entities gamestates modules

adb push build/game.love /sdcard/game.love
adb shell am start -S -n "org.love2d.android/.GameActivity" -d "file:///sdcard/game.love"
# adb logcat

