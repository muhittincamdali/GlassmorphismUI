//
//  CustomThemes.swift
//  GlassmorphismUI
//
//  Pre-built theme configurations and a theming system for
//  consistent glassmorphism styling across an application.
//

import SwiftUI

// MARK: - Theme Protocol

/// Protocol defining the requirements for a glassmorphism theme.
public protocol GlassThemeProtocol: Sendable {
    /// Unique identifier for the theme
    var id: String { get }
    /// Display name of the theme
    var name: String { get }
    /// Primary blur intensity
    var blurIntensity: CGFloat { get }
    /// Primary tint color
    var tintColor: Color { get }
    /// Tint opacity
    var tintOpacity: CGFloat { get }
    /// Background gradient colors
    var backgroundColors: [Color] { get }
    /// Accent color for interactive elements
    var accentColor: Color { get }
    /// Primary text color
    var primaryTextColor: Color { get }
    /// Secondary text color
    var secondaryTextColor: Color { get }
    /// Border color
    var borderColor: Color { get }
    /// Border width
    var borderWidth: CGFloat { get }
    /// Default corner radius
    var cornerRadius: CGFloat { get }
    /// Shadow configuration
    var shadowColor: Color { get }
    var shadowRadius: CGFloat { get }
    var shadowOffset: CGSize { get }
    /// Whether to show noise texture
    var showNoiseTexture: Bool { get }
    /// Noise opacity
    var noiseOpacity: CGFloat { get }
}

// MARK: - Default Theme Implementation

/// Default implementation with sensible values.
public extension GlassThemeProtocol {
    var blurIntensity: CGFloat { 0.8 }
    var tintOpacity: CGFloat { 0.1 }
    var borderWidth: CGFloat { 0.5 }
    var cornerRadius: CGFloat { 16 }
    var shadowRadius: CGFloat { 15 }
    var shadowOffset: CGSize { CGSize(width: 0, height: 5) }
    var showNoiseTexture: Bool { true }
    var noiseOpacity: CGFloat { 0.03 }
}

// MARK: - Theme Struct

/// A concrete implementation of a glassmorphism theme.
public struct GlassThemeConfig: GlassThemeProtocol, Identifiable, Hashable {
    public let id: String
    public let name: String
    public var blurIntensity: CGFloat
    public var tintColor: Color
    public var tintOpacity: CGFloat
    public var backgroundColors: [Color]
    public var accentColor: Color
    public var primaryTextColor: Color
    public var secondaryTextColor: Color
    public var borderColor: Color
    public var borderWidth: CGFloat
    public var cornerRadius: CGFloat
    public var shadowColor: Color
    public var shadowRadius: CGFloat
    public var shadowOffset: CGSize
    public var showNoiseTexture: Bool
    public var noiseOpacity: CGFloat
    
    /// Creates a custom theme configuration.
    public init(
        id: String = UUID().uuidString,
        name: String,
        blurIntensity: CGFloat = 0.8,
        tintColor: Color = .white,
        tintOpacity: CGFloat = 0.1,
        backgroundColors: [Color] = [.blue, .purple],
        accentColor: Color = .blue,
        primaryTextColor: Color = .primary,
        secondaryTextColor: Color = .secondary,
        borderColor: Color = .white.opacity(0.3),
        borderWidth: CGFloat = 0.5,
        cornerRadius: CGFloat = 16,
        shadowColor: Color = .black.opacity(0.15),
        shadowRadius: CGFloat = 15,
        shadowOffset: CGSize = CGSize(width: 0, height: 5),
        showNoiseTexture: Bool = true,
        noiseOpacity: CGFloat = 0.03
    ) {
        self.id = id
        self.name = name
        self.blurIntensity = blurIntensity
        self.tintColor = tintColor
        self.tintOpacity = tintOpacity
        self.backgroundColors = backgroundColors
        self.accentColor = accentColor
        self.primaryTextColor = primaryTextColor
        self.secondaryTextColor = secondaryTextColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.cornerRadius = cornerRadius
        self.shadowColor = shadowColor
        self.shadowRadius = shadowRadius
        self.shadowOffset = shadowOffset
        self.showNoiseTexture = showNoiseTexture
        self.noiseOpacity = noiseOpacity
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: GlassThemeConfig, rhs: GlassThemeConfig) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Built-in Themes

/// Collection of pre-built glassmorphism themes.
public struct GlassThemes {
    
