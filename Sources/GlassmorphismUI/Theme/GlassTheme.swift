import SwiftUI

/// Defines the color values for a glassmorphism theme.
///
/// Use `GlassTheme` to override the automatic light/dark adaptation
/// with an explicit set of values.
public struct GlassTheme: Sendable, Equatable {
    /// Background tint opacity.
    public let backgroundOpacity: CGFloat

    /// Border highlight opacity.
    public let borderOpacity: CGFloat

    /// Shadow intensity.
    public let shadowOpacity: CGFloat

    /// Base tint color.
    public let tintColor: Color

    /// Creates a custom glass theme.
    public init(
        backgroundOpacity: CGFloat,
        borderOpacity: CGFloat,
        shadowOpacity: CGFloat,
        tintColor: Color = .white
    ) {
        self.backgroundOpacity = backgroundOpacity
        self.borderOpacity = borderOpacity
        self.shadowOpacity = shadowOpacity
        self.tintColor = tintColor
    }

    // MARK: - Presets

    /// A light theme optimized for bright backgrounds.
    public static let light = GlassTheme(
        backgroundOpacity: 0.10,
        borderOpacity: 0.30,
        shadowOpacity: 0.08,
        tintColor: .white
    )

    /// A dark theme optimized for dim backgrounds.
    public static let dark = GlassTheme(
        backgroundOpacity: 0.08,
        borderOpacity: 0.20,
        shadowOpacity: 0.15,
        tintColor: .white
    )
}

// MARK: - Environment Key

private struct GlassThemeKey: EnvironmentKey {
    static let defaultValue: GlassTheme? = nil
}

public extension EnvironmentValues {
    /// The current glass theme override, if any.
    var glassTheme: GlassTheme? {
        get { self[GlassThemeKey.self] }
        set { self[GlassThemeKey.self] = newValue }
    }
}

// MARK: - View Extension

public extension View {
    /// Sets an explicit glass theme for this view and its descendants.
    ///
    /// - Parameter theme: The glass theme to apply.
    /// - Returns: A view with the theme injected into the environment.
    func glassTheme(_ theme: GlassTheme) -> some View {
        environment(\.glassTheme, theme)
    }
}
