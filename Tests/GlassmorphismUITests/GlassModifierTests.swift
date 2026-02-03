import XCTest
import SwiftUI
@testable import GlassmorphismUI

final class GlassModifierTests: XCTestCase {

    // MARK: - Modifier Application Tests

    func testGlassModifierCreation() {
        let modifier = GlassModifier()
        XCTAssertNotNil(modifier)
    }

    func testGlassModifierWithConfiguration() {
        let config = GlassConfiguration(blurRadius: 30, cornerRadius: 24)
        let modifier = GlassModifier(configuration: config, material: .thick)
        XCTAssertNotNil(modifier)
    }

    func testGlassViewExtension() {
        let view = Text("Hello")
            .glass()
        XCTAssertNotNil(view)
    }

    func testGlassViewExtensionWithMaterial() {
        let view = Text("Hello")
            .glass(material: .ultra)
        XCTAssertNotNil(view)
    }

    // MARK: - Theme Tests

    func testLightTheme() {
        let theme = GlassTheme.light
        XCTAssertEqual(theme.backgroundOpacity, 0.10)
        XCTAssertEqual(theme.borderOpacity, 0.30)
        XCTAssertEqual(theme.shadowOpacity, 0.08)
    }

    func testDarkTheme() {
        let theme = GlassTheme.dark
        XCTAssertEqual(theme.backgroundOpacity, 0.08)
        XCTAssertEqual(theme.borderOpacity, 0.20)
        XCTAssertEqual(theme.shadowOpacity, 0.15)
    }

    // MARK: - Tab Item Tests

    func testGlassTabItem() {
        let item = GlassTabItem(icon: "house", title: "Home")
        XCTAssertEqual(item.icon, "house")
        XCTAssertEqual(item.title, "Home")
        XCTAssertFalse(item.id.isEmpty)
    }

    // MARK: - Color Extension Tests

    func testGlassColors() {
        XCTAssertNotNil(Color.glassTint)
        XCTAssertNotNil(Color.glassBorder)
        XCTAssertNotNil(Color.glassShadow)
        XCTAssertNotNil(Color.glassHighlight)
    }

    // MARK: - Component Creation Tests

    func testGlassCardCreation() {
        let _ = GlassCard {
            Text("Card Content")
        }
    }

    func testGlassButtonCreation() {
        let _ = GlassButton("Tap Me", icon: "star") {}
    }
}