    // MARK: - Light Themes
    
    /// Clean, minimal light theme
    public static let light = GlassThemeConfig(
        id: "light",
        name: "Light",
        blurIntensity: 0.85,
        tintColor: .white,
        tintOpacity: 0.15,
        backgroundColors: [
            Color(red: 0.95, green: 0.97, blue: 1.0),
            Color(red: 0.9, green: 0.93, blue: 0.98)
        ],
        accentColor: .blue,
        primaryTextColor: .black,
        secondaryTextColor: Color(white: 0.4),
        borderColor: .white.opacity(0.5),
        shadowColor: .black.opacity(0.1)
    )
    
    /// Soft cream light theme
    public static let cream = GlassThemeConfig(
        id: "cream",
        name: "Cream",
        blurIntensity: 0.8,
        tintColor: Color(red: 1.0, green: 0.98, blue: 0.94),
        tintOpacity: 0.2,
        backgroundColors: [
            Color(red: 1.0, green: 0.97, blue: 0.92),
            Color(red: 0.98, green: 0.94, blue: 0.88)
        ],
        accentColor: Color(red: 0.85, green: 0.65, blue: 0.4),
        primaryTextColor: Color(red: 0.3, green: 0.25, blue: 0.2),
        secondaryTextColor: Color(red: 0.5, green: 0.45, blue: 0.4),
        borderColor: Color(red: 1.0, green: 0.95, blue: 0.85).opacity(0.6)
    )
    
    // MARK: - Dark Themes
    
    /// Sleek dark theme
    public static let dark = GlassThemeConfig(
        id: "dark",
        name: "Dark",
        blurIntensity: 0.7,
        tintColor: .black,
        tintOpacity: 0.3,
        backgroundColors: [
            Color(red: 0.1, green: 0.1, blue: 0.15),
            Color(red: 0.05, green: 0.05, blue: 0.1)
        ],
        accentColor: .cyan,
        primaryTextColor: .white,
        secondaryTextColor: Color(white: 0.7),
        borderColor: .white.opacity(0.1),
        shadowColor: .black.opacity(0.3)
    )
    
    /// Deep midnight theme
    public static let midnight = GlassThemeConfig(
        id: "midnight",
        name: "Midnight",
        blurIntensity: 0.75,
        tintColor: Color(red: 0.1, green: 0.1, blue: 0.2),
        tintOpacity: 0.25,
        backgroundColors: [
            Color(red: 0.08, green: 0.08, blue: 0.15),
            Color(red: 0.02, green: 0.02, blue: 0.08)
        ],
        accentColor: Color(red: 0.4, green: 0.6, blue: 1.0),
        primaryTextColor: .white,
        secondaryTextColor: Color(red: 0.6, green: 0.65, blue: 0.8),
        borderColor: Color(red: 0.3, green: 0.35, blue: 0.5).opacity(0.3)
    )
    
    // MARK: - Vibrant Themes
    
    /// Vibrant sunset theme
    public static let sunset = GlassThemeConfig(
        id: "sunset",
        name: "Sunset",
        blurIntensity: 0.85,
        tintColor: Color(red: 1.0, green: 0.6, blue: 0.4),
        tintOpacity: 0.1,
        backgroundColors: [
            Color(red: 1.0, green: 0.6, blue: 0.4),
            Color(red: 0.9, green: 0.3, blue: 0.5),
            Color(red: 0.6, green: 0.2, blue: 0.6)
        ],
        accentColor: Color(red: 1.0, green: 0.85, blue: 0.6),
        primaryTextColor: .white,
        secondaryTextColor: .white.opacity(0.8),
        borderColor: .white.opacity(0.3)
    )
    
    /// Ocean blue theme
    public static let ocean = GlassThemeConfig(
        id: "ocean",
        name: "Ocean",
        blurIntensity: 0.8,
        tintColor: Color(red: 0.2, green: 0.6, blue: 0.8),
        tintOpacity: 0.12,
        backgroundColors: [
            Color(red: 0.1, green: 0.5, blue: 0.7),
            Color(red: 0.05, green: 0.3, blue: 0.5),
            Color(red: 0.02, green: 0.15, blue: 0.3)
        ],
        accentColor: Color(red: 0.4, green: 0.9, blue: 0.9),
        primaryTextColor: .white,
        secondaryTextColor: Color(red: 0.7, green: 0.9, blue: 0.95),
        borderColor: Color(red: 0.4, green: 0.8, blue: 0.9).opacity(0.3)
    )
    
