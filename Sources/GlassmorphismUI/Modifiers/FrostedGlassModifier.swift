// FrostedGlassModifier.swift
// GlassmorphismUI - Production-ready glassmorphism effects for SwiftUI
// Copyright (c) 2024-2025 Muhittin Camdali. MIT License.

import SwiftUI

// MARK: - FrostedGlassModifier

/// A view modifier that applies a frosted/matte glass effect.
///
/// Creates an appearance similar to sandblasted or etched glass,
/// with a heavier tint layer on top of the blur.
public struct FrostedGlassModifier: ViewModifier {
    
    // MARK: - Properties
    
    private let tint: Color
    private let intensity: CGFloat
    private let cornerRadius: CGFloat
    private let border: Bool
    
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.glassConfiguration) private var configuration
    
    // MARK: - Initialization
    
    /// Creates a frosted glass modifier.
    ///
    /// - Parameters:
    ///   - tint: The tint color. Default is white.
    ///   - intensity: The frosting intensity (0.0 to 1.0). Default is 0.3.
    ///   - cornerRadius: The corner radius. Default is 16.
    ///   - border: Whether to show a border. Default is true.
    public init(
        tint: Color = .white,
        intensity: CGFloat = 0.3,
        cornerRadius: CGFloat = 16,
        border: Bool = true
    ) {
        self.tint = tint
        self.intensity = max(0, min(1, intensity))
        self.cornerRadius = cornerRadius
        self.border = border
    }
    
    // MARK: - Body
    
    public func body(content: Content) -> some View {
        if configuration.shouldReduceTransparency {
            content.background(solidBackground)
        } else {
            content.background(frostedBackground)
        }
    }
    
    // MARK: - Private Views
    
    @ViewBuilder
    private var frostedBackground: some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
        
        ZStack {
            // Heavy blur base
            shape.fill(.ultraThickMaterial)
            
            // Frosted tint overlay
            shape.fill(effectiveTint)
            
            // Subtle noise texture effect (simulated with gradient)
            shape.fill(noiseGradient)
        }
        .clipShape(shape)
        .overlay(borderOverlay)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    
    @ViewBuilder
    private var solidBackground: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(colorScheme == .dark ? Color.gray.opacity(0.9) : Color.white.opacity(0.95))
    }
    
    @ViewBuilder
    private var borderOverlay: some View {
        if border {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .stroke(Color.white.opacity(colorScheme == .dark ? 0.1 : 0.2), lineWidth: 0.5)
        }
    }
    
    private var effectiveTint: Color {
        let baseOpacity = intensity * 0.5
        return colorScheme == .dark
            ? tint.opacity(baseOpacity * 0.6)
            : tint.opacity(baseOpacity)
    }
    
    private var noiseGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color.white.opacity(intensity * 0.08),
                Color.white.opacity(intensity * 0.03),
                Color.white.opacity(intensity * 0.06)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// MARK: - View Extension

public extension View {
    
    /// Applies a frosted glass effect to the view.
    ///
    /// Creates a matte, sandblasted glass appearance.
    ///
    /// ## Example
    ///
    /// ```swift
    /// Text("Frosted")
    ///     .padding()
    ///     .frostedGlass()
    ///
    /// // With custom tint
    /// Text("Blue Frost")
    ///     .padding()
    ///     .frostedGlass(tint: .blue, intensity: 0.5)
    /// ```
    ///
    /// - Parameters:
    ///   - tint: The tint color. Default is white.
    ///   - intensity: The frosting intensity. Default is 0.3.
    ///   - cornerRadius: The corner radius. Default is 16.
    ///   - border: Whether to show a subtle border. Default is true.
    /// - Returns: A view with frosted glass effect applied.
    func frostedGlass(
        tint: Color = .white,
        intensity: CGFloat = 0.3,
        cornerRadius: CGFloat = 16,
        border: Bool = true
    ) -> some View {
        modifier(FrostedGlassModifier(
            tint: tint,
            intensity: intensity,
            cornerRadius: cornerRadius,
            border: border
        ))
    }
}
