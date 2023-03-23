// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UIUnitTestCLI",
    platforms: [
        .macOS(.v13), .iOS(.v16)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .executable(name: "UIUnitTestCLI", targets: ["UIUnitTestCLI"]),
        .library(
            name: "UIUnitTest",
            targets: ["UIUnitTest"]),
        .plugin(name: "UIUnitTestBuildPlugin", targets: ["UIUnitTestBuildPlugin"])
//        .library(name: "Test", targets: ["UIUnitTestBundle"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/trax-retail/xccov2lcov", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .executableTarget(
            name: "UIUnitTestCLI",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ],
            path: "Lib/Sources/UIUnitTestCLI",
            resources: [
                .copy("Resources/Server.zip"),
            ]
        ),
        .target(
            name: "UIUnitTest",
            dependencies: [],
            path: "Lib/Sources/UIUnitTest"
        ),
        .plugin(
            name: "UIUnitTestBuildPlugin",
            capability: .buildTool(),
            dependencies: [.target(name: "UIUnitTestCLI")],
            path: "Lib/Sources/UIUnitTestBuildPlugin"
        )
    ]
)