    /// Forest green theme
    public static let forest = GlassThemeConfig(
        id: "forest",
        name: "Forest",
        blurIntensity: 0.75,
        tintColor: Color(red: 0.2, green: 0.4, blue: 0.3),
        tintOpacity: 0.15,
        backgroundColors: [
            Color(red: 0.15, green: 0.35, blue: 0.25),
            Color(red: 0.1, green: 0.25, blue: 0.18),
            Color(red: 0.05, green: 0.15, blue: 0.1)
        ],
        accentColor: Color(red: 0.6, green: 0.9, blue: 0.5),
        primaryTextColor: .white,
        secondaryTextColor: Color(red: 0.7, green: 0.85, blue: 0.75),
        borderColor: Color(red: 0.4, green: 0.6, blue: 0.45).opacity(0.3)
    )
    
    /// Aurora borealis theme
    public static let aurora = GlassThemeConfig(
        id: "aurora",
        name: "Aurora",
        blurIntensity: 0.85,
        tintColor: Color(red: 0.3, green: 0.8, blue: 0.6),
        tintOpacity: 0.08,
        backgroundColors: [
            Color(red: 0.1, green: 0.2, blue: 0.3),
            Color(red: 0.2, green: 0.5, blue: 0.4),
            Color(red: 0.4, green: 0.2, blue: 0.5),
            Color(red: 0.1, green: 0.15, blue: 0.25)
        ],
        accentColor: Color(red: 0.4, green: 1.0, blue: 0.7),
        primaryTextColor: .white,
        secondaryTextColor: Color(red: 0.7, green: 0.9, blue: 0.85),
        borderColor: Color(red: 0.5, green: 0.9, blue: 0.7).opacity(0.2)
    )
    
    /// Neon cyberpunk theme
    public static let neon = GlassThemeConfig(
        id: "neon",
        name: "Neon",
        blurIntensity: 0.7,
        tintColor: Color(red: 0.1, green: 0.05, blue: 0.15),
        tintOpacity: 0.3,
        backgroundColors: [
            Color(red: 0.08, green: 0.02, blue: 0.12),
            Color(red: 0.05, green: 0.0, blue: 0.1)
        ],
        accentColor: Color(red: 1.0, green: 0.2, blue: 0.6),
        primaryTextColor: .white,
        secondaryTextColor: Color(red: 0.8, green: 0.7, blue: 0.9),
        borderColor: Color(red: 1.0, green: 0.3, blue: 0.8).opacity(0.4),
        borderWidth: 1.0,
        shadowColor: Color(red: 1.0, green: 0.2, blue: 0.6).opacity(0.3),
        shadowRadius: 20
    )
    
    // MARK: - Minimalist Themes
    
    /// Pure monochrome theme
    public static let monochrome = GlassThemeConfig(
        id: "monochrome",
        name: "Monochrome",
        blurIntensity: 0.9,
        tintColor: .gray,
        tintOpacity: 0.08,
        backgroundColors: [
            Color(white: 0.95),
            Color(white: 0.85)
        ],
        accentColor: .black,
        primaryTextColor: .black,
        secondaryTextColor: Color(white: 0.4),
        borderColor: Color(white: 0.7),
        showNoiseTexture: false
    )
    
    /// Frosted glass theme
    public static let frosted = GlassThemeConfig(
        id: "frosted",
        name: "Frosted",
        blurIntensity: 0.95,
        tintColor: .white,
        tintOpacity: 0.2,
        backgroundColors: [
            Color(red: 0.9, green: 0.92, blue: 0.95),
            Color(red: 0.85, green: 0.88, blue: 0.92)
        ],
        accentColor: Color(red: 0.3, green: 0.5, blue: 0.8),
        primaryTextColor: Color(red: 0.2, green: 0.25, blue: 0.3),
        secondaryTextColor: Color(red: 0.4, green: 0.45, blue: 0.5),
        borderColor: .white.opacity(0.6),
        noiseOpacity: 0.05
    )
    
    // MARK: - Seasonal Themes
    
