
rm -rf build
rm -rf SourcePackages
rm -rf merged.xcresult
rm -rf cov.json
rm -rf lcov.info

# Clean server because Xcode its getting confused with the packages
xcodebuild -workspace UIUnitTest.xcworkspace -scheme Server clean

serverCommand="xcodebuild -workspace UIUnitTest.xcworkspace -scheme ServerUITests test -destination 'platform=iOS Simulator,name=iPhone 14,OS=16.2' -enableCodeCoverage YES -derivedDataPath build -resultBundlePath build/Server.xcresult -clonedSourcePackagesDirPath SourcePackages/server"
clientCommand="xcodebuild -workspace UIUnitTest.xcworkspace -scheme Client test -destination 'platform=iOS Simulator,name=iPhone 14,OS=16.2' -enableCodeCoverage YES -derivedDataPath build -resultBundlePath build/Client.xcresult -clonedSourcePackagesDirPath SourcePackages/client"


# eval "sleep 20 && $clientCommand"

eval $serverCommand  & eval "sleep 20 && $clientCommand" & wait

xcrun xcresulttool merge build/Client.xcresult build/Server.xcresult --output-path merged.xcresult

xcrun xccov view --report --json merged.xcresult > cov.json

swift run xccov2lcov cov.json > lcov.info

# xcrun xccov view merged.xcresult --report --only-targets