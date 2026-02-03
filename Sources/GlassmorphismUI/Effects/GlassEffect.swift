//
//  GlassEffect.swift
//  GlassmorphismUI
//
//  Created by Muhittin Camdali
//  Copyright © 2025 GlassmorphismUI. MIT License.
//

import SwiftUI

// MARK: - Glass Effect Protocol

/// Protocol defining the interface for all glass effects in the library.
///
/// Conforming types can implement custom glass effects with full control
/// over blur, opacity, borders, and shadows.
///
/// ```swift
/// struct CustomGlassEffect: GlassEffectProtocol {
///     func apply(to view: some View) -> some View {
///         view.blur(radius: 20)
///     }
/// }
/// ```
public protocol GlassEffectProtocol: Sendable {
    /// The blur radius for the effect
    var blurRadius: CGFloat { get }
    
    /// The background opacity multiplier
    var backgroundOpacity: CGFloat { get }
    
    /// Whether the effect is currently active
    var isActive: Bool { get }
    
    /// Applies the glass effect to a view
    associatedtype EffectBody: View
    @ViewBuilder func apply<Content: View>(to content: Content) -> EffectBody
}

// MARK: - Glass Effect Type

/// Enumeration of available glass effect types.
///
/// Each type provides a distinct visual appearance optimized for
/// different use cases and design requirements.
public enum GlassEffectType: String, CaseIterable, Sendable, Identifiable {
    /// Standard frosted glass with even blur distribution
    case frosted
    
    /// Crystal clear effect with minimal blur
    case crystal
    
    /// Smooth gradient-based glass effect
    case gradient
    
    /// Dynamic aurora effect with color shifting
    case aurora
    
    /// Noise-textured glass for vintage aesthetics
    case noise
    
    /// Reflective glass with specular highlights
    case reflective
    
    /// Morphing glass with animated transitions
    case morphing
    
    /// Holographic glass with rainbow effects
    case holographic
    
    /// Neon-glow glass effect
    case neon
    
    /// Ice crystal effect with sharp edges
    case ice
    
    /// Water droplet effect
    case water
    
    /// Smoke-like diffusion effect
    case smoke
    
    /// Prism light refraction effect
    case prism
    
    /// Unique identifier
    public var id: String { rawValue }
    
    /// Human-readable display name
    public var displayName: String {
        switch self {
        case .frosted: return "Frosted"
        case .crystal: return "Crystal"
        case .gradient: return "Gradient"
        case .aurora: return "Aurora"
        case .noise: return "Noise"
        case .reflective: return "Reflective"
        case .morphing: return "Morphing"
        case .holographic: return "Holographic"
        case .neon: return "Neon"
        case .ice: return "Ice"
        case .water: return "Water"
        case .smoke: return "Smoke"
        case .prism: return "Prism"
        }
    }
    
    /// Default blur radius for this effect type
    public var defaultBlurRadius: CGFloat {
        switch self {
        case .frosted: return 20
        case .crystal: return 8
        case .gradient: return 15
        case .aurora: return 25
        case .noise: return 12
        case .reflective: return 18
        case .morphing: return 22
        case .holographic: return 16
        case .neon: return 30
        case .ice: return 10
        case .water: return 14
        case .smoke: return 35
        case .prism: return 20
        }
    }
    
    /// Recommended opacity for this effect type
    public var recommendedOpacity: CGFloat {
        switch self {
        case .frosted: return 0.15
        case .crystal: return 0.08
        case .gradient: return 0.20
        case .aurora: return 0.25
        case .noise: return 0.18
        case .reflective: return 0.12
        case .morphing: return 0.22
        case .holographic: return 0.30
        case .neon: return 0.35
        case .ice: return 0.10
        case .water: return 0.15
        case .smoke: return 0.40
        case .prism: return 0.25
        }
    }
}

// MARK: - Glass Effect Configuration

/// Configuration options for glass effects.
///
/// Provides fine-grained control over all visual aspects of glass effects.
///
/// ```swift
/// let config = GlassEffectConfiguration(
///     type: .frosted,
///     intensity: .medium,
///     colorScheme: .adaptive
/// )
/// ```
public struct GlassEffectConfiguration: Sendable, Equatable {
    
    // MARK: - Effect Intensity
    
    /// Intensity levels for glass effects
    public enum Intensity: CGFloat, CaseIterable, Sendable {
        case ultraLight = 0.25
        case light = 0.5
        case medium = 1.0
        case strong = 1.5
        case ultraStrong = 2.0
        
