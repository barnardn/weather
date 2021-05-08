// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "weather",
    platforms: [
        .macOS(.v10_15),
    ],
    products: [
        .executable(name: "weather", targets: ["weather"]),
        .library(name: "WeatherServices", targets: ["WeatherServices"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", .upToNextMajor(from: "0.4.0")),
        .package(url: "https://github.com/apple/swift-tools-support-core", .upToNextMajor(from: "0.2.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "WeatherServices",
            dependencies: [
                .product(name: "SwiftToolsSupport-auto", package: "swift-tools-support-core"),
            ]
        ),
        .target(
            name: "weather",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "SwiftToolsSupport-auto", package: "swift-tools-support-core"),
                .target(name: "WeatherServices")
            ]),
        .testTarget(
            name: "weatherTests",
            dependencies: ["weather"],
            exclude: ["current-conditions.json"]
        ),
    ]
)
