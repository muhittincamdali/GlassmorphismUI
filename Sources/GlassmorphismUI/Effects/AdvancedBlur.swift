//
//  AdvancedBlur.swift
//  GlassmorphismUI
//
//  Advanced blur effects including variable blur, directional blur,
//  and custom blur kernels for sophisticated glassmorphism effects.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

// MARK: - Blur Style

/// Available blur effect styles.
public enum GlassBlurStyle: String, CaseIterable, Sendable {
    /// Standard Gaussian blur
    case gaussian
    /// Box blur for performance
    case box
    /// Motion blur effect
    case motion
    /// Zoom/radial blur effect
    case zoom
    /// Variable blur with gradient
    case variable
    /// Frosted glass appearance
    case frosted
    /// Crystal clear with minimal blur
    case crystal
}

// MARK: - Blur Configuration

/// Configuration options for advanced blur effects.
public struct AdvancedBlurConfiguration: Sendable {
    /// The blur radius in points
    public var radius: CGFloat
    /// The blur style to use
    public var style: GlassBlurStyle
    /// Opacity of the blur effect (0.0 - 1.0)
    public var opacity: CGFloat
    /// Saturation adjustment (-1.0 to 1.0, 0 is neutral)
    public var saturation: CGFloat
    /// Brightness adjustment (-1.0 to 1.0, 0 is neutral)
    public var brightness: CGFloat
    /// Contrast adjustment (0.0 to 2.0, 1.0 is neutral)
    public var contrast: CGFloat
    /// Tint color overlay
    public var tintColor: Color?
    /// Tint opacity
    public var tintOpacity: CGFloat
    /// Whether to respect safe area
    public var respectsSafeArea: Bool
    /// Animation for blur transitions
    public var animation: Animation?
    
    /// Creates a new blur configuration.
    public init(
        radius: CGFloat = 20,
        style: GlassBlurStyle = .gaussian,
        opacity: CGFloat = 1.0,
        saturation: CGFloat = 0,
        brightness: CGFloat = 0,
        contrast: CGFloat = 1.0,
        tintColor: Color? = nil,
        tintOpacity: CGFloat = 0.1,
        respectsSafeArea: Bool = false,
        animation: Animation? = nil
    ) {
        self.radius = radius
        self.style = style
        self.opacity = opacity
        self.saturation = saturation
        self.brightness = brightness
        self.contrast = contrast
        self.tintColor = tintColor
        self.tintOpacity = tintOpacity
        self.respectsSafeArea = respectsSafeArea
        self.animation = animation
    }
    
    /// Light blur preset
    public static var light: AdvancedBlurConfiguration {
        AdvancedBlurConfiguration(radius: 10, opacity: 0.8)
    }
    
    /// Regular blur preset
    public static var regular: AdvancedBlurConfiguration {
        AdvancedBlurConfiguration(radius: 20, opacity: 1.0)
    }
    
    /// Heavy blur preset
    public static var heavy: AdvancedBlurConfiguration {
        AdvancedBlurConfiguration(radius: 40, opacity: 1.0)
    }
    
    /// Frosted glass preset
    public static var frosted: AdvancedBlurConfiguration {
        AdvancedBlurConfiguration(
            radius: 25,
            style: .frosted,
            saturation: 0.2,
            tintColor: .white,
            tintOpacity: 0.15
        )
    }
    
    /// Dark glass preset
    public static var dark: AdvancedBlurConfiguration {
        AdvancedBlurConfiguration(
            radius: 30,
            saturation: -0.1,
            brightness: -0.1,
            tintColor: .black,
            tintOpacity: 0.2
        )
    }
}

// MARK: - Advanced Blur View

/// A view that applies advanced blur effects.
public struct AdvancedBlurView: View {
    private let configuration: AdvancedBlurConfiguration
    
    /// Creates an advanced blur view.
    /// - Parameter configuration: The blur configuration
    public init(configuration: AdvancedBlurConfiguration = .regular) {
        self.configuration = configuration
    }
    
    public var body: some View {
        ZStack {
            // Base blur layer
            blurLayer
            
            // Color adjustments
            adjustmentLayer
            
            // Tint overlay
            if let tintColor = configuration.tintColor {
                tintColor
                    .opacity(configuration.tintOpacity)
            }
        }
        .opacity(configuration.opacity)
    }
    
    @ViewBuilder
    private var blurLayer: some View {
        switch configuration.style {
        case .gaussian, .box:
            Rectangle()
                .fill(.ultraThinMaterial)
                .blur(radius: configuration.radius * 0.5)
            
        case .motion:
            motionBlurLayer
            
        case .zoom:
            zoomBlurLayer
            
        case .variable:
            variableBlurLayer
            
        case .frosted:
            frostedBlurLayer
            
        case .crystal:
            crystalBlurLayer
        }
    }
    
