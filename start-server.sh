#!/bin/sh

unset SDKROOT

exec > "${PROJECT_DIR}/.uiUnitTest/Logs/start-logs.txt" 2>&1

# Stop any process still running
swift run --package-path "$BUILD_DIR/../../SourcePackages/checkouts/UIUnitTest" UIUnitTestCLI stop-command
# Start server on devices that are alread running
swift run --package-path "$BUILD_DIR/../../SourcePackages/checkouts/UIUnitTest" UIUnitTestCLI start-server-command
# monitor for new devices (usually clone devices)
swift run --package-path "$BUILD_DIR/../../SourcePackages/checkouts/UIUnitTest" UIUnitTestCLI monitor-for-new-devices-command &
