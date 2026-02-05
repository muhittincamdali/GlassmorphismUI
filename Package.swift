// swift-tools-version: 5.9
// GlassmorphismUI - Production-ready glassmorphism effects for SwiftUI
// Copyright (c) 2024-2025 Muhittin Camdali. MIT License.

import PackageDescription

let package = Package(
    name: "GlassmorphismUI",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v15),
        .watchOS(.v8),
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
            path: "Sources/GlassmorphismUI",
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]
        ),
        .testTarget(
            name: "GlassmorphismUITests",
            dependencies: ["GlassmorphismUI"],
            path: "Tests/GlassmorphismUITests"
        )
    ],
    swiftLanguageVersions: [.v5]
)
