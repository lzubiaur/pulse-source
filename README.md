## Android
Version of Love2D android is 0.10.2

### Internal storage bug
Edit Filesystem.cpp (jni/love/src/modules/filesystem/physfs/Filesystem.cpp) because
of a bug when writing on the internal storage. See https://bitbucket.org/MartinFelis/love-android-sdl2/issues/132/could-not-set-write-directory-on-android-6#

### Update application id (package)
* change the package tag in AndroidManifest.xml
* change the java activity path (src/org/love/android) to reflect the new package
* change the package name in the Java sources (DownloadActivity.java, DownloadService.java, GameActivity.java)
* change JNI class name in jni/love/src/common/android.cpp

## Gameplay ideas
* slow motion. when the player touch a special item the gameplay is slower so it become easier.

## TODO
* Better graphics
* Provide "more games",twitter,facebook url for desktop platforms too
* add effect to coin (see trail.lua)
* GUI (pause,quit...)
* disable/enable volume
* Fade color while the player progress in the level
* checkout module multisouce
* checkout hump.camera instead of gamera
* investigate music sync (wave.lua/lovebpm.lua)
* animated message when touch checkpoint (e.g. "saved"). The message move up and fade out when touching the checkpoint.

