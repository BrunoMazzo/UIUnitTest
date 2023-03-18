serverCommand="xcodebuild -project Server/Server.xcodeproj -scheme ServerUITests test -destination 'platform=iOS Simulator,name=iPhone 14,OS=16.2' -enableCodeCoverage YES -derivedDataPath build -resultBundlePath build/Server.xcresult -clonedSourcePackagesDirPath SourcePackages"
clientCommand="xcodebuild -project Client/Client.xcodeproj -scheme Client test -destination 'platform=iOS Simulator,name=iPhone 14,OS=16.2' -enableCodeCoverage YES -derivedDataPath build -resultBundlePath build/Client.xcresult"

rm -rf build
rm -rf SourcePackages
rm -rf merged.xcresult
rm -rf cov.json
rm -rf lcov.info

eval $serverCommand  & eval "sleep 10 && $clientCommand" & wait

xcrun xcresulttool merge build/Client.xcresult build/Server.xcresult --output-path merged.xcresult

xcrun xccov view --report --json merged.xcresult > cov.json

swift run xccov2lcov cov.json > coverage/lcov.info

# xcrun xccov view merged.xcresult --report --only-targets