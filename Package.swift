// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftRRule",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6),
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

