import SwiftUI

public extension Color {
    // MARK: - Glass Palette

    /// A soft white suitable for glass tint overlays.
    static let glassTint = Color.white.opacity(0.12)

    /// A subtle border color for glass edges.
    static let glassBorder = Color.white.opacity(0.25)

    /// A faint shadow color for glass depth.
    static let glassShadow = Color.black.opacity(0.10)

    /// A highlight color used in glass shimmer effects.
    static let glassHighlight = Color.white.opacity(0.45)

    // MARK: - Helpers

    /// Returns the color with its opacity scaled by the given factor.
    ///
    /// - Parameter factor: A multiplier applied to the current opacity.
    /// - Returns: The color with adjusted opacity.
    func scaled(opacity factor: CGFloat) -> Color {
        self.opacity(factor)
    }

    /// Blends this color with white at the specified fraction.
    ///
    /// - Parameter fraction: How much white to mix in (0 = none, 1 = fully white).
    /// - Returns: A new color blended toward white.
    func lighten(by fraction: CGFloat) -> Color {
        let clamped = min(max(fraction, 0), 1)
        return Color(
            red: 1.0 * clamped,
            green: 1.0 * clamped,
            blue: 1.0 * clamped
        ).opacity(Double(clamped))
    }

    /// Blends this color with black at the specified fraction.
    ///
    /// - Parameter fraction: How much black to mix in (0 = none, 1 = fully black).
    /// - Returns: A new color blended toward black.
    func darken(by fraction: CGFloat) -> Color {
        self.opacity(Double(1 - min(max(fraction, 0), 1)))
    }
}
