// AnimatedGlassModifier.swift
// GlassmorphismUI - Production-ready glassmorphism effects for SwiftUI
// Copyright (c) 2024-2025 Muhittin Camdali. MIT License.

import SwiftUI

// MARK: - GlassAnimation

/// Defines animation types for glass effects.
public enum GlassAnimation: Sendable {
    /// A subtle shimmer that moves across the glass surface.
    case shimmer
    
    /// A pulsing glow effect.
    case pulse
    
    /// A breathing opacity animation.
    case breathe
    
    /// A rainbow color shift.
    case rainbow
    
    /// No animation.
    case none
    
    var duration: Double {
        switch self {
        case .shimmer: return 2.5
        case .pulse: return 1.5
        case .breathe: return 3.0
        case .rainbow: return 4.0
        case .none: return 0
        }
    }
}

// MARK: - AnimatedGlassModifier

/// A view modifier that applies animated glass effects.
public struct AnimatedGlassModifier: ViewModifier {
    
    // MARK: - Properties
    
    private let animation: GlassAnimation
    private let style: GlassStyle
    private let cornerRadius: CGFloat
    
    @State private var animationPhase: CGFloat = 0
    @State private var isAnimating: Bool = false
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.glassConfiguration) private var configuration
    
    // MARK: - Initialization
    
    public init(
        animation: GlassAnimation,
        style: GlassStyle = .regular,
        cornerRadius: CGFloat = 16
    ) {
        self.animation = animation
        self.style = style
        self.cornerRadius = cornerRadius
    }
    
    // MARK: - Body
    
    public func body(content: Content) -> some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
        
        content
            .background(backgroundContent(shape: shape))
            .clipShape(shape)
            .overlay(borderOverlay(shape: shape))
            .shadow(color: shadowColor, radius: style.shadowRadius)
            .onAppear(perform: startAnimation)
    }
    
    // MARK: - Private
    
    @ViewBuilder
    private func backgroundContent(shape: some Shape) -> some View {
        ZStack {
            // Base glass
            shape.fill(.thinMaterial)
            
            // Animation layer
            switch animation {
            case .shimmer:
                shimmerLayer(shape: shape)
            case .pulse:
                pulseLayer(shape: shape)
            case .breathe:
                breatheLayer(shape: shape)
            case .rainbow:
                rainbowLayer(shape: shape)
            case .none:
                EmptyView()
            }
            
            // Tint
            shape.fill(style.tintColor.opacity(style.tintOpacity))
        }
    }
    
    @ViewBuilder
    private func shimmerLayer(shape: some Shape) -> some View {
        shape
            .fill(
                LinearGradient(
                    colors: [
                        .clear,
                        .white.opacity(0.3),
                        .clear
                    ],
                    startPoint: UnitPoint(x: animationPhase - 0.5, y: 0.5),
                    endPoint: UnitPoint(x: animationPhase + 0.5, y: 0.5)
                )
            )
            .blendMode(.plusLighter)
    }
    
    @ViewBuilder
    private func pulseLayer(shape: some Shape) -> some View {
        shape
            .fill(style.tintColor.opacity(0.15 * animationPhase))
            .blendMode(.plusLighter)
    }
    
    @ViewBuilder
    private func breatheLayer(shape: some Shape) -> some View {
        shape
            .fill(Color.white.opacity(0.05 + (0.1 * animationPhase)))
    }
    
    @ViewBuilder
    private func rainbowLayer(shape: some Shape) -> some View {
        shape
            .fill(
                AngularGradient(
                    colors: [.red, .orange, .yellow, .green, .blue, .purple, .red],
                    center: .center,
                    angle: .degrees(360 * animationPhase)
                )
            )
            .opacity(0.15)
            .blendMode(.plusLighter)
    }
    
    @ViewBuilder
    private func borderOverlay(shape: some Shape) -> some View {
        shape.stroke(
            Color.white.opacity(style.borderOpacity * (colorScheme == .dark ? 0.6 : 1.0)),
            lineWidth: 0.5
        )
    }
    
    private var shadowColor: Color {
        .black.opacity(style.shadowOpacity)
    }
    
    private func startAnimation() {
        guard animation != .none, !configuration.shouldReduceMotion else { return }
        
        isAnimating = true
        
        withAnimation(.linear(duration: animation.duration).repeatForever(autoreverses: animation != .shimmer)) {
            animationPhase = 1
        }
    }
}

// MARK: - View Extension

public extension View {
    
    /// Applies an animated glass effect to the view.
    ///
    /// ## Example
    ///
    /// ```swift
    /// Text("Shimmer Glass")
    ///     .padding()
    ///     .animatedGlass(.shimmer)
    ///
    /// Text("Pulsing Glass")
    ///     .padding()
    ///     .animatedGlass(.pulse, style: .prominent)
    /// ```
    ///
    /// - Parameters:
    ///   - animation: The animation type.
    ///   - style: The glass style. Default is `.regular`.
    ///   - cornerRadius: The corner radius. Default is 16.
    /// - Returns: A view with animated glass effect applied.
    func animatedGlass(
        _ animation: GlassAnimation,
        style: GlassStyle = .regular,
        cornerRadius: CGFloat = 16
    ) -> some View {
        modifier(AnimatedGlassModifier(
            animation: animation,
            style: style,
            cornerRadius: cornerRadius
        ))
    }
}
