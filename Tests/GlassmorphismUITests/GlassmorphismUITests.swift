// GlassmorphismUITests.swift
// GlassmorphismUI - Production-ready glassmorphism effects for SwiftUI
// Copyright (c) 2024-2025 Muhittin Camdali. MIT License.

import XCTest
import SwiftUI
@testable import GlassmorphismUI

final class GlassmorphismUITests: XCTestCase {
    
    // MARK: - GlassStyle Tests
    
    func testGlassStylePresets() {
        XCTAssertEqual(GlassStyle.subtle.blurIntensity, 0.3)
        XCTAssertEqual(GlassStyle.regular.blurIntensity, 0.5)
        XCTAssertEqual(GlassStyle.prominent.blurIntensity, 0.7)
        XCTAssertEqual(GlassStyle.frosted.blurIntensity, 1.0)
        XCTAssertEqual(GlassStyle.clear.blurIntensity, 0)
    }
    
    func testGlassStyleClamping() {
        let style = GlassStyle(blurIntensity: 2.0, tintOpacity: -0.5)
        XCTAssertEqual(style.blurIntensity, 1.0, "Blur intensity should be clamped to 1.0")
        XCTAssertEqual(style.tintOpacity, 0.0, "Tint opacity should be clamped to 0.0")
    }
    
    func testGlassStyleHashable() {
        let style1 = GlassStyle.regular
        let style2 = GlassStyle.regular
        XCTAssertEqual(style1, style2)
    }
    
    // MARK: - GlassMaterial Tests
    
    func testGlassMaterialBlurRadius() {
        XCTAssertEqual(GlassMaterial.ultraThin.blurRadius, 10)
        XCTAssertEqual(GlassMaterial.thin.blurRadius, 15)
        XCTAssertEqual(GlassMaterial.regular.blurRadius, 20)
        XCTAssertEqual(GlassMaterial.thick.blurRadius, 30)
        XCTAssertEqual(GlassMaterial.ultraThick.blurRadius, 40)
    }
    
    func testGlassMaterialAllCases() {
        XCTAssertEqual(GlassMaterial.allCases.count, 5)
    }
    
    // MARK: - GlassCornerStyle Tests
    
    func testGlassCornerStyleRadius() {
        XCTAssertEqual(GlassCornerStyle.square.radius, 0)
        XCTAssertEqual(GlassCornerStyle.rounded(10).radius, 10)
        XCTAssertEqual(GlassCornerStyle.capsule.radius, .infinity)
        XCTAssertEqual(GlassCornerStyle.continuous(12).radius, 12)
    }
    
    func testGlassCornerStyleContinuous() {
        XCTAssertFalse(GlassCornerStyle.square.isContinuous)
        XCTAssertFalse(GlassCornerStyle.rounded(10).isContinuous)
        XCTAssertFalse(GlassCornerStyle.capsule.isContinuous)
        XCTAssertTrue(GlassCornerStyle.continuous(12).isContinuous)
    }
    
    func testGlassCornerStylePresets() {
        XCTAssertEqual(GlassCornerStyle.small.radius, 8)
        XCTAssertEqual(GlassCornerStyle.medium.radius, 12)
        XCTAssertEqual(GlassCornerStyle.large.radius, 16)
        XCTAssertEqual(GlassCornerStyle.extraLarge.radius, 20)
        XCTAssertEqual(GlassCornerStyle.system.radius, 10)
    }
    
    // MARK: - GlassConfiguration Tests
    
    func testGlassConfigurationSingleton() {
        let config1 = GlassConfiguration.shared
        let config2 = GlassConfiguration.shared
        XCTAssertTrue(config1 === config2)
    }
    
    func testGlassConfigurationDefaults() {
        let config = GlassConfiguration.shared
        XCTAssertTrue(config.respectReduceTransparency)
        XCTAssertTrue(config.respectReduceMotion)
        XCTAssertTrue(config.enableHaptics)
        XCTAssertTrue(config.enableLiquidGlassCompat)
    }
    
    // MARK: - GlassTabItem Tests
    
    func testGlassTabItemCreation() {
        let item = GlassTabItem(id: "home", title: "Home", icon: "house")
        XCTAssertEqual(item.id, "home")
        XCTAssertEqual(item.title, "Home")
        XCTAssertEqual(item.icon, "house")
        XCTAssertEqual(item.selectedIcon, "house.fill")
    }
    
    func testGlassTabItemWithCustomSelectedIcon() {
        let item = GlassTabItem(id: "search", title: "Search", icon: "magnifyingglass", selectedIcon: "magnifyingglass.circle.fill")
        XCTAssertEqual(item.selectedIcon, "magnifyingglass.circle.fill")
    }
    
