// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "GlassmorphismUI",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "GlassmorphismUI",
            targets: ["GlassmorphismUI"]
        )
    ],
    targets: [
        .target(
            name: "GlassmorphismUI",
            path: "Sources/GlassmorphismUI"
        ),
        .testTarget(
            name: "GlassmorphismUITests",
            dependencies: ["GlassmorphismUI"],
            path: "Tests/GlassmorphismUITests"
        )
    ]
)
