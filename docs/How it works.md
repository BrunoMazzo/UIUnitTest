# How it works

## Introduction

First of all, we need to understand how UI tests works on iOS projects.

## UI Tests

Every time we run an UI test, Xcode will install the app and the test bundle app. This test bundle app is a separated app that contains the test code and have access to the UI APIs from XCTest framework. But because it is another app, we don't have access to the code from the main app.

### Appium and other frameworks

Many UI tests frameworks like Appium uses an approach similar which the one we use. They install the test bundle app but they run an server inside it to receive commands from other process and interact with the main app. This test bundle with server is called [XCUITest driver](https://github.com/appium/appium-xcuitest-driver) on appium.

## How we do it

Our library is composed by three parts:
- Library
- Server
- CLI

The library is the part of the project that you will use directly. It is responsible to send commands to the server.

The server is the part of the project that will run on the test bundle app. It is responsible to receive commands from the library and interact with XCTest UI APIs. You should not need to interact with the server directly.

The CLI is responsible to install and start the server when you run the tests. It is the part that you add on the tests pre-action phase of Xcode scheme.

When you run your tests, Xcode should run the CLI during the pre-actions phase. The CLI will check for the server app and install it if needed. Then it will start the server. After that, the tests will run and the library will send commands to the server. The server will interact with the XCTest UI APIs and return the results to the library.


