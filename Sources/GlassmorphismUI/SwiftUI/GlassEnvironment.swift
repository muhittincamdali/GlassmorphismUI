//
//  GlassEnvironment.swift
//  GlassmorphismUI
//
//  SwiftUI environment values and preference keys for propagating
//  glassmorphism configuration throughout the view hierarchy.
//

import SwiftUI

// MARK: - Glass Style Environment Key

/// Environment key for the current glass style configuration.
private struct GlassStyleKey: EnvironmentKey {
    static let defaultValue = GlassStyle.standard
}

/// Represents a complete glass styling configuration.
public struct GlassStyle: Sendable, Equatable {
    /// Blur intensity (0.0 - 1.0)
    public var blurIntensity: CGFloat
    /// Tint color for the glass
    public var tintColor: Color
    /// Tint opacity
    public var tintOpacity: CGFloat
    /// Corner radius
    public var cornerRadius: CGFloat
    /// Border width
    public var borderWidth: CGFloat
    /// Border color
    public var borderColor: Color
    /// Shadow radius
    public var shadowRadius: CGFloat
    /// Shadow color
    public var shadowColor: Color
    /// Shadow offset
    public var shadowOffset: CGSize
    /// Whether to show noise texture
    public var showNoise: Bool
    /// Noise opacity
    public var noiseOpacity: CGFloat
    /// Animation for transitions
    public var animation: Animation
    
    /// Creates a custom glass style.
    public init(
        blurIntensity: CGFloat = 0.8,
        tintColor: Color = .white,
        tintOpacity: CGFloat = 0.1,
        cornerRadius: CGFloat = 16,
        borderWidth: CGFloat = 0.5,
        borderColor: Color = .white.opacity(0.3),
        shadowRadius: CGFloat = 15,
        shadowColor: Color = .black.opacity(0.15),
        shadowOffset: CGSize = CGSize(width: 0, height: 5),
        showNoise: Bool = true,
        noiseOpacity: CGFloat = 0.03,
        animation: Animation = .spring(response: 0.35, dampingFraction: 0.85)
    ) {
        self.blurIntensity = blurIntensity
        self.tintColor = tintColor
        self.tintOpacity = tintOpacity
        self.cornerRadius = cornerRadius
        self.borderWidth = borderWidth
        self.borderColor = borderColor
        self.shadowRadius = shadowRadius
        self.shadowColor = shadowColor
        self.shadowOffset = shadowOffset
        self.showNoise = showNoise
        self.noiseOpacity = noiseOpacity
        self.animation = animation
    }
    
    /// Standard glass style
    public static let standard = GlassStyle()
    
    /// Minimal glass style with subtle effects
    public static let minimal = GlassStyle(
        blurIntensity: 0.6,
        tintOpacity: 0.05,
        borderWidth: 0,
        shadowRadius: 8,
        showNoise: false
    )
    
    /// Prominent glass style with stronger effects
    public static let prominent = GlassStyle(
        blurIntensity: 0.95,
        tintOpacity: 0.15,
        cornerRadius: 20,
        borderWidth: 1,
        shadowRadius: 25,
        noiseOpacity: 0.05
    )
    
    /// Dark mode optimized glass style
    public static let dark = GlassStyle(
        blurIntensity: 0.7,
        tintColor: .black,
        tintOpacity: 0.3,
        borderColor: .white.opacity(0.1),
        shadowColor: .black.opacity(0.3)
    )
    
    /// Frosted glass style
    public static let frosted = GlassStyle(
        blurIntensity: 0.9,
        tintColor: .white,
        tintOpacity: 0.2,
        noiseOpacity: 0.05
    )
}

// MARK: - Environment Values Extension

public extension EnvironmentValues {
    /// The current glass style configuration.
    var glassStyle: GlassStyle {
        get { self[GlassStyleKey.self] }
        set { self[GlassStyleKey.self] = newValue }
    }
}

// MARK: - Glass Enabled Environment Key

