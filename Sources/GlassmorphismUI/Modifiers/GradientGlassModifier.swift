// GradientGlassModifier.swift
// GlassmorphismUI - Production-ready glassmorphism effects for SwiftUI
// Copyright (c) 2024-2025 Muhittin Camdali. MIT License.

import SwiftUI

// MARK: - GradientGlassModifier

/// A view modifier that applies a gradient-tinted glass effect.
///
/// Combines glassmorphism with a subtle gradient overlay,
/// creating colorful, eye-catching surfaces.
public struct GradientGlassModifier: ViewModifier {
    
    // MARK: - Properties
    
    private let colors: [Color]
    private let intensity: CGFloat
    private let cornerRadius: CGFloat
    private let direction: GradientDirection
    
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.glassConfiguration) private var configuration
    
    // MARK: - Initialization
    
    /// Creates a gradient glass modifier.
    ///
    /// - Parameters:
    ///   - colors: The gradient colors.
    ///   - intensity: The gradient intensity (0.0 to 1.0). Default is 0.2.
    ///   - cornerRadius: The corner radius. Default is 16.
    ///   - direction: The gradient direction. Default is `.diagonal`.
    public init(
        colors: [Color],
        intensity: CGFloat = 0.2,
        cornerRadius: CGFloat = 16,
        direction: GradientDirection = .diagonal
    ) {
        self.colors = colors
        self.intensity = max(0, min(1, intensity))
        self.cornerRadius = cornerRadius
        self.direction = direction
    }
    
    // MARK: - Body
    
    public func body(content: Content) -> some View {
        if configuration.shouldReduceTransparency {
            content.background(solidBackground)
        } else {
            content.background(gradientGlassBackground)
        }
    }
    
    // MARK: - Private Views
    
    @ViewBuilder
    private var gradientGlassBackground: some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
        
        ZStack {
            // Base blur
            shape.fill(.thinMaterial)
            
            // Gradient overlay
            shape.fill(gradientFill)
            
            // White overlay for glass feel
            shape.fill(Color.white.opacity(colorScheme == .dark ? 0.03 : 0.06))
        }
        .clipShape(shape)
        .overlay(
            shape.stroke(borderGradient, lineWidth: 0.5)
        )
        .shadow(
            color: (colors.first ?? .clear).opacity(0.2),
            radius: 12,
            x: 0,
            y: 6
        )
    }
    
    @ViewBuilder
    private var solidBackground: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(colors.first ?? .gray)
            .opacity(0.8)
    }
    
    private var gradientFill: LinearGradient {
        let adjustedColors = colors.map { $0.opacity(effectiveIntensity) }
        return LinearGradient(
            colors: adjustedColors,
            startPoint: direction.startPoint,
            endPoint: direction.endPoint
        )
    }
    
    private var borderGradient: LinearGradient {
        LinearGradient(
            colors: colors.map { $0.opacity(0.4) },
            startPoint: direction.startPoint,
            endPoint: direction.endPoint
        )
    }
    
    private var effectiveIntensity: CGFloat {
        colorScheme == .dark ? intensity * 0.7 : intensity
    }
}

// MARK: - GradientDirection

/// The direction for gradient glass effects.
public enum GradientDirection: Sendable {
    /// Top to bottom.
    case vertical
    
    /// Left to right.
    case horizontal
    
    /// Top-left to bottom-right.
    case diagonal
    
    /// Top-right to bottom-left.
    case reverseDiagonal
    
    /// Radial from center.
    case radial
    
    var startPoint: UnitPoint {
        switch self {
        case .vertical: return .top
        case .horizontal: return .leading
        case .diagonal: return .topLeading
        case .reverseDiagonal: return .topTrailing
        case .radial: return .center
        }
    }
    
    var endPoint: UnitPoint {
        switch self {
        case .vertical: return .bottom
        case .horizontal: return .trailing
        case .diagonal: return .bottomTrailing
        case .reverseDiagonal: return .bottomLeading
        case .radial: return .bottom
        }
    }
}

// MARK: - View Extension

public extension View {
    
    /// Applies a gradient glass effect to the view.
    ///
    /// ## Example
    ///
    /// ```swift
    /// Text("Gradient Glass")
    ///     .padding()
    ///     .gradientGlass(colors: [.pink, .purple])
    ///
    /// // With direction
    /// Text("Horizontal")
    ///     .padding()
    ///     .gradientGlass(colors: [.blue, .cyan], direction: .horizontal)
    /// ```
    ///
    /// - Parameters:
    ///   - colors: The gradient colors.
    ///   - intensity: The gradient intensity. Default is 0.2.
    ///   - cornerRadius: The corner radius. Default is 16.
    ///   - direction: The gradient direction. Default is `.diagonal`.
    /// - Returns: A view with gradient glass effect applied.
    func gradientGlass(
        colors: [Color],
        intensity: CGFloat = 0.2,
        cornerRadius: CGFloat = 16,
        direction: GradientDirection = .diagonal
    ) -> some View {
        modifier(GradientGlassModifier(
            colors: colors,
            intensity: intensity,
            cornerRadius: cornerRadius,
            direction: direction
        ))
    }
    
    /// Applies an aurora glass effect (animated gradient glass).
    ///
    /// - Parameters:
    ///   - colors: The aurora colors. Default is pink, purple, indigo.
    ///   - intensity: The intensity. Default is 0.25.
    ///   - cornerRadius: The corner radius. Default is 16.
    /// - Returns: A view with aurora glass effect applied.
    func auroraGlass(
        colors: [Color] = [.pink, .purple, .indigo],
        intensity: CGFloat = 0.25,
        cornerRadius: CGFloat = 16
    ) -> some View {
        modifier(AnimatedGradientGlassModifier(
            colors: colors,
            intensity: intensity,
            cornerRadius: cornerRadius
        ))
    }
}

// MARK: - AnimatedGradientGlassModifier

/// A glass modifier with animated gradient effects.
public struct AnimatedGradientGlassModifier: ViewModifier {
    
    private let colors: [Color]
    private let intensity: CGFloat
    private let cornerRadius: CGFloat
    
    @State private var animationPhase: CGFloat = 0
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.glassConfiguration) private var configuration
    
    public init(
        colors: [Color],
        intensity: CGFloat,
        cornerRadius: CGFloat
    ) {
        self.colors = colors
        self.intensity = intensity
        self.cornerRadius = cornerRadius
    }
    
    public func body(content: Content) -> some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
        
        content
            .background(
                ZStack {
                    shape.fill(.ultraThinMaterial)
                    
                    shape.fill(animatedGradient)
                    
                    shape.fill(Color.white.opacity(colorScheme == .dark ? 0.03 : 0.06))
                }
                .clipShape(shape)
                .overlay(shape.stroke(Color.white.opacity(0.15), lineWidth: 0.5))
                .shadow(color: (colors.first ?? .clear).opacity(0.2), radius: 12)
            )
            .onAppear {
                guard !configuration.shouldReduceMotion else { return }
                withAnimation(.linear(duration: 6).repeatForever(autoreverses: true)) {
                    animationPhase = 1
                }
            }
    }
    
    private var animatedGradient: LinearGradient {
        let adjustedColors = colors.map { $0.opacity(intensity * (colorScheme == .dark ? 0.7 : 1.0)) }
        return LinearGradient(
            colors: adjustedColors,
            startPoint: UnitPoint(x: animationPhase, y: 0),
            endPoint: UnitPoint(x: 1 - animationPhase, y: 1)
        )
    }
}
