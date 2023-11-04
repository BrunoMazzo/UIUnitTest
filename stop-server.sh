unset SDKROOT

# Stop any process still running
swift run --package-path $BUILD_DIR/../../SourcePackages/checkouts/UIUnitTest UIUnitTestCLI stop-command