        /// Display name for the intensity level
        public var displayName: String {
            switch self {
            case .ultraLight: return "Ultra Light"
            case .light: return "Light"
            case .medium: return "Medium"
            case .strong: return "Strong"
            case .ultraStrong: return "Ultra Strong"
            }
        }
    }
    
    // MARK: - Color Scheme
    
    /// Color scheme options for glass effects
    public enum ColorScheme: Sendable, Equatable {
        case light
        case dark
        case adaptive
        case custom(primary: Color, secondary: Color)
        
        /// Primary color for the scheme
        public var primaryColor: Color {
            switch self {
            case .light: return .white
            case .dark: return .black
            case .adaptive: return .primary
            case .custom(let primary, _): return primary
            }
        }
        
        /// Secondary color for the scheme
        public var secondaryColor: Color {
            switch self {
            case .light: return Color.white.opacity(0.6)
            case .dark: return Color.white.opacity(0.3)
            case .adaptive: return .secondary
            case .custom(_, let secondary): return secondary
            }
        }
    }
    
    // MARK: - Properties
    
    /// The type of glass effect
    public var type: GlassEffectType
    
    /// The intensity of the effect
    public var intensity: Intensity
    
    /// The color scheme to use
    public var colorScheme: ColorScheme
    
    /// Custom blur radius override
    public var blurRadius: CGFloat?
    
    /// Custom opacity override
    public var opacity: CGFloat?
    
    /// Whether to include border effects
    public var includeBorder: Bool
    
    /// Border width when included
    public var borderWidth: CGFloat
    
    /// Whether to include shadow effects
    public var includeShadow: Bool
    
    /// Shadow radius when included
    public var shadowRadius: CGFloat
    
    /// Corner radius for the effect
    public var cornerRadius: CGFloat
    
    /// Whether the effect is animated
    public var isAnimated: Bool
    
    /// Animation duration in seconds
    public var animationDuration: Double
    
    /// Whether to use reduced motion settings
    public var respectsReducedMotion: Bool
    
    // MARK: - Initialization
    
    /// Creates a glass effect configuration with the specified parameters.
    ///
    /// - Parameters:
    ///   - type: The type of glass effect. Default `.frosted`.
    ///   - intensity: The intensity level. Default `.medium`.
    ///   - colorScheme: The color scheme. Default `.adaptive`.
    ///   - blurRadius: Custom blur radius override. Default `nil`.
    ///   - opacity: Custom opacity override. Default `nil`.
    ///   - includeBorder: Whether to include borders. Default `true`.
    ///   - borderWidth: Border width. Default `0.8`.
    ///   - includeShadow: Whether to include shadows. Default `true`.
    ///   - shadowRadius: Shadow radius. Default `8`.
    ///   - cornerRadius: Corner radius. Default `16`.
    ///   - isAnimated: Whether to animate. Default `false`.
    ///   - animationDuration: Animation duration. Default `0.3`.
    ///   - respectsReducedMotion: Respect accessibility settings. Default `true`.
    public init(
        type: GlassEffectType = .frosted,
        intensity: Intensity = .medium,
        colorScheme: ColorScheme = .adaptive,
        blurRadius: CGFloat? = nil,
        opacity: CGFloat? = nil,
        includeBorder: Bool = true,
        borderWidth: CGFloat = 0.8,
        includeShadow: Bool = true,
        shadowRadius: CGFloat = 8,
        cornerRadius: CGFloat = 16,
        isAnimated: Bool = false,
        animationDuration: Double = 0.3,
        respectsReducedMotion: Bool = true
    ) {
        self.type = type
        self.intensity = intensity
        self.colorScheme = colorScheme
        self.blurRadius = blurRadius
        self.opacity = opacity
        self.includeBorder = includeBorder
        self.borderWidth = borderWidth
        self.includeShadow = includeShadow
        self.shadowRadius = shadowRadius
        self.cornerRadius = cornerRadius
        self.isAnimated = isAnimated
        self.animationDuration = animationDuration
        self.respectsReducedMotion = respectsReducedMotion
    }
    
    // MARK: - Computed Properties
    
    /// The effective blur radius considering overrides and intensity
    public var effectiveBlurRadius: CGFloat {
        let base = blurRadius ?? type.defaultBlurRadius
        return base * intensity.rawValue
    }
    
    /// The effective opacity considering overrides and intensity
    public var effectiveOpacity: CGFloat {
        let base = opacity ?? type.recommendedOpacity
        return min(base * intensity.rawValue, 1.0)
    }
    
    // MARK: - Presets
    
