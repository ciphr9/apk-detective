@ECHO OFF
ECHO ------------------------------------------------------------------------------------------------- & ECHO.INSTRUCTION: & ECHO.Make sure you are able to execute the "keytool" (comes with Java JDK) command. Also you will have to set the "sdkBuildToolsFolder" (Android SDK) in the .cfg file. After these conditions are met, add the .apk-File that you would like to debug into the same folder as this script and rename it to "original.apk". If you ran this script before, you might have to remove the result.apk as well. Then continue this script. & ECHO -------------------------------------------------------------------------------------------------
PAUSE
FOR /F "tokens=* USEBACKQ" %%F IN (`type sdkBuildToolsFolder.cfg`) DO (
SET sdkBuildToolsFolder=%%F
)
call scripts\apktool d -f original.apk 
ECHO ------------------------------------------------------------------------------------------------- & ECHO.INSTRUCTION: & ECHO.Go to ./original/AndroidManifest.xml and add android:debuggable="true" to the "application" tag & ECHO -------------------------------------------------------------------------------------------------
PAUSE
call scripts\apktool b original -o app.apk
call keytool -genkey -v -keystore release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias my-alias
call %sdkBuildToolsFolder%\zipalign -v -p 4 app.apk aligned.apk
del "app.apk" /s /f /q
call %sdkBuildToolsFolder%\apksigner sign --ks release-key.jks --out result.apk aligned.apk
del "aligned.apk" /s /f /q
del "release-key.jks" /s /f /q
ECHO ------------------------------------------------------------------------------------------------- & ECHO.INSTRUCTION: & ECHO.Now you will see a new .apk file called result.apk. This is the original.apk with the changes you have made in the AndroidManifest.xml. You can now install this on a device or emulator and debug the app. & ECHO -------------------------------------------------------------------------------------------------
PAUSE