    /// Spring blossom theme
    public static let spring = GlassThemeConfig(
        id: "spring",
        name: "Spring",
        blurIntensity: 0.8,
        tintColor: Color(red: 1.0, green: 0.85, blue: 0.9),
        tintOpacity: 0.12,
        backgroundColors: [
            Color(red: 1.0, green: 0.9, blue: 0.95),
            Color(red: 0.9, green: 0.95, blue: 0.85),
            Color(red: 0.85, green: 0.95, blue: 0.9)
        ],
        accentColor: Color(red: 0.95, green: 0.5, blue: 0.6),
        primaryTextColor: Color(red: 0.3, green: 0.25, blue: 0.28),
        secondaryTextColor: Color(red: 0.5, green: 0.45, blue: 0.48),
        borderColor: Color(red: 1.0, green: 0.8, blue: 0.85).opacity(0.5)
    )
    
    /// Winter frost theme
    public static let winter = GlassThemeConfig(
        id: "winter",
        name: "Winter",
        blurIntensity: 0.9,
        tintColor: Color(red: 0.85, green: 0.92, blue: 1.0),
        tintOpacity: 0.15,
        backgroundColors: [
            Color(red: 0.7, green: 0.85, blue: 0.95),
            Color(red: 0.5, green: 0.7, blue: 0.85),
            Color(red: 0.4, green: 0.55, blue: 0.7)
        ],
        accentColor: Color(red: 0.3, green: 0.7, blue: 0.9),
        primaryTextColor: .white,
        secondaryTextColor: Color(red: 0.85, green: 0.9, blue: 0.95),
        borderColor: .white.opacity(0.4),
        noiseOpacity: 0.04
    )
    
    // MARK: - All Themes
    
    /// Collection of all built-in themes
    public static let all: [GlassThemeConfig] = [
        light, cream, dark, midnight,
        sunset, ocean, forest, aurora, neon,
        monochrome, frosted,
        spring, winter
    ]
    
    /// Returns themes suitable for light mode
    public static var lightThemes: [GlassThemeConfig] {
        [light, cream, monochrome, frosted, spring]
    }
    
    /// Returns themes suitable for dark mode
    public static var darkThemes: [GlassThemeConfig] {
        [dark, midnight, neon]
    }
    
    /// Returns vibrant/colorful themes
    public static var vibrantThemes: [GlassThemeConfig] {
        [sunset, ocean, forest, aurora, winter]
    }
}

// MARK: - Theme Manager

/// Observable object for managing the current theme.
@MainActor
public final class GlassThemeManager: ObservableObject {
    /// Shared instance for global theme management
    public static let shared = GlassThemeManager()
    
    /// The currently active theme
    @Published public var currentTheme: GlassThemeConfig
    
    /// Whether to automatically adapt to system appearance
    @Published public var adaptToSystemAppearance: Bool = true
    
    /// Available themes
    @Published public var availableThemes: [GlassThemeConfig]
    
    /// Animation for theme transitions
    public var transitionAnimation: Animation = .easeInOut(duration: 0.3)
    
    private init() {
        self.currentTheme = GlassThemes.light
        self.availableThemes = GlassThemes.all
    }
    
    /// Sets the current theme with animation.
    /// - Parameter theme: The theme to apply
    public func setTheme(_ theme: GlassThemeConfig) {
        withAnimation(transitionAnimation) {
            currentTheme = theme
        }
    }
    
    /// Adds a custom theme to available themes.
    /// - Parameter theme: The theme to add
    public func addCustomTheme(_ theme: GlassThemeConfig) {
        if !availableThemes.contains(theme) {
            availableThemes.append(theme)
        }
    }
    
    /// Removes a theme from available themes.
    /// - Parameter theme: The theme to remove
    public func removeTheme(_ theme: GlassThemeConfig) {
        availableThemes.removeAll { $0.id == theme.id }
    }
    
    /// Returns a theme for the given color scheme.
    /// - Parameter colorScheme: The system color scheme
    public func theme(for colorScheme: ColorScheme) -> GlassThemeConfig {
        switch colorScheme {
        case .light:
            return GlassThemes.light
        case .dark:
            return GlassThemes.dark
        @unknown default:
            return GlassThemes.light
        }
    }
}

// MARK: - Theme Environment Key

private struct GlassThemeKey: EnvironmentKey {
    static let defaultValue: GlassThemeConfig = GlassThemes.light
}

public extension EnvironmentValues {
    /// The current glass theme.
    var glassTheme: GlassThemeConfig {
        get { self[GlassThemeKey.self] }
        set { self[GlassThemeKey.self] = newValue }
    }
}

// MARK: - View Extensions

public extension View {
    /// Applies a glass theme to this view and its descendants.
    /// - Parameter theme: The theme to apply
    func glassTheme(_ theme: GlassThemeConfig) -> some View {
        environment(\.glassTheme, theme)
    }
    