    /// Default configuration for general use
    public static let `default` = GlassEffectConfiguration()
    
    /// Subtle configuration for minimal visual impact
    public static let subtle = GlassEffectConfiguration(
        type: .crystal,
        intensity: .light,
        includeBorder: false,
        includeShadow: false,
        cornerRadius: 12
    )
    
    /// Prominent configuration for high visibility
    public static let prominent = GlassEffectConfiguration(
        type: .frosted,
        intensity: .strong,
        borderWidth: 1.2,
        shadowRadius: 16,
        cornerRadius: 20
    )
    
    /// Card-optimized configuration
    public static let card = GlassEffectConfiguration(
        type: .frosted,
        intensity: .medium,
        borderWidth: 0.6,
        shadowRadius: 12,
        cornerRadius: 24
    )
    
    /// Button-optimized configuration
    public static let button = GlassEffectConfiguration(
        type: .crystal,
        intensity: .light,
        borderWidth: 1.0,
        shadowRadius: 4,
        cornerRadius: 12,
        isAnimated: true
    )
    
    /// Sheet-optimized configuration
    public static let sheet = GlassEffectConfiguration(
        type: .frosted,
        intensity: .strong,
        borderWidth: 0.5,
        shadowRadius: 20,
        cornerRadius: 32
    )
    
    /// Navigation bar configuration
    public static let navigationBar = GlassEffectConfiguration(
        type: .gradient,
        intensity: .medium,
        borderWidth: 0.5,
        includeShadow: false,
        cornerRadius: 0
    )
    
    /// Tab bar configuration
    public static let tabBar = GlassEffectConfiguration(
        type: .frosted,
        intensity: .medium,
        borderWidth: 0.5,
        shadowRadius: 8,
        cornerRadius: 0
    )
}

// MARK: - Glass Effect View

/// A view that applies a configurable glass effect to its content.
///
/// Use `GlassEffectView` to wrap any SwiftUI content with a glass effect:
///
/// ```swift
/// GlassEffectView(configuration: .prominent) {
///     Text("Hello, Glass!")
///         .padding()
/// }
/// ```
public struct GlassEffectView<Content: View>: View {
    
    // MARK: - Properties
    
    /// The configuration for the glass effect
    private let configuration: GlassEffectConfiguration
    
    /// The content to display
    private let content: Content
    
    /// Environment color scheme
    @Environment(\.colorScheme) private var colorScheme
    
    /// Reduced motion preference
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    /// Animation state for animated effects
    @State private var animationPhase: CGFloat = 0
    
    // MARK: - Initialization
    
    /// Creates a glass effect view with the specified configuration.
    ///
    /// - Parameters:
    ///   - configuration: The glass effect configuration. Default `.default`.
    ///   - content: The content to display inside the glass effect.
    public init(
        configuration: GlassEffectConfiguration = .default,
        @ViewBuilder content: () -> Content
    ) {
        self.configuration = configuration
        self.content = content()
    }
    
    /// Creates a glass effect view with a specific effect type.
    ///
    /// - Parameters:
    ///   - type: The type of glass effect.
    ///   - intensity: The effect intensity. Default `.medium`.
    ///   - content: The content to display inside the glass effect.
    public init(
        type: GlassEffectType,
        intensity: GlassEffectConfiguration.Intensity = .medium,
        @ViewBuilder content: () -> Content
    ) {
        self.configuration = GlassEffectConfiguration(type: type, intensity: intensity)
        self.content = content()
    }
    
    // MARK: - Body
    
