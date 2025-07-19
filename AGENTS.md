# AGENTS.md - UIUnitTest Project Guide

## Build & Test Commands
- **Run all tests**: `make test` (uses iPhone 16, iOS 18.2 simulator)
- **Run parallel tests**: `make test-parallel` (2 workers, faster execution)
- **Run single test**: `xcodebuild -project Client/Client.xcodeproj -scheme Client -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.2' -only-testing:ClientTests/TapTests/testTap test`
- **Clean build**: `make clean-up` (removes build artifacts)
- **Reset simulators**: `make reset-simulators`

## Code Style Guidelines
- **Swift version**: 6.0 with strict concurrency
- **Imports**: Group by framework (Foundation, SwiftUI, XCTest, then project imports)
- **Naming**: camelCase for variables/functions, PascalCase for types
- **Async/await**: Prefer async/await over completion handlers, mark test classes `@MainActor`
- **Error handling**: Use `try await` for async operations, `XCTExpectFailure` for expected test failures
- **SwiftLint**: Configured with mandatory trailing commas, excludes short identifiers (x, y, id, up)
- **Test structure**: Both async (`try await`) and sync versions of tests, use `showView()` helper
- **Accessibility**: Use accessibility labels for UI elements, support accessibility audits

## Project Structure
- **Client/**: iOS test app with UI components
- **Server/**: Test server for UI automation
- **Lib/**: Core UIUnitTest library and CLI
- **Tests**: Located in `ClientTests/` with parallel execution support