# UIUnitTest

Run XCTest UI commands from your unit test.

[![Coverage Status](https://coveralls.io/repos/github/BrunoMazzo/UIUnitTest/badge.svg?branch=main)](https://coveralls.io/github/BrunoMazzo/UIUnitTest?branch=main)

# In active development

The project is running in production on my company, but it's still in active development. I'm still working on the documentation and there are some features that I want to add before I can call it stable.

## Installation

1. Install the package:

```swift
.package(url: "git@github.com:BrunoMazzo/UIUnitTest.git", .branch("main"))
```

2. Add it to your Unit test target

3. Add a server start on your test scheme pre action:

   3.1 Select your test target on `Provide build settings from`
   
   3.2 Add the command: 
    ```shell
    
    $BUILD_DIR/../../SourcePackages/checkouts/UIUnitTest/start-server.sh
    ```

    ![Pre action panel](docs/pre-action.png)

    3.3 Add post action to stop the server:
    ```shell
    
    $BUILD_DIR/../../SourcePackages/checkouts/UIUnitTest/stop-server.sh
    ```

4. Start coding


## Usage

```swift

import UIUnitTest

...

@MainActor
func testExample() async throws {
    let app = try await App(appId: "your.app.bundle.id")

    let viewYouWantToTest = YourSwiftUIView(...)

    showView(viewYouWantToTest)
    
    try await app.button(identifier: "some button identifier").tap()

    ...
}
```






