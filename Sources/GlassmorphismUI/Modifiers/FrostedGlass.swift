import SwiftUI

/// A view modifier that applies a frosted / matte glass effect.
///
/// The frosted effect uses a heavier tint layer on top of the blur
/// to simulate a sandblasted or etched glass surface.
public struct FrostedGlassModifier: ViewModifier {
    // MARK: - Properties

    /// The tint color applied over the blur layer.
    private let tintColor: Color

    /// The opacity of the frosted tint overlay.
    private let opacity: CGFloat

    /// The corner radius of the frosted shape.
    private let cornerRadius: CGFloat

    @Environment(\.colorScheme) private var colorScheme

    // MARK: - Initialization

    /// Creates a frosted glass modifier.
    ///
    /// - Parameters:
    ///   - tintColor: The tint color. Defaults to `.white`.
    ///   - opacity: The tint opacity. Defaults to `0.18`.
    ///   - cornerRadius: The corner radius. Defaults to `16`.
    public init(
        tintColor: Color = .white,
        opacity: CGFloat = 0.18,
        cornerRadius: CGFloat = 16
    ) {
        self.tintColor = tintColor
        self.opacity = opacity
        self.cornerRadius = cornerRadius
    }

    // MARK: - Body

    public func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(.ultraThickMaterial)

                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(effectiveTint)
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(Color.white.opacity(0.15), lineWidth: 0.5)
            )
    }

    // MARK: - Private

    private var effectiveTint: Color {
        colorScheme == .dark
            ? tintColor.opacity(opacity * 0.6)
            : tintColor.opacity(opacity)
    }
}

// MARK: - View Extension

public extension View {
    /// Applies a frosted glass effect to the view.
    ///
    /// - Parameters:
    ///   - tintColor: The tint color. Defaults to `.white`.
    ///   - opacity: The frosted tint opacity. Defaults to `0.18`.
    ///   - cornerRadius: Corner radius. Defaults to `16`.
    /// - Returns: A view with a frosted glass background.
    func frostedGlass(
        tintColor: Color = .white,
        opacity: CGFloat = 0.18,
        cornerRadius: CGFloat = 16
    ) -> some View {
        modifier(FrostedGlassModifier(tintColor: tintColor, opacity: opacity, cornerRadius: cornerRadius))
    }
}
