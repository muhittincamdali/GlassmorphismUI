import SwiftUI

/// Predefined glass material presets that control the density and visual weight
/// of the glassmorphism effect.
///
/// Materials range from `.thin` (barely visible) to `.ultra` (maximum frosted look):
///
/// ```swift
/// GlassView(material: .thick) {
///     Text("Thick glass")
/// }
/// ```
public struct GlassMaterial: Sendable, Equatable, Hashable {
    // MARK: - Properties

    /// A human-readable name for the material.
    public let name: String

    /// The background opacity value for this material.
    public let backgroundOpacity: CGFloat

    /// The blur intensity multiplier.
    public let blurIntensity: CGFloat

    /// The default corner radius suggested by this material.
    public let defaultCornerRadius: CGFloat

    /// The border prominence multiplier.
    public let borderProminence: CGFloat

    // MARK: - Initialization

    /// Creates a custom glass material.
    ///
    /// - Parameters:
    ///   - name: Display name for the material.
    ///   - backgroundOpacity: Background fill opacity.
    ///   - blurIntensity: Blur strength multiplier.
    ///   - defaultCornerRadius: Suggested corner radius.
    ///   - borderProminence: Border visibility multiplier.
    public init(
        name: String,
        backgroundOpacity: CGFloat,
        blurIntensity: CGFloat,
        defaultCornerRadius: CGFloat = 16,
        borderProminence: CGFloat = 1.0
    ) {
        self.name = name
        self.backgroundOpacity = backgroundOpacity
        self.blurIntensity = blurIntensity
        self.defaultCornerRadius = defaultCornerRadius
        self.borderProminence = borderProminence
    }

    // MARK: - Presets

    /// A thin, barely-there glass effect. Ideal for overlays that should stay subtle.
    public static let thin = GlassMaterial(
        name: "Thin",
        backgroundOpacity: 0.06,
        blurIntensity: 0.5,
        defaultCornerRadius: 12,
        borderProminence: 0.6
    )

    /// A balanced, everyday glass effect. Good default for most use cases.
    public static let regular = GlassMaterial(
        name: "Regular",
        backgroundOpacity: 0.12,
        blurIntensity: 1.0,
        defaultCornerRadius: 16,
        borderProminence: 1.0
    )

    /// A thick, prominent glass effect with visible frosting.
    public static let thick = GlassMaterial(
        name: "Thick",
        backgroundOpacity: 0.20,
        blurIntensity: 1.5,
        defaultCornerRadius: 20,
        borderProminence: 1.3
    )

    /// Maximum-strength glass with heavy blur and high opacity.
    public static let ultra = GlassMaterial(
        name: "Ultra",
        backgroundOpacity: 0.30,
        blurIntensity: 2.0,
        defaultCornerRadius: 24,
        borderProminence: 1.6
    )

    /// An array of all built-in material presets.
    public static let allPresets: [GlassMaterial] = [
        .thin, .regular, .thick, .ultra
    ]
}