    private var motionBlurLayer: some View {
        ZStack {
            ForEach(0..<5) { index in
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .offset(x: CGFloat(index - 2) * configuration.radius * 0.2)
                    .opacity(0.2)
            }
        }
    }
    
    private var zoomBlurLayer: some View {
        ZStack {
            ForEach(0..<5) { index in
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .scaleEffect(1.0 + CGFloat(index) * 0.02)
                    .opacity(0.2)
            }
        }
    }
    
    private var variableBlurLayer: some View {
        ZStack {
            Rectangle()
                .fill(.ultraThinMaterial)
            
            LinearGradient(
                colors: [.clear, .white.opacity(0.1)],
                startPoint: .top,
                endPoint: .bottom
            )
            .blendMode(.overlay)
        }
    }
    
    private var frostedBlurLayer: some View {
        ZStack {
            Rectangle()
                .fill(.ultraThinMaterial)
            
            // Noise texture overlay for frosted effect
            NoiseLayer(opacity: 0.03, scale: 1.0)
            
            // Subtle gradient
            LinearGradient(
                colors: [
                    Color.white.opacity(0.1),
                    Color.white.opacity(0.05)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    private var crystalBlurLayer: some View {
        ZStack {
            Rectangle()
                .fill(.thinMaterial)
            
            // Refraction effect
            LinearGradient(
                colors: [
                    Color.white.opacity(0.15),
                    Color.clear,
                    Color.white.opacity(0.1)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    private var adjustmentLayer: some View {
        Rectangle()
            .fill(Color.clear)
            .saturation(1.0 + configuration.saturation)
            .brightness(configuration.brightness)
            .contrast(configuration.contrast)
    }
}

// MARK: - Noise Layer (Internal)

private struct NoiseLayer: View {
    let opacity: CGFloat
    let scale: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            Canvas { context, size in
                // Generate noise pattern
                for x in stride(from: 0, to: size.width, by: scale) {
                    for y in stride(from: 0, to: size.height, by: scale) {
                        let brightness = CGFloat.random(in: 0...1)
                        let rect = CGRect(x: x, y: y, width: scale, height: scale)
                        context.fill(
                            Path(rect),
                            with: .color(Color.white.opacity(brightness * opacity))
                        )
                    }
                }
            }
        }
    }
}

// MARK: - Variable Blur Modifier

/// A modifier that applies variable blur based on position.
public struct VariableBlurModifier: ViewModifier {
    /// Direction of the blur gradient
    public enum Direction {
        case topToBottom
        case bottomToTop
        case leadingToTrailing
        case trailingToLeading
        case radialFromCenter
        case radialToCenter
    }
    
    private let direction: Direction
    private let minRadius: CGFloat
    private let maxRadius: CGFloat
    private let opacity: CGFloat
    
    /// Creates a variable blur modifier.
    /// - Parameters:
    ///   - direction: Direction of blur intensity change
    ///   - minRadius: Minimum blur radius
    ///   - maxRadius: Maximum blur radius
    ///   - opacity: Overall opacity of the effect
    public init(
        direction: Direction = .topToBottom,
        minRadius: CGFloat = 0,
        maxRadius: CGFloat = 20,
        opacity: CGFloat = 1.0
    ) {
        self.direction = direction
        self.minRadius = minRadius
        self.maxRadius = maxRadius
        self.opacity = opacity
    }
    
    public func body(content: Content) -> some View {
        content
            .overlay(
                VariableBlurOverlay(
                    direction: direction,
                    minRadius: minRadius,
                    maxRadius: maxRadius
                )
                .opacity(opacity)
            )
    }
}

// MARK: - Variable Blur Overlay

private struct VariableBlurOverlay: View {
    let direction: VariableBlurModifier.Direction
    let minRadius: CGFloat
    let maxRadius: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Create layered blur effect
                ForEach(0..<10) { index in
                    let progress = CGFloat(index) / 9.0
                    let radius = minRadius + (maxRadius - minRadius) * progress
                    
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .blur(radius: radius)
                        .mask(gradientMask(progress: progress, size: geometry.size))
                }
            }
        }
    }
    
    @ViewBuilder
    private func gradientMask(progress: CGFloat, size: CGSize) -> some View {
        switch direction {
        case .topToBottom:
            LinearGradient(
                stops: [
                    .init(color: .clear, location: max(0, progress - 0.1)),
                    .init(color: .white, location: progress),
                    .init(color: .clear, location: min(1, progress + 0.1))
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            
        case .bottomToTop:
            LinearGradient(
                stops: [
                    .init(color: .clear, location: max(0, progress - 0.1)),
                    .init(color: .white, location: progress),
                    .init(color: .clear, location: min(1, progress + 0.1))
                ],
                startPoint: .bottom,
                endPoint: .top
            )
            
        case .leadingToTrailing:
            LinearGradient(
                stops: [
                    .init(color: .clear, location: max(0, progress - 0.1)),
                    .init(color: .white, location: progress),
                    .init(color: .clear, location: min(1, progress + 0.1))
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
            
        case .trailingToLeading:
            LinearGradient(
                stops: [
                    .init(color: .clear, location: max(0, progress - 0.1)),
                    .init(color: .white, location: progress),
                    .init(color: .clear, location: min(1, progress + 0.1))
                ],
                startPoint: .trailing,
                endPoint: .leading
            )
            
        case .radialFromCenter:
            RadialGradient(
                stops: [
                    .init(color: .clear, location: max(0, progress - 0.1)),
                    .init(color: .white, location: progress),
                    .init(color: .clear, location: min(1, progress + 0.1))
                ],
                center: .center,
                startRadius: 0,
                endRadius: max(size.width, size.height) / 2
            )
            
        case .radialToCenter:
            RadialGradient(
                stops: [
                    .init(color: .white, location: max(0, 1 - progress - 0.1)),
                    .init(color: .clear, location: 1 - progress),
                    .init(color: .clear, location: 1)
                ],
                center: .center,
                startRadius: 0,
                endRadius: max(size.width, size.height) / 2
            )
        }
    }
}

// MARK: - Animated Blur Modifier

/// A modifier that animates blur based on a binding.
public struct AnimatedBlurModifier: ViewModifier {
    @Binding private var isBlurred: Bool
    private let blurRadius: CGFloat
    private let animation: Animation
    
    /// Creates an animated blur modifier.
    /// - Parameters:
    ///   - isBlurred: Binding controlling blur state
    ///   - blurRadius: The blur radius when active
    ///   - animation: Animation for blur transitions
    public init(
        isBlurred: Binding<Bool>,
        blurRadius: CGFloat = 20,
        animation: Animation = .easeInOut(duration: 0.3)
    ) {
        self._isBlurred = isBlurred
        self.blurRadius = blurRadius
        self.animation = animation
    }
    
    public func body(content: Content) -> some View {
        content
            .blur(radius: isBlurred ? blurRadius : 0)
            .animation(animation, value: isBlurred)
    }
}

// MARK: - Blur Behind Modifier

/// A modifier that applies blur to the background behind a view.
public struct BlurBehindModifier: ViewModifier {
    private let configuration: AdvancedBlurConfiguration
    
    /// Creates a blur behind modifier.
    /// - Parameter configuration: The blur configuration
    public init(configuration: AdvancedBlurConfiguration = .regular) {
        self.configuration = configuration
    }
    
    public func body(content: Content) -> some View {
        content
            .background(
                AdvancedBlurView(configuration: configuration)
            )
    }
}

// MARK: - Morphing Blur Effect

/// A view that creates a morphing, animated blur effect.
public struct MorphingBlurView: View {
    private let colors: [Color]
    private let blurRadius: CGFloat
    private let animationDuration: Double
    
    @State private var phase: CGFloat = 0
    
    /// Creates a morphing blur view.
    /// - Parameters:
    ///   - colors: Colors for the morphing effect
    ///   - blurRadius: The blur radius
    ///   - animationDuration: Duration of one animation cycle
    public init(
        colors: [Color] = [.blue, .purple, .pink],
        blurRadius: CGFloat = 60,
        animationDuration: Double = 5.0
    ) {
        self.colors = colors
        self.blurRadius = blurRadius
        self.animationDuration = animationDuration
    }
    
    public var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let timeInterval = timeline.date.timeIntervalSinceReferenceDate
                let phase = timeInterval.truncatingRemainder(dividingBy: animationDuration) / animationDuration
                
                // Draw morphing blobs
                for (index, color) in colors.enumerated() {
                    let offset = CGFloat(index) / CGFloat(colors.count)
                    let adjustedPhase = (phase + offset).truncatingRemainder(dividingBy: 1.0)
                    
                    let x = size.width * (0.3 + 0.4 * sin(adjustedPhase * .pi * 2))
                    let y = size.height * (0.3 + 0.4 * cos(adjustedPhase * .pi * 2 + .pi / 3))
                    let radius = min(size.width, size.height) * 0.3
                    
                    let circle = Path(ellipseIn: CGRect(
                        x: x - radius,
                        y: y - radius,
                        width: radius * 2,
                        height: radius * 2
                    ))
                    
                    context.fill(circle, with: .color(color.opacity(0.6)))
                }
            }
            .blur(radius: blurRadius)
        }
    }
}

// MARK: - Depth Blur Effect

/// A view that creates a depth-based blur effect.
public struct DepthBlurView: View {
    private let layers: Int
    private let maxBlur: CGFloat
    private let baseColor: Color
    
    /// Creates a depth blur view.
    /// - Parameters:
    ///   - layers: Number of blur layers
    ///   - maxBlur: Maximum blur radius
    ///   - baseColor: Base color for the effect
    public init(
        layers: Int = 5,
        maxBlur: CGFloat = 30,
        baseColor: Color = .white
    ) {
        self.layers = layers
        self.maxBlur = maxBlur
        self.baseColor = baseColor
    }
    
    public var body: some View {
        ZStack {
            ForEach(0..<layers, id: \.self) { index in
                let progress = CGFloat(index) / CGFloat(layers - 1)
                let blur = maxBlur * progress
                let opacity = 1.0 - progress * 0.7
                
                Rectangle()
                    .fill(baseColor.opacity(0.1 * opacity))
                    .blur(radius: blur)
            }
        }
    }
}

// MARK: - View Extensions

public extension View {
    /// Applies an advanced blur effect.
    /// - Parameter configuration: The blur configuration
    func advancedBlur(_ configuration: AdvancedBlurConfiguration = .regular) -> some View {
        self.background(AdvancedBlurView(configuration: configuration))
    }
    
    /// Applies a variable blur effect.
    /// - Parameters:
    ///   - direction: Direction of blur intensity change
    ///   - minRadius: Minimum blur radius
    ///   - maxRadius: Maximum blur radius
    func variableBlur(
        direction: VariableBlurModifier.Direction = .topToBottom,
        minRadius: CGFloat = 0,
        maxRadius: CGFloat = 20
    ) -> some View {
        modifier(VariableBlurModifier(
            direction: direction,
            minRadius: minRadius,
            maxRadius: maxRadius
        ))
    }
    
    /// Applies an animated blur effect.
    /// - Parameters:
    ///   - isBlurred: Binding controlling blur state
    ///   - radius: The blur radius when active
    ///   - animation: Animation for blur transitions
    func animatedBlur(
        isBlurred: Binding<Bool>,
        radius: CGFloat = 20,
        animation: Animation = .easeInOut(duration: 0.3)
    ) -> some View {
        modifier(AnimatedBlurModifier(
            isBlurred: isBlurred,
            blurRadius: radius,
            animation: animation
        ))
    }
    
    /// Applies blur to the background behind this view.
    /// - Parameter configuration: The blur configuration
    func blurBehind(_ configuration: AdvancedBlurConfiguration = .regular) -> some View {
        modifier(BlurBehindModifier(configuration: configuration))
    }
    
    /// Applies a frosted glass blur effect.
    /// - Parameters:
    ///   - radius: The blur radius
    ///   - tint: Optional tint color
    func frostedBlur(radius: CGFloat = 25, tint: Color? = .white) -> some View {
        var config = AdvancedBlurConfiguration.frosted
        config.radius = radius
        config.tintColor = tint
        return advancedBlur(config)
    }
}

// MARK: - Preview Provider

#if DEBUG
struct AdvancedBlur_Previews: PreviewProvider {
    static var previews: some View {
        AdvancedBlurPreviewContainer()
    }
}

private struct AdvancedBlurPreviewContainer: View {
    @State private var isBlurred = false
    
    var body: some View {
        ZStack {
            // Background image simulation
            LinearGradient(
                colors: [.red, .orange, .yellow, .green, .blue, .purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Morphing blur
                MorphingBlurView()
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay(
                        Text("Morphing Blur")
                            .font(.headline)
                            .foregroundColor(.white)
                    )
                
                // Frosted blur card
                VStack {
                    Text("Frosted Glass")
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text("Advanced blur effects")
                        .foregroundColor(.secondary)
                }
                .padding(30)
                .frostedBlur()
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                // Animated blur toggle
                Button("Toggle Blur") {
                    isBlurred.toggle()
                }
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(Capsule())
                
                // Depth blur
                DepthBlurView()
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding()
            .animatedBlur(isBlurred: $isBlurred)
        }
    }
}
#endif