    /// Applies the themed glass background.
    /// - Parameter theme: Optional specific theme (uses environment theme if nil)
    func themedGlassBackground(_ theme: GlassThemeConfig? = nil) -> some View {
        modifier(ThemedGlassBackgroundModifier(customTheme: theme))
    }
}

// MARK: - Themed Background Modifier

private struct ThemedGlassBackgroundModifier: ViewModifier {
    @Environment(\.glassTheme) private var environmentTheme
    let customTheme: GlassThemeConfig?
    
    private var theme: GlassThemeConfig {
        customTheme ?? environmentTheme
    }
    
    func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    // Material blur
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .opacity(theme.blurIntensity)
                    
                    // Tint overlay
                    Rectangle()
                        .fill(theme.tintColor.opacity(theme.tintOpacity))
                    
                    // Noise texture
                    if theme.showNoiseTexture {
                        NoiseTextureView(
                            configuration: NoiseTextureConfiguration(
                                opacity: theme.noiseOpacity
                            )
                        )
                    }
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: theme.cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: theme.cornerRadius, style: .continuous)
                    .stroke(theme.borderColor, lineWidth: theme.borderWidth)
            )
            .shadow(
                color: theme.shadowColor,
                radius: theme.shadowRadius,
                x: theme.shadowOffset.width,
                y: theme.shadowOffset.height
            )
    }
}

// MARK: - Theme Picker View

/// A view for selecting themes.
public struct GlassThemePicker: View {
    @Binding private var selection: GlassThemeConfig
    private let themes: [GlassThemeConfig]
    private let columns: Int
    
    /// Creates a theme picker.
    /// - Parameters:
    ///   - selection: Binding to the selected theme
    ///   - themes: Available themes to display
    ///   - columns: Number of columns in the grid
    public init(
        selection: Binding<GlassThemeConfig>,
        themes: [GlassThemeConfig] = GlassThemes.all,
        columns: Int = 3
    ) {
        self._selection = selection
        self.themes = themes
        self.columns = columns
    }
    
    public var body: some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: columns),
            spacing: 12
        ) {
            ForEach(themes) { theme in
                themePreview(theme)
            }
        }
    }
    
    private func themePreview(_ theme: GlassThemeConfig) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                selection = theme
            }
        } label: {
            VStack(spacing: 8) {
                // Theme preview
                ZStack {
                    // Background gradient
                    LinearGradient(
                        colors: theme.backgroundColors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    
                    // Glass card preview
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(theme.tintColor.opacity(theme.tintOpacity + 0.1))
                        .frame(width: 50, height: 30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .stroke(theme.borderColor, lineWidth: 1)
                        )
                }
                .frame(height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(
                            selection.id == theme.id ? theme.accentColor : Color.clear,
                            lineWidth: 2
                        )
                )
                
                // Theme name
                Text(theme.name)
                    .font(.caption)
                    .foregroundColor(selection.id == theme.id ? theme.accentColor : .secondary)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview Provider

#if DEBUG
struct CustomThemes_Previews: PreviewProvider {
    static var previews: some View {
        CustomThemesPreviewContainer()
    }
}

private struct CustomThemesPreviewContainer: View {
    @State private var selectedTheme = GlassThemes.light
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Glass Themes")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(selectedTheme.primaryTextColor)
                
                // Theme picker
                GlassThemePicker(selection: $selectedTheme)
                    .padding(.horizontal)
                
                // Sample card with theme
                VStack(spacing: 12) {
                    Text("Sample Card")
                        .font(.headline)
                        .foregroundColor(selectedTheme.primaryTextColor)
                    
                    Text("This card uses the selected theme")
                        .font(.subheadline)
                        .foregroundColor(selectedTheme.secondaryTextColor)
                    
                    Button("Action") {}
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(selectedTheme.accentColor)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
                .padding(24)
                .themedGlassBackground(selectedTheme)
                .padding(.horizontal)
                
                Spacer(minLength: 50)
            }
            .padding(.top, 20)
        }
        .background(
            LinearGradient(
                colors: selectedTheme.backgroundColors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
        .animation(.easeInOut(duration: 0.3), value: selectedTheme)
        .glassTheme(selectedTheme)
    }
}
#endif
