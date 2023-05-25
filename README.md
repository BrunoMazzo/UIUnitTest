# UIUnitTest

Run XCTest UI commands from your unit test.

[![Coverage Status](https://coveralls.io/repos/github/BrunoMazzo/UIUnitTest/badge.svg?branch=main)](https://coveralls.io/github/BrunoMazzo/UIUnitTest?branch=main)

# Still in development

I am still working in the [API parity](docs/API%20Coverage.md) and stability of the server, so crashes may happen. At the moment, it only works with one simulator, and it need to be open before the building of the unit test.

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
    /opt/homebrew/bin/mint run BrunoMazzo/UIUnitTest@main start-server-command --device-identifier $TARGET_DEVICE_IDENTIFIER
    ```

    ![Pre action panel](docs/pre-action.png)

    3.3 Add post action to stop the server:
    ```shell
    curl http://localhost:22087/stop
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






