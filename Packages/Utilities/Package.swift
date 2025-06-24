// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "Utilities",
    platforms: [
        .macOS(.v10_15),
    ],
    products: [
        .library(
            name: "Utilities",
            targets: ["Utilities"]
        ),
    ],
    targets: [
        .target(
            name: "Utilities",
            path: "Sources"
        ),
        .testTarget(
            name: "UtilitiesTests",
            dependencies: ["Utilities"],
            path: "Tests"
        ),
    ]
)
