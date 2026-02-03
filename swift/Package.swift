// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "GlassmorphismUI",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v15),
        .visionOS(.v1)
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
        )
    ],
    swiftLanguageVersions: [.v5]
)
