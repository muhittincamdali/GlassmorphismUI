import SwiftUI

/// A view modifier that adds a shimmer highlight animation over the glass surface.
public struct GlassShimmerModifier: ViewModifier {
    /// The shimmer highlight color.
    private let color: Color

    /// Duration of one full shimmer cycle in seconds.
    private let duration: Double

    @State private var phase: CGFloat = -1

    public init(color: Color = .white, duration: Double = 2.5) {
        self.color = color
        self.duration = duration
    }

    public func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { proxy in
                    shimmerGradient(width: proxy.size.width)
                        .offset(x: phase * proxy.size.width)
                }
                .mask(content)
                .allowsHitTesting(false)
            )
            .onAppear {
                withAnimation(.linear(duration: duration).repeatForever(autoreverses: false)) {
                    phase = 2
                }
            }
    }

    private func shimmerGradient(width: CGFloat) -> some View {
        LinearGradient(
            stops: [
                .init(color: .clear, location: 0),
                .init(color: color.opacity(0.3), location: 0.45),
                .init(color: color.opacity(0.5), location: 0.5),
                .init(color: color.opacity(0.3), location: 0.55),
                .init(color: .clear, location: 1)
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
        .frame(width: width * 0.6)
    }
}

/// A view modifier that adds a gentle pulse animation to the glass view.
public struct GlassPulseModifier: ViewModifier {
    /// Duration of one full pulse cycle in seconds.
    private let duration: Double

    /// The minimum scale during the pulse.
    private let minScale: CGFloat

    @State private var isPulsing = false

    public init(duration: Double = 2.0, minScale: CGFloat = 0.97) {
        self.duration = duration
        self.minScale = minScale
    }

    public func body(content: Content) -> some View {
        content
            .scaleEffect(isPulsing ? 1.0 : minScale)
            .opacity(isPulsing ? 1.0 : 0.85)
            .animation(
                .easeInOut(duration: duration).repeatForever(autoreverses: true),
                value: isPulsing
            )
            .onAppear { isPulsing = true }
    }
}

// MARK: - View Extensions

public extension View {
    /// Adds a shimmer animation over the view.
    ///
    /// - Parameters:
    ///   - color: The shimmer highlight color. Defaults to `.white`.
    ///   - duration: Cycle duration in seconds. Defaults to `2.5`.
    func glassShimmer(color: Color = .white, duration: Double = 2.5) -> some View {
        modifier(GlassShimmerModifier(color: color, duration: duration))
    }

    /// Adds a pulse animation to the view.
    ///
    /// - Parameters:
    ///   - duration: Cycle duration in seconds. Defaults to `2.0`.
    ///   - minScale: Minimum scale factor. Defaults to `0.97`.
    func glassPulse(duration: Double = 2.0, minScale: CGFloat = 0.97) -> some View {
        modifier(GlassPulseModifier(duration: duration, minScale: minScale))
    }
}
