root = $(PWD)

.PHONY: test
test:	
	$(MAKE) clean-up
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
	$(MAKE) clean-up
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
	rm -rf $(root)/Server/DerivedData
	(cd $(root)/Server/ && zip -r $(root)/Lib/Sources/UIUnitTestCLI/resources/Server.zip *) || exit 1
	xcodebuild -project ./Server/Server.xcodeproj \
	  -scheme ServerUITests -sdk iphonesimulator \
	  -destination "platform=iOS Simulator,name=iPhone 16,OS=18.0" \
	  -IDEBuildLocationStyle=Custom \
	  -IDECustomBuildLocationType=Absolute \
	  -IDECustomBuildProductsPath="$(root)/build/Products" \
	  -derivedDataPath="$(root)/derivedData/" \
	  build-for-testing | xcbeautify || exit 1
	 (cd $(root)/build/Products/Release-iphonesimulator/ && zip -r $(root)/Lib/Sources/UIUnitTestCLI/resources/PreBuild.zip ServerUITests-Runner.app) || exit 1

.PHONY: clean-up
clean-up:
	rm -rf SourcePackages 2> /dev/null
	rm -rf build 2> /dev/null
	rm -rf derivedData 2> /dev/null
	rm -rf test-result.xcresult 2> /dev/null

