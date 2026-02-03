import XCTest
import SwiftUI
@testable import GlassmorphismUI

final class GlassViewTests: XCTestCase {

    // MARK: - Configuration Tests

    func testDefaultConfiguration() {
        let config = GlassConfiguration.default
        XCTAssertEqual(config.blurRadius, 20)
        XCTAssertEqual(config.backgroundOpacity, 1.0)
        XCTAssertEqual(config.borderWidth, 0.8)
        XCTAssertEqual(config.borderOpacity, 0.25)
        XCTAssertEqual(config.cornerRadius, 16)
        XCTAssertEqual(config.shadowRadius, 8)
        XCTAssertEqual(config.shadowOpacity, 0.1)
    }

    func testSubtleConfiguration() {
        let config = GlassConfiguration.subtle
        XCTAssertEqual(config.blurRadius, 12)
        XCTAssertEqual(config.backgroundOpacity, 0.6)
        XCTAssertEqual(config.cornerRadius, 12)
    }

    func testProminentConfiguration() {
        let config = GlassConfiguration.prominent
        XCTAssertEqual(config.blurRadius, 30)
        XCTAssertEqual(config.cornerRadius, 20)
        XCTAssertGreaterThan(config.shadowRadius, config.shadowOpacity)
    }

    func testCustomConfiguration() {
        let config = GlassConfiguration(
            blurRadius: 50,
            backgroundOpacity: 0.5,
            borderWidth: 2.0,
            borderOpacity: 0.4,
            cornerRadius: 32,
            shadowRadius: 16,
            shadowOpacity: 0.2
        )
        XCTAssertEqual(config.blurRadius, 50)
        XCTAssertEqual(config.backgroundOpacity, 0.5)
        XCTAssertEqual(config.borderWidth, 2.0)
        XCTAssertEqual(config.cornerRadius, 32)
    }

    // MARK: - Material Tests

    func testMaterialPresets() {
        XCTAssertEqual(GlassMaterial.allPresets.count, 4)
        XCTAssertLessThan(GlassMaterial.thin.backgroundOpacity, GlassMaterial.regular.backgroundOpacity)
        XCTAssertLessThan(GlassMaterial.regular.backgroundOpacity, GlassMaterial.thick.backgroundOpacity)
        XCTAssertLessThan(GlassMaterial.thick.backgroundOpacity, GlassMaterial.ultra.backgroundOpacity)
    }

    func testMaterialBlurIntensityOrder() {
        XCTAssertLessThan(GlassMaterial.thin.blurIntensity, GlassMaterial.regular.blurIntensity)
        XCTAssertLessThan(GlassMaterial.regular.blurIntensity, GlassMaterial.thick.blurIntensity)
        XCTAssertLessThan(GlassMaterial.thick.blurIntensity, GlassMaterial.ultra.blurIntensity)
    }

    func testCustomMaterial() {
        let custom = GlassMaterial(
            name: "Custom",
            backgroundOpacity: 0.5,
            blurIntensity: 3.0,
            defaultCornerRadius: 30,
            borderProminence: 2.0
        )
        XCTAssertEqual(custom.name, "Custom")
        XCTAssertEqual(custom.backgroundOpacity, 0.5)
        XCTAssertEqual(custom.defaultCornerRadius, 30)
    }

    // MARK: - View Construction Tests

    func testGlassViewCreation() {
        let _ = GlassView {
            Text("Test")
        }
    }

    func testGlassViewWithMaterial() {
        let _ = GlassView(material: .ultra) {
            Text("Ultra Glass")
        }
    }

    func testGlassViewWithConfiguration() {
        let config = GlassConfiguration(blurRadius: 10, cornerRadius: 8)
        let _ = GlassView(configuration: config) {
            Text("Custom Config")
        }
    }
}
