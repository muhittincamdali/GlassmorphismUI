<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/LiquidGlassKit/main/.github/brand/banner-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/LiquidGlassKit/main/.github/brand/banner-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/LiquidGlassKit/main/.github/brand/banner-light.svg" alt="LiquidGlassKit: Liquid Glass surfaces and controls for SwiftUI."></picture></p>

<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a></p>

# GlassmorphismUI has moved

**This project now lives in [LiquidGlassKit](https://github.com/muhittincamdali/LiquidGlassKit).**
This repository is archived and will not change again. Its last release here is
[v1.0.0](https://github.com/muhittincamdali/GlassmorphismUI/releases/tag/v1.0.0).

## Where the code went

LiquidGlassKit 2.1.0 merged the useful parts of this repository, rewritten on top of its
`glassSurface` modifier and covered by tests:

| Here                                                            | In LiquidGlassKit                                                                                                                                                                                                                                               |
| --------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `GlassButton`, `GlassCard`, `GlassNavigationBar`, `GlassTabBar` | [Components](https://github.com/muhittincamdali/LiquidGlassKit/tree/main/Sources/LiquidGlassKit/Components); tab badges are in [`GlassTabBar`](https://github.com/muhittincamdali/LiquidGlassKit/blob/main/Sources/LiquidGlassKit/Components/GlassTabBar.swift) |
| Gradient glass modifier                                         | [`glassGradient`](https://github.com/muhittincamdali/LiquidGlassKit/blob/main/Sources/LiquidGlassKit/Surface/GlassGradient.swift)                                                                                                                               |
| Animated glass modifier                                         | [`glassHighlight`](https://github.com/muhittincamdali/LiquidGlassKit/blob/main/Sources/LiquidGlassKit/Surface/GlassHighlight.swift): shimmer, pulse and breathe, off when Reduce Motion is on                                                                   |
| Frosted and plain glass modifiers                               | [`glassSurface`](https://github.com/muhittincamdali/LiquidGlassKit/blob/main/Sources/LiquidGlassKit/Surface/GlassSurfaceModifier.swift): native glass on OS 26, a `Material` fallback down to iOS 17                                                            |

Not everything came along. The `Enterprise` helpers (`CircuitBreaker`, `RetryPolicy`, `EventBus`,
`ErrorHandler`, `MetricsCollector`) have nothing to do with glass and were not carried over. See the
[2.1.0 changelog](https://github.com/muhittincamdali/LiquidGlassKit/blob/main/CHANGELOG.md) for the
exact scope.

## Install the new package

```swift
.package(url: "https://github.com/muhittincamdali/LiquidGlassKit.git", from: "2.1.0")
```

Then add `.product(name: "LiquidGlassKit", package: "LiquidGlassKit")` to your target. It needs
iOS 17, macOS 14, tvOS 17, watchOS 10 or visionOS 1, and Swift 6.0. Full documentation:
[LiquidGlassKit README](https://github.com/muhittincamdali/LiquidGlassKit#readme).

## License

MIT, see [LICENSE](LICENSE).