private struct GlassEnabledKey: EnvironmentKey {
    static let defaultValue = true
}

public extension EnvironmentValues {
    /// Whether glass effects are enabled.
    var glassEffectsEnabled: Bool {
        get { self[GlassEnabledKey.self] }
        set { self[GlassEnabledKey.self] = newValue }
    }
}

// MARK: - Glass Animation Environment Key

private struct GlassAnimationKey: EnvironmentKey {
    static let defaultValue: Animation = .spring(response: 0.35, dampingFraction: 0.85)
}

public extension EnvironmentValues {
    /// The default animation for glass effects.
    var glassAnimation: Animation {
        get { self[GlassAnimationKey.self] }
        set { self[GlassAnimationKey.self] = newValue }
    }
}

// MARK: - Glass Intensity Environment Key

private struct GlassIntensityKey: EnvironmentKey {
    static let defaultValue: CGFloat = 1.0
}

public extension EnvironmentValues {
    /// Global intensity multiplier for glass effects (0.0 - 1.0).
    var glassIntensity: CGFloat {
        get { self[GlassIntensityKey.self] }
        set { self[GlassIntensityKey.self] = newValue }
    }
}

// MARK: - Glass Color Scheme Environment Key

/// Represents the color scheme preference for glass components.
public enum GlassColorScheme: Sendable {
    case light
    case dark
    case auto
}

private struct GlassColorSchemeKey: EnvironmentKey {
    static let defaultValue: GlassColorScheme = .auto
}

public extension EnvironmentValues {
    /// The preferred color scheme for glass components.
    var glassColorScheme: GlassColorScheme {
        get { self[GlassColorSchemeKey.self] }
        set { self[GlassColorSchemeKey.self] = newValue }
    }
}

// MARK: - Preference Keys

/// Preference key for reporting glass component sizes.
public struct GlassSizePreferenceKey: PreferenceKey {
    public static var defaultValue: CGSize = .zero
    
    public static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

/// Preference key for reporting glass component frames.
public struct GlassFramePreferenceKey: PreferenceKey {
    public static var defaultValue: CGRect = .zero
    
    public static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

/// Preference key for glass component visibility.
public struct GlassVisibilityPreferenceKey: PreferenceKey {
    public static var defaultValue: Bool = true
    
    public static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = value && nextValue()
    }
}

/// Preference key for glass component anchor points.
public struct GlassAnchorPreferenceKey: PreferenceKey {
    public static var defaultValue: [String: Anchor<CGPoint>] = [:]
    
    public static func reduce(value: inout [String: Anchor<CGPoint>], nextValue: () -> [String: Anchor<CGPoint>]) {
        value.merge(nextValue()) { _, new in new }
    }
}

// MARK: - Glass Context

/// A context object that provides access to glass configuration.
@MainActor
public final class GlassContext: ObservableObject {
    /// Shared instance for global access.
    public static let shared = GlassContext()
    
    /// The current glass style.
    @Published public var style: GlassStyle = .standard
    
    /// Whether glass effects are globally enabled.
    @Published public var isEnabled: Bool = true
    
    /// Global intensity multiplier.
    @Published public var intensity: CGFloat = 1.0
    
    /// Preferred color scheme.
    @Published public var colorScheme: GlassColorScheme = .auto
    
    /// Whether reduced motion is preferred.
    @Published public var reducedMotion: Bool = false
    
    /// Whether to use high contrast mode.
    @Published public var highContrast: Bool = false
    
    private init() {
        observeAccessibilitySettings()
    }
    
    private func observeAccessibilitySettings() {
        #if os(iOS)
        reducedMotion = UIAccessibility.isReduceMotionEnabled
        highContrast = UIAccessibility.isDarkerSystemColorsEnabled
        
        NotificationCenter.default.addObserver(
            forName: UIAccessibility.reduceMotionStatusDidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.reducedMotion = UIAccessibility.isReduceMotionEnabled
        }
        
        NotificationCenter.default.addObserver(
            forName: UIAccessibility.darkerSystemColorsStatusDidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.highContrast = UIAccessibility.isDarkerSystemColorsEnabled
        }
        #endif
    }
    
