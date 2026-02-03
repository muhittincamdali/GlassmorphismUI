import SwiftUI

/// A view modifier that applies an aurora-style gradient glass effect.
///
/// Aurora glass overlays an animated multi-color gradient on top of the
/// standard glass blur, producing a colorful, holographic appearance.
public struct AuroraGlassModifier: ViewModifier {
    // MARK: - Properties

    /// The gradient colors for the aurora effect.
    private let colors: [Color]

    /// The overall opacity of the aurora overlay.
    private let intensity: CGFloat

    /// The corner radius of the glass shape.
    private let cornerRadius: CGFloat

    /// Whether the aurora gradient animates continuously.
    private let animated: Bool

    @State private var animationPhase: CGFloat = 0
    @Environment(\.colorScheme) private var colorScheme

    // MARK: - Initialization

    /// Creates an aurora glass modifier.
    ///
    /// - Parameters:
    ///   - colors: Gradient colors. Defaults to pink, purple, and indigo.
    ///   - intensity: Aurora opacity. Defaults to `0.25`.
    ///   - cornerRadius: Corner radius. Defaults to `16`.
    ///   - animated: Whether to animate the gradient. Defaults to `true`.
    public init(
        colors: [Color] = [.pink, .purple, .indigo],
        intensity: CGFloat = 0.25,
        cornerRadius: CGFloat = 16,
        animated: Bool = true
    ) {
        self.colors = colors
        self.intensity = intensity
        self.cornerRadius = cornerRadius
        self.animated = animated
    }

    // MARK: - Body

    public func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    // Base blur layer
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(.ultraThinMaterial)

                    // Aurora gradient overlay
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(auroraGradient)
                        .opacity(effectiveIntensity)
                        .blendMode(.plusLighter)

                    // White tint for glass feel
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(Color.white.opacity(colorScheme == .dark ? 0.05 : 0.08))
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(
                        auroraGradient.opacity(0.4),
                        lineWidth: 0.8
                    )
            )
            .shadow(color: colors.first?.opacity(0.2) ?? .clear, radius: 12, x: 0, y: 6)
            .onAppear {
                guard animated else { return }
                withAnimation(.linear(duration: 6).repeatForever(autoreverses: true)) {
                    animationPhase = 1
                }
            }
    }

    // MARK: - Private

    private var auroraGradient: LinearGradient {
        LinearGradient(
            colors: colors,
            startPoint: animated ? animatedStart : .topLeading,
            endPoint: animated ? animatedEnd : .bottomTrailing
        )
    }

    private var animatedStart: UnitPoint {
        UnitPoint(x: animationPhase, y: 0)
    }

    private var animatedEnd: UnitPoint {
        UnitPoint(x: 1 - animationPhase, y: 1)
    }

    private var effectiveIntensity: CGFloat {
        colorScheme == .dark ? intensity * 0.8 : intensity
    }
}

// MARK: - View Extension

public extension View {
    /// Applies an aurora gradient glass effect to the view.
    ///
    /// - Parameters:
    ///   - colors: The gradient colors.
    ///   - intensity: The aurora opacity. Defaults to `0.25`.
    ///   - cornerRadius: Corner radius. Defaults to `16`.
    ///   - animated: Whether to animate. Defaults to `true`.
    /// - Returns: A view with an aurora glass background.
    func auroraGlass(
        colors: [Color] = [.pink, .purple, .indigo],
        intensity: CGFloat = 0.25,
        cornerRadius: CGFloat = 16,
        animated: Bool = true
    ) -> some View {
        modifier(AuroraGlassModifier(colors: colors, intensity: intensity, cornerRadius: cornerRadius, animated: animated))
    }
}
