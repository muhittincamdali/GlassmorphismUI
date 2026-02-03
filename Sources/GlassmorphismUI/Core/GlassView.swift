import SwiftUI

/// A view that renders a glassmorphism effect with configurable blur,
/// opacity, border, and shadow properties.
///
/// Use `GlassView` to wrap content in a translucent glass panel:
///
/// ```swift
/// GlassView {
///     Text("Hello, Glass!")
///         .padding()
/// }
/// ```
public struct GlassView<Content: View>: View {
    // MARK: - Properties

    private let content: Content
    private let configuration: GlassConfiguration
    private let material: GlassMaterial

    @Environment(\.colorScheme) private var colorScheme

    // MARK: - Initialization

    /// Creates a glass view with the given configuration and material.
    ///
    /// - Parameters:
    ///   - configuration: The glass effect configuration. Defaults to `.default`.
    ///   - material: The glass material preset. Defaults to `.regular`.
    ///   - content: The content to display inside the glass panel.
    public init(
        configuration: GlassConfiguration = .default,
        material: GlassMaterial = .regular,
        @ViewBuilder content: () -> Content
    ) {
        self.configuration = configuration
        self.material = material
        self.content = content()
    }

    // MARK: - Body

    public var body: some View {
        content
            .background(
                glassBackground
            )
            .clipShape(RoundedRectangle(cornerRadius: effectiveCornerRadius, style: .continuous))
            .overlay(
                glassBorder
            )
            .shadow(
                color: shadowColor,
                radius: configuration.shadowRadius,
                x: 0,
                y: configuration.shadowRadius / 2
            )
    }

    // MARK: - Subviews

    /// The translucent background layer with blur effect.
    private var glassBackground: some View {
        RoundedRectangle(cornerRadius: effectiveCornerRadius, style: .continuous)
            .fill(backgroundColor)
            .background(
                RoundedRectangle(cornerRadius: effectiveCornerRadius, style: .continuous)
                    .fill(.ultraThinMaterial)
            )
    }

    /// The subtle border overlay that gives the glass its edge definition.
    private var glassBorder: some View {
        RoundedRectangle(cornerRadius: effectiveCornerRadius, style: .continuous)
            .stroke(
                LinearGradient(
                    colors: [
                        borderColor.opacity(configuration.borderOpacity),
                        borderColor.opacity(configuration.borderOpacity * 0.4)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                lineWidth: configuration.borderWidth
            )
    }

    // MARK: - Computed Properties

    /// The effective corner radius combining configuration and material values.
    private var effectiveCornerRadius: CGFloat {
        configuration.cornerRadius > 0
            ? configuration.cornerRadius
            : material.defaultCornerRadius
    }

    /// The background fill color adapted for the current color scheme.
    private var backgroundColor: Color {
        let baseOpacity = material.backgroundOpacity * configuration.backgroundOpacity
        return colorScheme == .dark
            ? Color.white.opacity(baseOpacity * 0.7)
            : Color.white.opacity(baseOpacity)
    }

    /// The border color adapted for the current color scheme.
    private var borderColor: Color {
        colorScheme == .dark
            ? .white.opacity(0.6)
            : .white.opacity(0.8)
    }

    /// The shadow color adapted for the current color scheme.
    private var shadowColor: Color {
        colorScheme == .dark
            ? Color.black.opacity(configuration.shadowOpacity * 1.5)
            : Color.black.opacity(configuration.shadowOpacity)
    }
}

// MARK: - Previews

#if DEBUG
#Preview("GlassView — Light") {
    ZStack {
        LinearGradient(colors: [.purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()

        GlassView {
            Text("Glassmorphism")
                .font(.title2.bold())
                .foregroundStyle(.white)
                .padding(32)
        }
    }
}

#Preview("GlassView — Dark") {
    ZStack {
        LinearGradient(colors: [.indigo, .black], startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()

        GlassView(material: .thick) {
            Text("Dark Glass")
                .font(.title2.bold())
                .foregroundStyle(.white)
                .padding(32)
        }
    }
    .preferredColorScheme(.dark)
}
#endif
