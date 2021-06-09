// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MineKit",
    products: [
        .library(
            name: "MineKit",
            targets: ["MineKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-nio", from: "2.0.0")
    ],
    targets: [
        .target(
            name: "MineKit",
            dependencies: [
                .product(name: "Logging", package: "swift-log"),
                .product(name: "NIO", package: "swift-nio")
            ]),
        .testTarget(
            name: "MineKitTests",
            dependencies: ["MineKit"]),
    ]
)
