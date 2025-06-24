// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "LaunchAgent",
    dependencies: [
        .package(path: "../Utilities"),
    ],
    targets: [
        .executableTarget(
            name: "LaunchAgent",
            dependencies: [
                "Utilities",
            ]
        ),
    ]
)
