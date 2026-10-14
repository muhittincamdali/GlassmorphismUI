<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/LiquidGlassKit/main/.github/brand/banner-tr-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/LiquidGlassKit/main/.github/brand/banner-tr-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/LiquidGlassKit/main/.github/brand/banner-tr-light.svg" alt="LiquidGlassKit: SwiftUI için Liquid Glass yüzeyleri ve kontrolleri."></picture></p>

<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a></p>

# GlassmorphismUI taşındı

**Bu proje artık [LiquidGlassKit](https://github.com/muhittincamdali/LiquidGlassKit) içinde yaşıyor.**
Bu depo arşivlendi ve bir daha değişmeyecek. Burada yayımlanan son sürüm
[v1.0.0](https://github.com/muhittincamdali/GlassmorphismUI/releases/tag/v1.0.0).

## Kod nereye gitti

LiquidGlassKit 2.1.0, bu depodaki işe yarar parçaları `glassSurface` üzerine yeniden yazarak ve
testlerle kapsayarak birleştirdi:

| Burada                                                          | LiquidGlassKit içinde                                                                                                                                                                                                                                                |
| --------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `GlassButton`, `GlassCard`, `GlassNavigationBar`, `GlassTabBar` | [Components](https://github.com/muhittincamdali/LiquidGlassKit/tree/main/Sources/LiquidGlassKit/Components); sekme rozetleri [`GlassTabBar`](https://github.com/muhittincamdali/LiquidGlassKit/blob/main/Sources/LiquidGlassKit/Components/GlassTabBar.swift) içinde |
| Gradyan cam modifier'ı                                          | [`glassGradient`](https://github.com/muhittincamdali/LiquidGlassKit/blob/main/Sources/LiquidGlassKit/Surface/GlassGradient.swift)                                                                                                                                    |
| Animasyonlu cam modifier'ı                                      | [`glassHighlight`](https://github.com/muhittincamdali/LiquidGlassKit/blob/main/Sources/LiquidGlassKit/Surface/GlassHighlight.swift): shimmer, pulse ve breathe; Reduce Motion açıkken çalışmaz                                                                       |
| Buzlu ve düz cam modifier'ları                                  | [`glassSurface`](https://github.com/muhittincamdali/LiquidGlassKit/blob/main/Sources/LiquidGlassKit/Surface/GlassSurfaceModifier.swift): OS 26'da yerel cam, iOS 17'ye kadar `Material` yedeği                                                                       |

Her şey taşınmadı. `Enterprise` yardımcılarının (`CircuitBreaker`, `RetryPolicy`, `EventBus`,
`ErrorHandler`, `MetricsCollector`) camla ilgisi yok ve pakete alınmadı. Kapsamın ayrıntısı için
[2.1.0 değişiklik günlüğüne](https://github.com/muhittincamdali/LiquidGlassKit/blob/main/CHANGELOG.md)
bakın.

## Yeni paketi kurun

```swift
.package(url: "https://github.com/muhittincamdali/LiquidGlassKit.git", from: "2.1.0")
```

Ardından hedefinize `.product(name: "LiquidGlassKit", package: "LiquidGlassKit")` ekleyin.
iOS 17, macOS 14, tvOS 17, watchOS 10 ya da visionOS 1 ve Swift 6.0 gerekir. Tam dokümantasyon:
[LiquidGlassKit README](https://github.com/muhittincamdali/LiquidGlassKit#readme).

## Lisans

MIT, bkz. [LICENSE](LICENSE).
