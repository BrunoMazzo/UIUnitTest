## Builds the app, then gets the App and the Test Runner and zips them
## Then gets the xctestrun to be used to install the apps on simulators

## TODO: Change minimum version to 15 or 14.
## TODO: Maybe convert to Swift inside the command line?

## Build the UI test
root=$PWD

## Remove derived data to avoid adding it to the zip file
rm -rf "$root"/Server/DerivedData

(cd "$root"/Server/ && zip -r "$root"/Lib/Sources/UIUnitTestCLI/resources/Server.zip *) || exit 1

xcodebuild -project ./Server/Server.xcodeproj \
  -scheme ServerUITests -sdk iphonesimulator \
  -destination "platform=iOS Simulator,name=iPhone 16,OS=18.0" \
  -IDEBuildLocationStyle=Custom \
  -IDECustomBuildLocationType=Absolute \
  -IDECustomBuildProductsPath="$PWD/build/Products" \
  -derivedDataPath="$PWD/derivedData/" \
  build-for-testing | xcbeautify || exit 1

## (cd "$root"/build/Products/Debug-iphonesimulator/ && zip -r "$root"/Lib/Sources/UIUnitTestCLI/resources/PreBuild.zip ServerUITests-Runner.app) || exit 1

(cd "$root"/build/Products/Release-iphonesimulator/ && zip -r "$root"/Lib/Sources/UIUnitTestCLI/resources/PreBuild.zip ServerUITests-Runner.app) || exit 1