    func testGlassTabItemWithBadge() {
        let item = GlassTabItem(id: "notifications", title: "Notifications", icon: "bell", badge: "5")
        XCTAssertEqual(item.badge, "5")
    }
    
    // MARK: - GlassButtonStyle Tests
    
    func testGlassButtonStylePresets() {
        XCTAssertEqual(GlassButtonStyle.primary.variant, .primary)
        XCTAssertEqual(GlassButtonStyle.secondary.variant, .secondary)
        XCTAssertEqual(GlassButtonStyle.destructive.variant, .destructive)
    }
    
    func testGlassButtonStyleSizes() {
        XCTAssertEqual(GlassButtonStyle.small.size, .small)
        XCTAssertEqual(GlassButtonStyle.large.size, .large)
    }
    
    // MARK: - GlassAnimation Tests
    
    func testGlassAnimationDurations() {
        XCTAssertEqual(GlassAnimation.shimmer.duration, 2.5)
        XCTAssertEqual(GlassAnimation.pulse.duration, 1.5)
        XCTAssertEqual(GlassAnimation.breathe.duration, 3.0)
        XCTAssertEqual(GlassAnimation.rainbow.duration, 4.0)
        XCTAssertEqual(GlassAnimation.none.duration, 0)
    }
    
    // MARK: - GradientDirection Tests
    
    func testGradientDirectionPoints() {
        XCTAssertEqual(GradientDirection.vertical.startPoint, .top)
        XCTAssertEqual(GradientDirection.vertical.endPoint, .bottom)
        XCTAssertEqual(GradientDirection.horizontal.startPoint, .leading)
        XCTAssertEqual(GradientDirection.horizontal.endPoint, .trailing)
    }
    
    // MARK: - LiquidGlassCompat Tests
    
    func testLiquidGlassCompatMode() {
        // On current iOS versions, native should not be available
        if #available(iOS 26, *) {
            XCTAssertTrue(LiquidGlassCompat.isNativeAvailable)
        } else {
            XCTAssertFalse(LiquidGlassCompat.isNativeAvailable)
        }
    }
    
    // MARK: - Version Tests
    
    func testLibraryVersion() {
        XCTAssertEqual(GlassmorphismUI.version, "2.0.0")
    }
    
    func testSupportsAdvancedEffects() {
        // Should return true on supported platforms
        XCTAssertTrue(GlassmorphismUI.supportsAdvancedEffects)
    }
    
    // MARK: - GlassCardStyle Tests
    
    func testGlassCardStylePresets() {
        XCTAssertNotNil(GlassCardStyle.standard.glassStyle)
        XCTAssertNotNil(GlassCardStyle.elevated.glassStyle)
        XCTAssertNotNil(GlassCardStyle.flat.glassStyle)
        XCTAssertNotNil(GlassCardStyle.inset.glassStyle)
    }
    
    // MARK: - Performance Tests
    
    func testGlassStyleCreationPerformance() {
        measure {
            for _ in 0..<1000 {
                _ = GlassStyle(
                    blurIntensity: 0.5,
                    tintColor: .white,
                    tintOpacity: 0.1
                )
            }
        }
    }
}

// MARK: - View Snapshot Tests (Conceptual)

#if DEBUG
extension GlassmorphismUITests {
    
    /// Note: These tests demonstrate the API usage.
    /// For actual visual testing, use snapshot testing frameworks.
    
    func testGlassModifierCompiles() {
        let view = Text("Test")
            .padding()
            .glass()
        XCTAssertNotNil(view)
    }
    
    func testFrostedGlassModifierCompiles() {
        let view = Text("Test")
            .padding()
            .frostedGlass()
        XCTAssertNotNil(view)
    }
    
    func testGradientGlassModifierCompiles() {
        let view = Text("Test")
            .padding()
            .gradientGlass(colors: [.pink, .purple])
        XCTAssertNotNil(view)
    }
    
    func testAnimatedGlassModifierCompiles() {
        let view = Text("Test")
            .padding()
            .animatedGlass(.shimmer)
        XCTAssertNotNil(view)
    }
    
    func testLiquidGlassModifierCompiles() {
        let view = Text("Test")
            .padding()
            .liquidGlass()
        XCTAssertNotNil(view)
    }
    
    func testGlassCardCompiles() {
        let view = GlassCard {
            Text("Content")
        }
        XCTAssertNotNil(view)
    }
    
    func testGlassButtonCompiles() {
        let view = GlassButton("Test") { }
        XCTAssertNotNil(view)
    }
}
#endif
