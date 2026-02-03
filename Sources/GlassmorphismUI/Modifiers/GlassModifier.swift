import SwiftUI

/// A view modifier that applies a glassmorphism background to any view.
///
/// Prefer the `.glass()` shorthand on `View` rather than using this modifier directly.
public struct GlassModifier: ViewModifier {
    // MARK: - Properties

    private let configuration: GlassConfiguration
    private let material: GlassMaterial

    @Environment(\.colorScheme) private var colorScheme

    // MARK: - Initialization

    /// Creates a glass modifier.
    ///
    /// - Parameters:
    ///   - configuration: The glass configuration.
    ///   - material: The glass material preset.
    public init(
        configuration: GlassConfiguration = .default,
        material: GlassMaterial = .regular
    ) {
        self.configuration = configuration
        self.material = material
    }

    // MARK: - Body

    public func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
                            .fill(fillColor)
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
                    .stroke(borderGradient, lineWidth: configuration.borderWidth)
            )
            .shadow(
                color: .black.opacity(configuration.shadowOpacity),
                radius: configuration.shadowRadius,
                x: 0,
                y: configuration.shadowRadius / 2
            )
    }

    // MARK: - Private

    private var fillColor: Color {
        let opacity = material.backgroundOpacity * configuration.backgroundOpacity
        return colorScheme == .dark
            ? .white.opacity(opacity * 0.7)
            : .white.opacity(opacity)
    }

    private var borderGradient: LinearGradient {
        LinearGradient(
            colors: [
                .white.opacity(configuration.borderOpacity * material.borderProminence),
                .white.opacity(configuration.borderOpacity * material.borderProminence * 0.3)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// MARK: - View Extension

public extension View {
    /// Applies a glassmorphism effect to the view.
    ///
    /// - Parameters:
    ///   - configuration: Glass effect configuration. Defaults to `.default`.
    ///   - material: Glass material preset. Defaults to `.regular`.
    /// - Returns: A view with a glass background applied.
    func glass(
        configuration: GlassConfiguration = .default,
        material: GlassMaterial = .regular
    ) -> some View {
        modifier(GlassModifier(configuration: configuration, material: material))
    }
}