    /// Applies the context to a view's environment.
    public func apply<V: View>(to view: V) -> some View {
        view
            .environment(\.glassStyle, style)
            .environment(\.glassEffectsEnabled, isEnabled)
            .environment(\.glassIntensity, intensity)
            .environment(\.glassColorScheme, colorScheme)
    }
}

// MARK: - View Extensions

public extension View {
    /// Sets the glass style for this view and its descendants.
    func glassStyle(_ style: GlassStyle) -> some View {
        environment(\.glassStyle, style)
    }
    
    /// Enables or disables glass effects.
    func glassEffectsEnabled(_ enabled: Bool) -> some View {
        environment(\.glassEffectsEnabled, enabled)
    }
    
    /// Sets the global glass intensity multiplier.
    func glassIntensity(_ intensity: CGFloat) -> some View {
        environment(\.glassIntensity, intensity)
    }
    
    /// Sets the preferred glass color scheme.
    func glassColorScheme(_ scheme: GlassColorScheme) -> some View {
        environment(\.glassColorScheme, scheme)
    }
    
    /// Sets the default animation for glass effects.
    func glassAnimation(_ animation: Animation) -> some View {
        environment(\.glassAnimation, animation)
    }
    
    /// Applies the shared glass context to this view.
    func withGlassContext() -> some View {
        GlassContext.shared.apply(to: self)
    }
    
    /// Reports this view's size via preferences.
    func reportGlassSize() -> some View {
        background(
            GeometryReader { geometry in
                Color.clear
                    .preference(key: GlassSizePreferenceKey.self, value: geometry.size)
            }
        )
    }
    
    /// Reports this view's frame via preferences.
    func reportGlassFrame(coordinateSpace: CoordinateSpace = .global) -> some View {
        background(
            GeometryReader { geometry in
                Color.clear
                    .preference(key: GlassFramePreferenceKey.self, value: geometry.frame(in: coordinateSpace))
            }
        )
    }
    
    /// Reads the reported glass size.
    func onGlassSizeChange(_ action: @escaping (CGSize) -> Void) -> some View {
        onPreferenceChange(GlassSizePreferenceKey.self, perform: action)
    }
    
    /// Reads the reported glass frame.
    func onGlassFrameChange(_ action: @escaping (CGRect) -> Void) -> some View {
        onPreferenceChange(GlassFramePreferenceKey.self, perform: action)
    }
}

// MARK: - Styled Glass View Modifier

/// A view modifier that applies the current glass style from the environment.
public struct StyledGlassModifier: ViewModifier {
    @Environment(\.glassStyle) private var style
    @Environment(\.glassEffectsEnabled) private var effectsEnabled
    @Environment(\.glassIntensity) private var intensity
    
    public init() {}
    
    public func body(content: Content) -> some View {
        if effectsEnabled {
            content
                .background(glassBackground)
                .clipShape(RoundedRectangle(cornerRadius: style.cornerRadius, style: .continuous))
                .overlay(borderOverlay)
                .shadow(
                    color: style.shadowColor.opacity(intensity),
                    radius: style.shadowRadius * intensity,
                    x: style.shadowOffset.width,
                    y: style.shadowOffset.height
                )
        } else {
            content
                .background(Color.secondary.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: style.cornerRadius, style: .continuous))
        }
    }
    
    private var glassBackground: some View {
        ZStack {
            Rectangle()
                .fill(.ultraThinMaterial)
                .opacity(style.blurIntensity * intensity)
            
            Rectangle()
                .fill(style.tintColor.opacity(style.tintOpacity * intensity))
            
            if style.showNoise {
                NoiseTextureView(
                    configuration: NoiseTextureConfiguration(
                        opacity: style.noiseOpacity * intensity
                    )
                )
            }
        }
    }
    
