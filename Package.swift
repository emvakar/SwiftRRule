// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftRRule",
    platforms: [
        .iOS(.v15),
        .macOS(.v15),
        .tvOS(.v15),
        .watchOS(.v9),
    ],
    products: [
        .library(
            name: "SwiftRRule",
            targets: ["SwiftRRule"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SwiftRRule",
            dependencies: []),
        .testTarget(
            name: "SwiftRRuleTests",
            dependencies: ["SwiftRRule"]),
    ]
)

