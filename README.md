# UIUnitTest

## Overview

UIUnitTest is a powerful testing framework that bridges the gap between unit testing and UI testing in Swift applications. It allows you to run UI commands directly from your unit tests, providing a more integrated and flexible testing approach.

## Key Features

- 🚀 Run UI commands within unit tests
- 🔍 Full access to app state during testing
- 🛠 Support for both SwiftUI and UIKit
- 🔬 Simplified testing workflow

## How It Works

Traditional UI testing in Apple's ecosystem involves two separate processes:
- UI Test Process: Runs test code
- App Process: Runs the full application

This separation limits your ability to modify app state during testing. UIUnitTest solves this by:
- Running unit tests instead of the app
- Using a server to receive and execute commands from your test code

## Prerequisites

- Xcode 14.0+
- Swift 5.7+
- macOS 13.0+
- iOS/iPadOS 16.0+

## Installation

### Swift Package Manager

1. In Xcode, go to `File` > `Add Packages...`
2. Enter the package URL:
   ```
   https://github.com/BrunoMazzo/UIUnitTest.git
   ```
3. Select the version (recommended: latest stable)
4. Add to your unit test target

### Manual Configuration

1. Add the package to your `Package.swift`:
   ```swift
   .package(url: "https://github.com/BrunoMazzo/UIUnitTest.git", from: "0.4.0")
   ```

## Setup

### Test Scheme Configuration

1. Open your Xcode scheme settings
2. Select your test target
3. Add pre-action script:
   ```shell
   $BUILD_DIR/../../SourcePackages/checkouts/UIUnitTest/start-server.sh
   ```
4. Add post-action script:
   ```shell
   $BUILD_DIR/../../SourcePackages/checkouts/UIUnitTest/stop-server.sh
   ```

## Usage Examples

### SwiftUI Testing

```swift
import UIUnitTest

class MyViewTests: XCTestCase {
    @MainActor
    func testButtonInteraction() {
        let app = App()
        
        // Show a specific view
        let loginView = LoginView()
        showView(loginView)
        
        // Interact with UI elements
        app.button(identifier: "loginButton").tap()
        app.textField(identifier: "usernameField").enterText("testuser")
        
        // Make assertions
        XCTAssertTrue(app.label(identifier: "welcomeLabel").exists)
    }
}
```

### UIKit Testing

```swift
import UIUnitTest

class MyViewControllerTests: XCTestCase {
    @MainActor
    func testViewControllerFlow() {
        let app = App()
        
        // Show a UIViewController
        let profileVC = ProfileViewController()
        showViewController(profileVC)
        
        // Interact with UI elements
        app.button(identifier: "editProfileButton").tap()
        app.textField(identifier: "nameField").enterText("John Doe")
    }
}
```

## Troubleshooting

### Common Issues

- **Server Not Starting**: Ensure scripts have execute permissions
- **Command Not Found**: Verify Xcode build settings
- **Test Failures**: Check server logs in Xcode's report navigator

### Debugging

1. Enable verbose logging in your test configuration
2. Check UIUnitTest server logs
3. Verify package installation

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Write tests for new functionality
5. Ensure all tests pass
6. Submit a pull request

## License

This project is licensed under the MIT License.

## Support

- Open an issue on GitHub for bug reports
- Discussions are welcome in the GitHub Discussions section

## Performance Tips

- Keep tests focused and concise
- Use `@MainActor` for UI-related tests
- Minimize complex state mutations during tests