    private var borderOverlay: some View {
        RoundedRectangle(cornerRadius: style.cornerRadius, style: .continuous)
            .stroke(
                style.borderColor.opacity(intensity),
                lineWidth: style.borderWidth
            )
    }
}

public extension View {
    /// Applies the styled glass effect using environment values.
    func styledGlass() -> some View {
        modifier(StyledGlassModifier())
    }
}

// MARK: - Glass Provider View

/// A container view that provides glass configuration to its content.
public struct GlassProvider<Content: View>: View {
    @ObservedObject private var context: GlassContext
    private let content: () -> Content
    
    /// Creates a glass provider with the shared context.
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.context = GlassContext.shared
        self.content = content
    }
    
    /// Creates a glass provider with a custom context.
    public init(
        context: GlassContext,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.context = context
        self.content = content
    }
    
    public var body: some View {
        content()
            .environment(\.glassStyle, context.style)
            .environment(\.glassEffectsEnabled, context.isEnabled)
            .environment(\.glassIntensity, context.intensity)
            .environment(\.glassColorScheme, context.colorScheme)
    }
}

// MARK: - Conditional Glass Modifier

/// A modifier that conditionally applies glass styling.
public struct ConditionalGlassModifier: ViewModifier {
    let condition: Bool
    let style: GlassStyle
    
    public func body(content: Content) -> some View {
        if condition {
            content
                .glassStyle(style)
                .styledGlass()
        } else {
            content
        }
    }
}

public extension View {
    /// Conditionally applies glass styling.
    func glassIf(_ condition: Bool, style: GlassStyle = .standard) -> some View {
        modifier(ConditionalGlassModifier(condition: condition, style: style))
    }
}

// MARK: - Adaptive Glass Modifier

/// A modifier that adapts glass styling based on color scheme.
public struct AdaptiveGlassModifier: ViewModifier {
    @Environment(\.colorScheme) private var systemColorScheme
    @Environment(\.glassColorScheme) private var glassColorScheme
    
    let lightStyle: GlassStyle
    let darkStyle: GlassStyle
    
    private var effectiveStyle: GlassStyle {
        switch glassColorScheme {
        case .light:
            return lightStyle
        case .dark:
            return darkStyle
        case .auto:
            return systemColorScheme == .dark ? darkStyle : lightStyle
        }
    }
    
    public func body(content: Content) -> some View {
        content
            .glassStyle(effectiveStyle)
            .styledGlass()
    }
}

public extension View {
    /// Applies adaptive glass styling that changes based on color scheme.
    func adaptiveGlass(
        light: GlassStyle = .standard,
        dark: GlassStyle = .dark
    ) -> some View {
        modifier(AdaptiveGlassModifier(lightStyle: light, darkStyle: dark))
    }
}

// MARK: - Preview Provider

#if DEBUG
struct GlassEnvironment_Previews: PreviewProvider {
    static var previews: some View {
        GlassEnvironmentPreviewContainer()
    }
}

private struct GlassEnvironmentPreviewContainer: View {
    @State private var style: GlassStyle = .standard
    @State private var intensity: CGFloat = 1.0
    @State private var enabled = true
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.blue, .purple, .pink],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Text("Glass Environment")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                // Controls
                VStack(spacing: 12) {
                    Toggle("Effects Enabled", isOn: $enabled)
                    
                    HStack {
                        Text("Intensity")
                        Slider(value: $intensity, in: 0...1)
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal)
                
                // Sample cards with different styles
                VStack(spacing: 16) {
                    Text("Standard Style")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .glassStyle(.standard)
                        .styledGlass()
                    
                    Text("Minimal Style")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .glassStyle(.minimal)
                        .styledGlass()
                    
                    Text("Prominent Style")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .glassStyle(.prominent)
                        .styledGlass()
                    
                    Text("Adaptive Glass")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .adaptiveGlass()
                }
                .padding(.horizontal)
                .glassEffectsEnabled(enabled)
                .glassIntensity(intensity)
                
                Spacer()
            }
            .padding(.top, 40)
        }
    }
}
#endif
