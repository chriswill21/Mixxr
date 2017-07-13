# Mixxr

## Cocoa Pod installation
if you are getting build errors (missing .lock files)
run the following commands in your root:

> sudo gem install cocoapods

> pod install

make sure your podfile has all the following lines

>pod 'Firebase/Core', '~> 4.0.0'

>pod 'Firebase/Auth', '~> 4.0.0'

>pod 'Firebase/Core', '~> 4.0.0'

>pod 'SCLAlertView'

and then run

> pod update

> open ParseStarterProject-Swift.xcworkspace

and make sure that the GoogleService-Info.plist is in ur xcode project in the a ParseStarterProject
