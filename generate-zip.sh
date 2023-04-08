## Builds the app, then gets the App and the Test Runner and zips them
## Then gets the xctestrun to be used to install the apps on simulators

## TODO: Change minimum version to 15 or 14.
## TODO: Maybe convert to Swift inside the command line?

## Build the UI test
root=$PWD

(cd "$root"/Server/ && zip -r "$root"/Lib/Sources/UIUnitTestCLI/resources/Server.zip *) || exit 1

