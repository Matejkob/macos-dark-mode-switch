// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "AppearanceSwitcher",
    platforms: [
        .macOS(.v10_15),
    ],
    products: [
        .library(
            name: "AppearanceSwitcher",
            targets: ["AppearanceSwitcher"]
        )
    ],
    dependencies: [
        .package(path: "../Utilities"),
    ],
    targets: [
        .target(
            name: "AppearanceSwitcher",
            dependencies: ["Utilities"],
            path: "Sources"
        ),
        .testTarget(
            name: "AppearanceSwitcherTests",
            dependencies: ["AppearanceSwitcher"],
            path: "Tests"
        ),
    ]
)