    public var body: some View {
        content
            .background(glassBackground)
            .clipShape(RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous))
            .overlay(borderOverlay)
            .shadow(
                color: shadowColor,
                radius: configuration.includeShadow ? configuration.shadowRadius : 0,
                x: 0,
                y: configuration.includeShadow ? 4 : 0
            )
            .onAppear {
                if configuration.isAnimated && shouldAnimate {
                    startAnimation()
                }
            }
    }
    
    // MARK: - Private Views
    
    @ViewBuilder
    private var glassBackground: some View {
        ZStack {
            // Base blur layer
            blurLayer
            
            // Color tint layer
            tintLayer
            
            // Effect-specific layers
            effectSpecificLayers
            
            // Specular highlight
            specularHighlight
        }
    }
    
    @ViewBuilder
    private var blurLayer: some View {
        Rectangle()
            .fill(.ultraThinMaterial)
            .blur(radius: configuration.effectiveBlurRadius * 0.5)
    }
    
    @ViewBuilder
    private var tintLayer: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    colors: [
                        effectiveColorScheme.primaryColor.opacity(configuration.effectiveOpacity),
                        effectiveColorScheme.secondaryColor.opacity(configuration.effectiveOpacity * 0.5)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
    }
    
    @ViewBuilder
    private var effectSpecificLayers: some View {
        switch configuration.type {
        case .frosted:
            frostedLayer
        case .crystal:
            crystalLayer
        case .gradient:
            gradientLayer
        case .aurora:
            auroraLayer
        case .noise:
            noiseLayer
        case .reflective:
            reflectiveLayer
        case .morphing:
            morphingLayer
        case .holographic:
            holographicLayer
        case .neon:
            neonLayer
        case .ice:
            iceLayer
        case .water:
            waterLayer
        case .smoke:
            smokeLayer
        case .prism:
            prismLayer
        }
    }
    
    @ViewBuilder
    private var frostedLayer: some View {
        Rectangle()
            .fill(Color.white.opacity(0.05))
            .blur(radius: 1)
    }
    
    @ViewBuilder
    private var crystalLayer: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    colors: [
                        Color.white.opacity(0.1),
                        Color.clear
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
    }
    
    @ViewBuilder
    private var gradientLayer: some View {
        Rectangle()
            .fill(
                AngularGradient(
                    colors: [
                        Color.white.opacity(0.1),
                        Color.white.opacity(0.05),
                        Color.white.opacity(0.1)
                    ],
                    center: .center,
                    angle: .degrees(animationPhase * 360)
                )
            )
    }
    
    @ViewBuilder
    private var auroraLayer: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    colors: [
                        Color.purple.opacity(0.1),
                        Color.blue.opacity(0.08),
                        Color.cyan.opacity(0.1),
                        Color.green.opacity(0.08)
                    ],
                    startPoint: UnitPoint(x: animationPhase, y: 0),
                    endPoint: UnitPoint(x: 1 - animationPhase, y: 1)
                )
            )
    }
    
    @ViewBuilder
    private var noiseLayer: some View {
        Rectangle()
            .fill(Color.white.opacity(0.02))
    }
    
    @ViewBuilder
    private var reflectiveLayer: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    colors: [
                        Color.white.opacity(0.2),
                        Color.white.opacity(0.05),
                        Color.white.opacity(0.1)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
    }
    
    @ViewBuilder
    private var morphingLayer: some View {
        Rectangle()
            .fill(
                RadialGradient(
                    colors: [
                        Color.white.opacity(0.15),
                        Color.white.opacity(0.05)
                    ],
                    center: UnitPoint(x: 0.5 + cos(animationPhase * .pi * 2) * 0.3,
                                     y: 0.5 + sin(animationPhase * .pi * 2) * 0.3),
                    startRadius: 0,
                    endRadius: 200
                )
            )
    }
    
    @ViewBuilder
    private var holographicLayer: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    colors: [
                        Color.red.opacity(0.05),
                        Color.orange.opacity(0.05),
                        Color.yellow.opacity(0.05),
                        Color.green.opacity(0.05),
                        Color.blue.opacity(0.05),
                        Color.purple.opacity(0.05)
                    ],
                    startPoint: UnitPoint(x: animationPhase, y: 0),
                    endPoint: UnitPoint(x: animationPhase + 0.5, y: 1)
                )
            )
    }
    
    @ViewBuilder
    private var neonLayer: some View {
        Rectangle()
            .fill(Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: configuration.cornerRadius - 2, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.cyan.opacity(0.3),
                                Color.purple.opacity(0.3)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
                    .blur(radius: 4)
            )
    }
    
    @ViewBuilder
    private var iceLayer: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    colors: [
                        Color.white.opacity(0.2),
                        Color.cyan.opacity(0.05),
                        Color.white.opacity(0.1)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
    }
    
    @ViewBuilder
    private var waterLayer: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    colors: [
                        Color.blue.opacity(0.08),
                        Color.cyan.opacity(0.05)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
    }
    
    @ViewBuilder
    private var smokeLayer: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.1))
            .blur(radius: 5)
    }
    
    @ViewBuilder
    private var prismLayer: some View {
        Rectangle()
            .fill(
                AngularGradient(
                    colors: [
                        Color.red.opacity(0.03),
                        Color.yellow.opacity(0.03),
                        Color.green.opacity(0.03),
                        Color.cyan.opacity(0.03),
                        Color.blue.opacity(0.03),
                        Color.purple.opacity(0.03),
                        Color.red.opacity(0.03)
                    ],
                    center: .center
                )
            )
    }
    
    @ViewBuilder
    private var specularHighlight: some View {
        LinearGradient(
            colors: [
                Color.white.opacity(0.25),
                Color.white.opacity(0.0)
            ],
            startPoint: .top,
            endPoint: .center
        )
        .opacity(0.5)
    }
    
    @ViewBuilder
    private var borderOverlay: some View {
        if configuration.includeBorder {
            RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.4),
                            Color.white.opacity(0.1),
                            Color.white.opacity(0.2)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: configuration.borderWidth
                )
        }
    }
    
    // MARK: - Private Computed Properties
    
    private var effectiveColorScheme: GlassEffectConfiguration.ColorScheme {
        switch configuration.colorScheme {
        case .adaptive:
            return colorScheme == .dark ? .dark : .light
        default:
            return configuration.colorScheme
        }
    }
    
    private var shadowColor: Color {
        colorScheme == .dark
            ? Color.black.opacity(0.3)
            : Color.black.opacity(0.15)
    }
    
    private var shouldAnimate: Bool {
        configuration.respectsReducedMotion ? !reduceMotion : true
    }
    
    // MARK: - Private Methods
    
    private func startAnimation() {
        withAnimation(
            .linear(duration: configuration.animationDuration * 10)
            .repeatForever(autoreverses: false)
        ) {
            animationPhase = 1
        }
    }
}

