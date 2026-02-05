// GlassModifier.swift
// GlassmorphismUI - Production-ready glassmorphism effects for SwiftUI
// Copyright (c) 2024-2025 Muhittin Camdali. MIT License.

import SwiftUI

// MARK: - GlassModifier

/// A view modifier that applies glassmorphism effects.
///
/// This is the core modifier used by all glass effect APIs.
/// Prefer using the `.glass()` View extension instead of this directly.
public struct GlassModifier: ViewModifier {
    
    // MARK: - Properties
    
    private let style: GlassStyle
    private let cornerStyle: GlassCornerStyle
    private let material: GlassMaterial
    
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.glassConfiguration) private var configuration
    
    // MARK: - Initialization
    
    /// Creates a glass modifier.
    ///
    /// - Parameters:
    ///   - style: The visual style. Default is `.regular`.
    ///   - cornerStyle: The corner style. Default is `.large`.
    ///   - material: The blur material. Default is `.regular`.
    public init(
        style: GlassStyle = .regular,
        cornerStyle: GlassCornerStyle = .large,
        material: GlassMaterial = .regular
    ) {
        self.style = style
        self.cornerStyle = cornerStyle
        self.material = material
    }
    
    // MARK: - Body
    
    public func body(content: Content) -> some View {
        if configuration.shouldReduceTransparency {
            // Accessibility: solid background when transparency is reduced
            content.background(solidBackground)
        } else {
            content.background(glassBackground)
        }
    }
    
    // MARK: - Private Views
    
    @ViewBuilder
    private var glassBackground: some View {
        let shape = glassShape
        
        ZStack {
            // Base material blur
            materialBackground(shape: shape)
            
            // Tint overlay
            shape.fill(tintFill)
            
            // Inner highlight (top edge)
            shape.stroke(borderGradient, lineWidth: 0.5)
        }
        .clipShape(shape)
        .shadow(
            color: shadowColor,
            radius: effectiveShadowRadius,
            x: 0,
            y: effectiveShadowRadius / 3
        )
    }
    
    @ViewBuilder
    private var solidBackground: some View {
        glassShape
            .fill(colorScheme == .dark ? Color.black.opacity(0.8) : Color.white.opacity(0.9))
            .overlay(glassShape.stroke(Color.primary.opacity(0.1), lineWidth: 0.5))
    }
    
    private var glassShape: some Shape {
        RoundedRectangle(
            cornerRadius: cornerStyle.radius,
            style: cornerStyle.isContinuous ? .continuous : .circular
        )
    }
    
    @ViewBuilder
    private func materialBackground(shape: some Shape) -> some View {
        switch material {
        case .ultraThin:
            shape.fill(.ultraThinMaterial)
        case .thin:
            shape.fill(.thinMaterial)
        case .regular:
            shape.fill(.regularMaterial)
        case .thick:
            shape.fill(.thickMaterial)
        case .ultraThick:
            shape.fill(.ultraThickMaterial)
        }
    }
    
    private var tintFill: Color {
        let baseOpacity = style.tintOpacity
        let adjustedOpacity = colorScheme == .dark
            ? baseOpacity * configuration.darkModeTintMultiplier
            : baseOpacity
        return style.tintColor.opacity(adjustedOpacity)
    }
    
    private var borderGradient: LinearGradient {
        let opacity = style.borderOpacity * (colorScheme == .dark ? 0.6 : 1.0)
        return LinearGradient(
            colors: [
                Color.white.opacity(opacity),
                Color.white.opacity(opacity * 0.3)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private var shadowColor: Color {
        Color.black.opacity(effectiveShadowOpacity)
    }
    
    private var effectiveShadowRadius: CGFloat {
        let base = style.shadowRadius
        return colorScheme == .dark ? base * configuration.darkModeShadowMultiplier : base
    }
    
    private var effectiveShadowOpacity: CGFloat {
        let base = style.shadowOpacity
        return colorScheme == .dark ? base * 1.2 : base
    }
}

// MARK: - View Extension

public extension View {
    
    /// Applies a glassmorphism effect to the view.
    ///
    /// This is the primary API for adding glass effects.
    ///
    /// ## Example
    ///
    /// ```swift
    /// Text("Hello World")
    ///     .padding()
    ///     .glass()
    ///
    /// // With customization
    /// Text("Custom Glass")
    ///     .padding()
    ///     .glass(style: .prominent, cornerRadius: 20)
    /// ```
    ///
    /// - Parameters:
    ///   - style: The glass visual style. Default is `.regular`.
    ///   - cornerRadius: The corner radius. Default is 16.
    ///   - material: The blur material. Default is `.regular`.
    /// - Returns: A view with glass effect applied.
    func glass(
        style: GlassStyle = .regular,
        cornerRadius: CGFloat = 16,
        material: GlassMaterial = .regular
    ) -> some View {
        modifier(GlassModifier(
            style: style,
            cornerStyle: .continuous(cornerRadius),
            material: material
        ))
    }
    
    /// Applies a glassmorphism effect with a specific corner style.
    ///
    /// - Parameters:
    ///   - style: The glass visual style.
    ///   - cornerStyle: The corner style (square, rounded, capsule, continuous).
    ///   - material: The blur material.
    /// - Returns: A view with glass effect applied.
    func glass(
        style: GlassStyle = .regular,
        cornerStyle: GlassCornerStyle,
        material: GlassMaterial = .regular
    ) -> some View {
        modifier(GlassModifier(
            style: style,
            cornerStyle: cornerStyle,
            material: material
        ))
    }
}
