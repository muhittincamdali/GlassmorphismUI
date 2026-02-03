import SwiftUI

/// Configuration parameters for a glassmorphism effect.
///
/// Use `GlassConfiguration` to fine-tune every visual aspect of the glass:
///
/// ```swift
/// let config = GlassConfiguration(
///     blurRadius: 25,
///     backgroundOpacity: 0.15,
///     cornerRadius: 20
/// )
/// ```
public struct GlassConfiguration: Sendable, Equatable {
    // MARK: - Properties

    /// The blur radius applied to the background. Higher values produce a more diffused look.
    public var blurRadius: CGFloat

    /// The opacity multiplier for the glass background fill.
    public var backgroundOpacity: CGFloat

    /// The width of the border stroke in points.
    public var borderWidth: CGFloat

    /// The opacity of the border gradient.
    public var borderOpacity: CGFloat

    /// The corner radius of the glass shape.
    public var cornerRadius: CGFloat

    /// The shadow blur radius.
    public var shadowRadius: CGFloat

    /// The shadow opacity.
    public var shadowOpacity: CGFloat

    // MARK: - Initialization

    /// Creates a new glass configuration.
    ///
    /// - Parameters:
    ///   - blurRadius: Background blur radius. Default `20`.
    ///   - backgroundOpacity: Background fill opacity multiplier. Default `1.0`.
    ///   - borderWidth: Border stroke width. Default `0.8`.
    ///   - borderOpacity: Border gradient opacity. Default `0.25`.
    ///   - cornerRadius: Corner radius. Default `16`.
    ///   - shadowRadius: Shadow blur radius. Default `8`.
    ///   - shadowOpacity: Shadow opacity. Default `0.1`.
    public init(
        blurRadius: CGFloat = 20,
        backgroundOpacity: CGFloat = 1.0,
        borderWidth: CGFloat = 0.8,
        borderOpacity: CGFloat = 0.25,
        cornerRadius: CGFloat = 16,
        shadowRadius: CGFloat = 8,
        shadowOpacity: CGFloat = 0.1
    ) {
        self.blurRadius = blurRadius
        self.backgroundOpacity = backgroundOpacity
        self.borderWidth = borderWidth
        self.borderOpacity = borderOpacity
        self.cornerRadius = cornerRadius
        self.shadowRadius = shadowRadius
        self.shadowOpacity = shadowOpacity
    }

    // MARK: - Presets

    /// The default glass configuration with balanced values.
    public static let `default` = GlassConfiguration()

    /// A subtle configuration with minimal blur and opacity.
    public static let subtle = GlassConfiguration(
        blurRadius: 12,
        backgroundOpacity: 0.6,
        borderWidth: 0.5,
        borderOpacity: 0.15,
        cornerRadius: 12,
        shadowRadius: 4,
        shadowOpacity: 0.05
    )

    /// A prominent configuration with strong blur and thick borders.
    public static let prominent = GlassConfiguration(
        blurRadius: 30,
        backgroundOpacity: 1.4,
        borderWidth: 1.2,
        borderOpacity: 0.35,
        cornerRadius: 20,
        shadowRadius: 12,
        shadowOpacity: 0.15
    )
}
