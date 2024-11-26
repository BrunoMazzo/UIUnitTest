#!/bin/sh

unset SDKROOT

mkdir -p "${PROJECT_DIR}/.uiUnitTest/Logs"
exec > "${PROJECT_DIR}/.uiUnitTest/Logs/start-logs.txt" 2>&1

UIUnitTestPath=$(dirname $0)

# Stop any process still running
swift run --package-path "$UIUnitTestPath" --cache-path "${PROJECT_DIR}/.uiUnitTest/spm/" UIUnitTestCLI stop-command
# Start server on devices that are alread running
swift run --package-path "$UIUnitTestPath" --cache-path "${PROJECT_DIR}/.uiUnitTest/spm/" UIUnitTestCLI start-server-command
# monitor for new devices (usually clone devices)
swift run --package-path "$UIUnitTestPath" --cache-path "${PROJECT_DIR}/.uiUnitTest/spm/" UIUnitTestCLI monitor-for-new-devices-command &
