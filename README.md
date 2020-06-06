### Motivation
- practice flutter
- A Follow along of [this playlist by The CS Guy YT channel](https://www.youtube.com/playlist?list=PLTHrJfrjCyJDlOLSIT3bm2xCCuPanUNX4)



### creating keystore:
- **step1 :** create folder called keystore(or any name) in root folder.
- **step2 :**
	- normal keystore:
	```
	keytool -genkey -v -keystore my-key.keystore -alias alias_name -keyalg RSA -keysize 2048 -validity 10000
	```
	and answer the questions in command line.
	- debug keystore for firebase(as in second video in the playlist)
	```
	keytool -genkey -v -keystore debug.keystore -storepass android -alias androiddebugkey -keypass android -keyalg RSA -keysize 2048 -validity 10000
	```
	- after running above, it would show
		``` Warning:
				The JKS keystore uses a proprietary format. It is recommended to migrate to PKCS12 which is an industry standard format using "keytool -importkeystore -srckeystore keystore/debug.keystore -destkeystore keystore/debug.keystore -deststoretype pkcs12".
		```
	- so run the given command and give password when asked : _android_
- **step3 :** To get SHA1 fingerprints etc, run the following command
	- generic command : `keytool -list -v -keystore [keystore path] -alias [alias-name] -storepass [storepass] -keypass [keypass]`

	- For the debug keystore : ` keytool -list -v -keystore debug.keystore -alias androiddebugkey -storepass android -keypass android `


## Troubleshooting:
	- Error : ```
		PlatformException(sign_in_failed, com.google.android.gms.common.api.ApiException: 10: , null)
		```
		solution : https://stackoverflow.com/a/60804020/7314900