// MARK: - View Extension

public extension View {
    
    /// Applies a glass effect to the view.
    ///
    /// - Parameter configuration: The glass effect configuration.
    /// - Returns: A view with the glass effect applied.
    func glassEffect(_ configuration: GlassEffectConfiguration = .default) -> some View {
        modifier(GlassEffectModifier(configuration: configuration))
    }
    
    /// Applies a glass effect of the specified type.
    ///
    /// - Parameters:
    ///   - type: The type of glass effect.
    ///   - intensity: The effect intensity.
    /// - Returns: A view with the glass effect applied.
    func glassEffect(
        _ type: GlassEffectType,
        intensity: GlassEffectConfiguration.Intensity = .medium
    ) -> some View {
        modifier(GlassEffectModifier(
            configuration: GlassEffectConfiguration(type: type, intensity: intensity)
        ))
    }
}

// MARK: - Glass Effect Modifier

/// A view modifier that applies a glass effect to any view.
public struct GlassEffectModifier: ViewModifier {
    
    /// The configuration for the glass effect
    let configuration: GlassEffectConfiguration
    
    /// Environment color scheme
    @Environment(\.colorScheme) private var colorScheme
    
    public func body(content: Content) -> some View {
        content
            .background(
                GlassEffectBackground(configuration: configuration)
            )
            .clipShape(RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
                    .stroke(
                        borderGradient,
                        lineWidth: configuration.includeBorder ? configuration.borderWidth : 0
                    )
            )
            .shadow(
                color: shadowColor,
                radius: configuration.includeShadow ? configuration.shadowRadius : 0,
                x: 0,
                y: configuration.includeShadow ? 4 : 0
            )
    }
    
    private var borderGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color.white.opacity(0.4),
                Color.white.opacity(0.1),
                Color.white.opacity(0.2)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private var shadowColor: Color {
        colorScheme == .dark
            ? Color.black.opacity(0.3)
            : Color.black.opacity(0.15)
    }
}

// MARK: - Glass Effect Background

/// A view representing the background of a glass effect.
struct GlassEffectBackground: View {
    
    let configuration: GlassEffectConfiguration
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ZStack {
            // Material base
            Rectangle()
                .fill(.ultraThinMaterial)
            
            // Tint overlay
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            tintColor.opacity(configuration.effectiveOpacity),
                            tintColor.opacity(configuration.effectiveOpacity * 0.5)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            // Specular highlight
            LinearGradient(
                colors: [
                    Color.white.opacity(0.2),
                    Color.clear
                ],
                startPoint: .top,
                endPoint: .center
            )
        }
        .blur(radius: configuration.effectiveBlurRadius * 0.1)
    }
    
    private var tintColor: Color {
        colorScheme == .dark ? .white : .white
    }
}

// MARK: - Preview Provider

#if DEBUG
struct GlassEffect_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [.purple, .blue, .cyan],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Effect types showcase
                ForEach(GlassEffectType.allCases.prefix(4)) { type in
                    GlassEffectView(type: type) {
                        Text(type.displayName)
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding()
        }
        .previewDisplayName("Glass Effects")
    }
}
#endif
