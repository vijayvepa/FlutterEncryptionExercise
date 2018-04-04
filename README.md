# 1. Encryption Demo

This project exercises the example app provided by the [flutter_string_encryption](https://pub.dartlang.org/packages/flutter_string_encryption#-example-tab-) package.

<!-- TOC -->

- [1. Encryption Demo](#1-encryption-demo)
	- [1.1. Getting Started](#11-getting-started)
	- [1.2. Demo](#12-demo)
	- [1.3. iOS Troubleshooting](#13-ios-troubleshooting)
		- [1.3.1. Flutter Run Error](#131-flutter-run-error)
		- [1.3.2. Target Version Error](#132-target-version-error)
		- [1.3.3. Swift Pods Error](#133-swift-pods-error)
		- [1.3.4. Swift Language Error](#134-swift-language-error)
		- [1.3.5. XCode Clean Error](#135-xcode-clean-error)
		- [1.3.6. Non Modular Header Error](#136-non-modular-header-error)
	- [1.4. Flutter Package Troubleshooting](#14-flutter-package-troubleshooting)

<!-- /TOC -->

## 1.1. Getting Started

For help getting started with Flutter, view our online
[documentation](https://flutter.io/).

## 1.2. Demo

This is how it looks (after some tweaks described below).

![Demo]

[Demo]:Screenshots/Demo.png

## 1.3. iOS Troubleshooting

### 1.3.1. Flutter Run Error

When running `flutter run` by default after `Pubspec.yaml` save, got [this error](ScreenLogs/1.FlutterRunError.log).



### 1.3.2. Target Version Error

To debug above error, 

```
cd ios
pod install
```

Got [this error](ScreenLogs/2.PodInstallError.log):

**ERROR**:
```
Specs satisfying the `flutter_string_encryption (from `Pods/.symlinks/plugins/flutter_string_encryption-0.0.1/ios`)` dependency were found, but they required a higher minimum deployment target.
```
**Reference**: https://github.com/sroddy/flutter_string_encryption

**FIX**

To fix this, we need to specify target framework at the top of the Podfile as below:

```
# Uncomment this line to define a global platform for your project
 platform :ios, '9.0'
```

![Platform]

[Platform]: Screenshots/PodfileFix.png

### 1.3.3. Swift Pods Error

When running `pod install` after above fix, got [this error](ScreenLogs/3.PodInstallError.log):

**ERROR**:
```
[!] Pods written in Swift can only be integrated as frameworks; add `use_frameworks!` to your Podfile or target to opt into using it. The Swift Pods being used are: SCrypto and flutter_string_encryption
```

**Reference**: https://stackoverflow.com/questions/29091522/error-running-pod-install-with-swift

**Fix**:

Add `use_frameworks` at the end of the `target 'Runner' do` section of the `ios/Podfile`:

```ruby
target 'Runner' do
 ...
 use_frameworks! 
  
end
```

![UseFrameworksFix]

[UseFrameworksFix]: Screenshots/PodFileFix-Part2.png

### 1.3.4. Swift Language Error

When running `pod install` after above fix, got [this error](ScreenLogs/4.FlutterRunError.log):

**Error**:
```
The “Swift Language Version” (SWIFT_VERSION) build setting must be set to a supported value for targets which use Swift. This setting can be set in the build settings editor.

```

**Reference**: https://stackoverflow.com/questions/46338588/xcode-9-swift-language-version-swift-version

**Fix**:

Add swift language version to Podfile as below (use Swift 4.0):

```ruby
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
      config.build_settings['SWIFT_VERSION'] = '4.0'
    end
  end
end
```

![SwiftLangFix]

[SwiftLangFix]: Screenshots/PodFileFix3.png


### 1.3.5. XCode Clean Error

When debugging above, got an error trying to run `Clean` command on Xcode.

**WORKAROUND**: Hold `OPTION` key when `Build` menu is open, and choose `Clean Build Folder`.


### 1.3.6. Non Modular Header Error

**Error**:
```
Include of non-modular header inside framework module 'flutter_string_encryption': '/Users/vijayvepakomma/.pub-cache/hosted/pub.dartlang.org/flutter_string_encryption-0.0.1/ios/Classes/FlutterStringEncryptionPlugin.h'
```

**Reference**: https://stackoverflow.com/questions/27776497/include-of-non-modular-header-inside-framework-module/31517439

**Fix**:

- Go to `Build Phases` tab of the `Project Settings` of the `Pod` project.
- Drag the `FlutterStringEncryptionPlugin.h` from `Project` files to `Public` files.

**TODO**:
This change needs to be incorporated into the `Podfile` some way.

![PublicHeaderFix]

[PublicHeaderFix]: Screenshots/PublicHeaderFix.png

## 1.4. Flutter Package Troubleshooting

Getting a [runtime error](ScreenLogs/6.RuntimeError.log) when running the example on iOS on the following flutter version.

```
MACC02RR83AG8WP:~ vijayvepakomma$ flutter --version
Flutter 0.2.7-pre.5 • channel master • https://github.com/flutter/flutter.git
Framework • revision 68db514ec0 (5 days ago) • 2018-03-30 19:48:51 -0700
Engine • revision c903c217a1
Tools • Dart 2.0.0-dev.43.0.flutter-52afcba357
```

**ERROR**:

```
Unhandled exception:
type 'Future<dynamic>' is not a subtype of type 'Future<String>' where
  Future is from dart:async
  Future is from dart:async
  String is from dart:core
```

Not sure if it is an actual issue with the package since I am using a pre-release version of Flutter.


**FIX**:

Modified the flutter code provided by the package in the packages folder as saved [here](DartPackageChanges/flutter_encryption.dart).

After these changes the app worked as below (shown again):

![Demo]

