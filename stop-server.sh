 #!/bin/sh

unset SDKROOT

mkdir -p "${PROJECT_DIR}/.uiUnitTest/Logs"
exec > "${PROJECT_DIR}/.uiUnitTest/Logs/stop-logs.txt" 2>&1

UIUnitTestPath=$(dirname $0)

# Stop any process still running
swift run --package-path "$UIUnitTestPath" UIUnitTestCLI stop-command
