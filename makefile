.PHONY: test
test:	
	rm -r test-result.xcresult 
	set -o pipefail && xcodebuild -project Client/Client.xcodeproj -scheme Client test -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.0' -resultBundlePath test-result.xcresult -clonedSourcePackagesDirPath SourcePackages -disableAutomaticPackageResolution | xcbeautify --report junit

.PHONY: test-parallel
test-parallel:
	rm -r test-result.xcresult 
	NSUnbufferedIO=YES xcodebuild -project Client/Client.xcodeproj -scheme "ClientTests - Parallel" test -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.0' -resultBundlePath test-result.xcresult -clonedSourcePackagesDirPath SourcePackages -disableAutomaticPackageResolution -parallel-testing-enabled YES -parallel-testing-worker-count 2 2>&1 | xcbeautify --report junit

.PHONY: generate-zip
generate-zip:
	./generate-zip.sh
