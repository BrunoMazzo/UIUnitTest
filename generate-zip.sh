## Builds the app, then gets the App and the Test Runner and zips them
## Then gets the xctestrun to be used to install the apps on simulators

## TODO: Change minimum version to 15 or 14.
## TODO: Maybe convert to Swift inside the command line?

## Build the UI test
root=$PWD

xcodebuild -project ./Server/Server.xcodeproj \
  -scheme Server -sdk iphonesimulator \
  -destination "platform=iOS Simulator,name=iPhone 14,OS=16.2" \
  -IDEBuildLocationStyle=Custom \
  -IDECustomBuildLocationType=Absolute \
  -IDECustomBuildProductsPath="$PWD/build/Products" \
  build-for-testing || exit 1

(cd "$root"/build/Products/Debug-iphonesimulator/ && zip -r "$root"/Lib/Sources/UIUnitTestCLI/resources/Server.zip ServerUITests-Runner.app) || exit 1

