.PHONY: test
test:	
	rm -rf test-result.xcresult 2> /dev/null
	$(MAKE) generate-zip
	set -o pipefail && xcodebuild -project Client/Client.xcodeproj \
		-scheme Client \
		test \
		-destination 'platform=iOS Simulator,name=iPhone 16,OS=18.0' \
		-resultBundlePath test-result.xcresult \
		-derivedDataPath 'derivedData' \
		-clonedSourcePackagesDirPath SourcePackages \
		-disableAutomaticPackageResolution | xcbeautify --report junit

.PHONY: test-parallel
test-parallel:
	rm -rf test-result.xcresult 2> /dev/null
	$(MAKE) generate-zip
	NSUnbufferedIO=YES xcodebuild -project Client/Client.xcodeproj \
								 -scheme "ClientTests - Parallel" \
								 test \
								 -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.0' \
								 -resultBundlePath test-result.xcresult \
								 -clonedSourcePackagesDirPath SourcePackages \
								 -disableAutomaticPackageResolution \
								 -parallel-testing-enabled YES \
								 -parallel-testing-worker-count 2 \
								 -derivedDataPath 'derivedData' \
								 2>&1 | xcbeautify --report junit

.PHONY: generate-zip
generate-zip:
	rm -rf SourcePackages 2> /dev/null
	./generate-zip.sh

