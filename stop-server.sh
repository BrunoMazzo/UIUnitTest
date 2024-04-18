 #!/bin/sh

unset SDKROOT

mkdir -p "${PROJECT_DIR}/.uiUnitTest/Logs"
exec > "${PROJECT_DIR}/.uiUnitTest/Logs/stop-logs.txt" 2>&1

# Stop any process still running
swift run --package-path "$BUILD_DIR/../../SourcePackages/checkouts/UIUnitTest" UIUnitTestCLI stop-command
