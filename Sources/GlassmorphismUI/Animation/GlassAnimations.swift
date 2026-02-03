//
//  GlassAnimations.swift
//  GlassmorphismUI
//
//  A collection of pre-built animations and transitions designed
//  specifically for glassmorphism UI components.
//

import SwiftUI

// MARK: - Animation Presets

/// Pre-built animation presets optimized for glass effects.
public struct GlassAnimationPresets {
    
    // MARK: - Spring Animations
    
    /// Smooth spring animation for general use
    public static let smooth = Animation.spring(response: 0.35, dampingFraction: 0.85)
    
    /// Bouncy spring for playful interactions
    public static let bouncy = Animation.spring(response: 0.4, dampingFraction: 0.6)
    
    /// Snappy spring for quick feedback
    public static let snappy = Animation.spring(response: 0.25, dampingFraction: 0.9)
    
    /// Gentle spring for subtle movements
    public static let gentle = Animation.spring(response: 0.5, dampingFraction: 0.8)
    
    /// Heavy spring with more momentum
    public static let heavy = Animation.spring(response: 0.6, dampingFraction: 0.7)
    
    // MARK: - Easing Animations
    
    /// Standard ease-in-out
    public static let standard = Animation.easeInOut(duration: 0.3)
    
    /// Fast ease for quick transitions
    public static let fast = Animation.easeInOut(duration: 0.15)
    
    /// Slow ease for dramatic reveals
    public static let slow = Animation.easeInOut(duration: 0.5)
    
    /// Ease-out for natural deceleration
    public static let easeOut = Animation.easeOut(duration: 0.3)
    
    /// Ease-in for anticipation
    public static let easeIn = Animation.easeIn(duration: 0.3)
    
    // MARK: - Specialized Animations
    
    /// Animation for blur transitions
    public static let blur = Animation.easeInOut(duration: 0.4)
    
    /// Animation for opacity fades
    public static let fade = Animation.easeInOut(duration: 0.25)
    
    /// Animation for scale transforms
    public static let scale = Animation.spring(response: 0.3, dampingFraction: 0.75)
    
    /// Animation for sheet presentations
    public static let sheet = Animation.spring(response: 0.35, dampingFraction: 0.8)
    
    /// Animation for menu reveals
    public static let menu = Animation.spring(response: 0.3, dampingFraction: 0.85)
}

// MARK: - Transition Presets

/// Pre-built transitions for glass components.
public struct GlassTransitions {
    
    /// Fade with scale transition
    public static var fadeScale: AnyTransition {
        .asymmetric(
            insertion: .scale(scale: 0.95).combined(with: .opacity),
            removal: .scale(scale: 0.95).combined(with: .opacity)
        )
    }
    
    /// Slide up with fade
    public static var slideUp: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .bottom).combined(with: .opacity),
            removal: .move(edge: .bottom).combined(with: .opacity)
        )
    }
    
    /// Slide down with fade
    public static var slideDown: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .top).combined(with: .opacity),
            removal: .move(edge: .top).combined(with: .opacity)
        )
    }
    
    /// Scale from center
    public static var scaleFromCenter: AnyTransition {
        .scale(scale: 0.8, anchor: .center).combined(with: .opacity)
    }
    
    /// Blur transition
    public static var blur: AnyTransition {
        .modifier(
            active: BlurTransitionModifier(isActive: true),
            identity: BlurTransitionModifier(isActive: false)
        )
    }
    
    /// Glass reveal transition
    public static var glassReveal: AnyTransition {
        .asymmetric(
            insertion: .modifier(
                active: GlassRevealModifier(progress: 0),
                identity: GlassRevealModifier(progress: 1)
            ),
            removal: .modifier(
                active: GlassRevealModifier(progress: 0),
                identity: GlassRevealModifier(progress: 1)
            )
        )
    }
}

// MARK: - Blur Transition Modifier

private struct BlurTransitionModifier: ViewModifier {
    let isActive: Bool
    
    func body(content: Content) -> some View {
        content
            .blur(radius: isActive ? 10 : 0)
            .opacity(isActive ? 0 : 1)
    }
}

// MARK: - Glass Reveal Modifier

private struct GlassRevealModifier: ViewModifier {
    let progress: CGFloat
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(0.9 + 0.1 * progress)
            .opacity(progress)
            .blur(radius: (1 - progress) * 5)
    }
}

// MARK: - Shimmer Effect

/// A shimmer animation effect for loading states.
public struct ShimmerEffect: ViewModifier {
    @State private var phase: CGFloat = 0
    private let duration: Double
    private let color: Color
    private let angle: Angle
    
    /// Creates a shimmer effect.
    /// - Parameters:
    ///   - duration: Duration of one shimmer cycle
    ///   - color: Color of the shimmer highlight
    ///   - angle: Angle of the shimmer gradient
    public init(
        duration: Double = 1.5,
        color: Color = .white,
        angle: Angle = .degrees(30)
    ) {
        self.duration = duration
        self.color = color
        self.angle = angle
    }
    
    public func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    LinearGradient(
                        stops: [
                            .init(color: .clear, location: max(0, phase - 0.3)),
                            .init(color: color.opacity(0.5), location: phase),
                            .init(color: .clear, location: min(1, phase + 0.3))
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .rotationEffect(angle)
                    .frame(width: geometry.size.width * 2, height: geometry.size.height * 2)
                    .offset(x: -geometry.size.width / 2, y: -geometry.size.height / 2)
                }
                .mask(content)
            )
            .onAppear {
                withAnimation(
                    .linear(duration: duration)
                    .repeatForever(autoreverses: false)
                ) {
                    phase = 1.3
                }
            }
    }
}

// MARK: - Pulse Effect

/// A pulsing animation effect.
public struct PulseEffect: ViewModifier {
    @State private var isPulsing = false
    private let duration: Double
    private let minScale: CGFloat
    private let maxScale: CGFloat
    
    /// Creates a pulse effect.
    /// - Parameters:
    ///   - duration: Duration of one pulse cycle
    ///   - minScale: Minimum scale factor
    ///   - maxScale: Maximum scale factor
    public init(
        duration: Double = 1.0,
        minScale: CGFloat = 0.95,
        maxScale: CGFloat = 1.05
    ) {
        self.duration = duration
        self.minScale = minScale
        self.maxScale = maxScale
    }
    
    public func body(content: Content) -> some View {
        content
            .scaleEffect(isPulsing ? maxScale : minScale)
            .animation(
                .easeInOut(duration: duration)
                .repeatForever(autoreverses: true),
                value: isPulsing
            )
            .onAppear {
                isPulsing = true
            }
    }
}

// MARK: - Glow Effect

/// A glowing animation effect.
public struct GlowEffect: ViewModifier {
    @State private var isGlowing = false
    private let color: Color
    private let radius: CGFloat
    private let duration: Double
    
    /// Creates a glow effect.
    /// - Parameters:
    ///   - color: Color of the glow
    ///   - radius: Maximum glow radius
    ///   - duration: Duration of one glow cycle
    public init(
        color: Color = .blue,
        radius: CGFloat = 10,
        duration: Double = 1.5
    ) {
        self.color = color
        self.radius = radius
        self.duration = duration
    }
    
    public func body(content: Content) -> some View {
        content
            .shadow(
                color: color.opacity(isGlowing ? 0.8 : 0.3),
                radius: isGlowing ? radius : radius * 0.5
            )
            .animation(
                .easeInOut(duration: duration)
                .repeatForever(autoreverses: true),
                value: isGlowing
            )
            .onAppear {
                isGlowing = true
            }
    }
}

// MARK: - Float Effect

/// A floating animation effect.
public struct FloatEffect: ViewModifier {
    @State private var isFloating = false
    private let offset: CGFloat
    private let duration: Double
    
    /// Creates a float effect.
    /// - Parameters:
    ///   - offset: Maximum vertical offset
    ///   - duration: Duration of one float cycle
    public init(offset: CGFloat = 10, duration: Double = 2.0) {
        self.offset = offset
        self.duration = duration
    }
    
    public func body(content: Content) -> some View {
        content
            .offset(y: isFloating ? -offset : offset)
            .animation(
                .easeInOut(duration: duration)
                .repeatForever(autoreverses: true),
                value: isFloating
            )
            .onAppear {
                isFloating = true
            }
    }
}

// MARK: - Wiggle Effect

/// A wiggle/shake animation effect.
public struct WiggleEffect: ViewModifier {
    @State private var isWiggling = false
    private let angle: Double
    private let duration: Double
    
    /// Creates a wiggle effect.
    /// - Parameters:
    ///   - angle: Maximum rotation angle in degrees
    ///   - duration: Duration of one wiggle cycle
    public init(angle: Double = 3, duration: Double = 0.1) {
        self.angle = angle
        self.duration = duration
    }
    
    public func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(isWiggling ? angle : -angle))
            .animation(
                .linear(duration: duration)
                .repeatForever(autoreverses: true),
                value: isWiggling
            )
            .onAppear {
                isWiggling = true
            }
    }
}

// MARK: - Morphing Border Effect

/// An animated morphing border effect.
public struct MorphingBorderEffect: ViewModifier {
    @State private var phase: CGFloat = 0
    private let colors: [Color]
    private let lineWidth: CGFloat
    private let cornerRadius: CGFloat
    private let duration: Double
    
    /// Creates a morphing border effect.
    /// - Parameters:
    ///   - colors: Colors for the gradient border
    ///   - lineWidth: Width of the border
    ///   - cornerRadius: Corner radius of the border
    ///   - duration: Duration of one animation cycle
    public init(
        colors: [Color] = [.blue, .purple, .pink, .blue],
        lineWidth: CGFloat = 2,
        cornerRadius: CGFloat = 16,
        duration: Double = 3.0
    ) {
        self.colors = colors
        self.lineWidth = lineWidth
        self.cornerRadius = cornerRadius
        self.duration = duration
    }
    
    public func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(
                        AngularGradient(
                            colors: colors,
                            center: .center,
                            startAngle: .degrees(phase * 360),
                            endAngle: .degrees(phase * 360 + 360)
                        ),
                        lineWidth: lineWidth
                    )
            )
            .onAppear {
                withAnimation(
                    .linear(duration: duration)
                    .repeatForever(autoreverses: false)
                ) {
                    phase = 1
                }
            }
    }
}

// MARK: - Typewriter Effect

/// A typewriter text animation effect.
public struct TypewriterEffect: ViewModifier {
    let text: String
    let speed: Double
    @State private var displayedText = ""
    @State private var currentIndex = 0
    
    /// Creates a typewriter effect.
    /// - Parameters:
    ///   - text: The full text to display
    ///   - speed: Characters per second
    public init(text: String, speed: Double = 15) {
        self.text = text
        self.speed = speed
    }
    
    public func body(content: Content) -> some View {
        Text(displayedText)
            .onAppear {
                animateText()
            }
    }
    
    private func animateText() {
        displayedText = ""
        currentIndex = 0
        
        Timer.scheduledTimer(withTimeInterval: 1.0 / speed, repeats: true) { timer in
            if currentIndex < text.count {
                let index = text.index(text.startIndex, offsetBy: currentIndex)
                displayedText += String(text[index])
                currentIndex += 1
            } else {
                timer.invalidate()
            }
        }
    }
}

// MARK: - Reveal Animation

/// A reveal animation that unveils content.
public struct RevealAnimation: ViewModifier {
    @State private var isRevealed = false
    private let direction: Edge
    private let delay: Double
    private let duration: Double
    
    /// Creates a reveal animation.
    /// - Parameters:
    ///   - direction: Direction of the reveal
    ///   - delay: Delay before starting
    ///   - duration: Duration of the animation
    public init(
        direction: Edge = .leading,
        delay: Double = 0,
        duration: Double = 0.5
    ) {
        self.direction = direction
        self.delay = delay
        self.duration = duration
    }
    
    public func body(content: Content) -> some View {
        content
            .mask(
                GeometryReader { geometry in
                    Rectangle()
                        .frame(
                            width: isVertical ? geometry.size.width : (isRevealed ? geometry.size.width : 0),
                            height: isVertical ? (isRevealed ? geometry.size.height : 0) : geometry.size.height
                        )
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: .infinity,
                            alignment: maskAlignment
                        )
                }
            )
            .onAppear {
                withAnimation(
                    .easeOut(duration: duration)
                    .delay(delay)
                ) {
                    isRevealed = true
                }
            }
    }
    
    private var isVertical: Bool {
        direction == .top || direction == .bottom
    }
    
    private var maskAlignment: Alignment {
        switch direction {
        case .leading: return .leading
        case .trailing: return .trailing
        case .top: return .top
        case .bottom: return .bottom
        }
    }
}

// MARK: - Staggered Animation

/// A container that staggers child animations.
public struct StaggeredAnimation<Content: View>: View {
    private let content: Content
    private let delay: Double
    private let animation: Animation
    
    @State private var isVisible = false
    
    /// Creates a staggered animation container.
    /// - Parameters:
    ///   - delay: Delay between each child
    ///   - animation: Animation to apply
    ///   - content: The content to animate
    public init(
        delay: Double = 0.1,
        animation: Animation = .spring(response: 0.4, dampingFraction: 0.8),
        @ViewBuilder content: () -> Content
    ) {
        self.delay = delay
        self.animation = animation
        self.content = content()
    }
    
    public var body: some View {
        content
            .opacity(isVisible ? 1 : 0)
            .offset(y: isVisible ? 0 : 20)
            .onAppear {
                withAnimation(animation) {
                    isVisible = true
                }
            }
    }
}

// MARK: - View Extensions

public extension View {
    /// Applies a shimmer effect.
    func shimmer(
        duration: Double = 1.5,
        color: Color = .white,
        angle: Angle = .degrees(30)
    ) -> some View {
        modifier(ShimmerEffect(duration: duration, color: color, angle: angle))
    }
    
    /// Applies a pulse effect.
    func pulse(
        duration: Double = 1.0,
        minScale: CGFloat = 0.95,
        maxScale: CGFloat = 1.05
    ) -> some View {
        modifier(PulseEffect(duration: duration, minScale: minScale, maxScale: maxScale))
    }
    
    /// Applies a glow effect.
    func glow(
        color: Color = .blue,
        radius: CGFloat = 10,
        duration: Double = 1.5
    ) -> some View {
        modifier(GlowEffect(color: color, radius: radius, duration: duration))
    }
    
    /// Applies a float effect.
    func float(offset: CGFloat = 10, duration: Double = 2.0) -> some View {
        modifier(FloatEffect(offset: offset, duration: duration))
    }
    
    /// Applies a wiggle effect.
    func wiggle(angle: Double = 3, duration: Double = 0.1) -> some View {
        modifier(WiggleEffect(angle: angle, duration: duration))
    }
    
    /// Applies a morphing border effect.
    func morphingBorder(
        colors: [Color] = [.blue, .purple, .pink, .blue],
        lineWidth: CGFloat = 2,
        cornerRadius: CGFloat = 16,
        duration: Double = 3.0
    ) -> some View {
        modifier(MorphingBorderEffect(
            colors: colors,
            lineWidth: lineWidth,
            cornerRadius: cornerRadius,
            duration: duration
        ))
    }
    
    /// Applies a reveal animation.
    func reveal(
        direction: Edge = .leading,
        delay: Double = 0,
        duration: Double = 0.5
    ) -> some View {
        modifier(RevealAnimation(direction: direction, delay: delay, duration: duration))
    }
    
    /// Applies a glass-specific animation preset.
    func glassAnimation(_ preset: Animation = GlassAnimationPresets.smooth) -> some View {
        animation(preset, value: UUID())
    }
    
    /// Applies a glass transition.
    func glassTransition(_ transition: AnyTransition = GlassTransitions.fadeScale) -> some View {
        self.transition(transition)
    }
}

// MARK: - Preview Provider

#if DEBUG
struct GlassAnimations_Previews: PreviewProvider {
    static var previews: some View {
        GlassAnimationsPreviewContainer()
    }
}

private struct GlassAnimationsPreviewContainer: View {
    @State private var showCard = true
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.blue, .purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    Text("Glass Animations")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    // Shimmer effect
                    Text("Loading...")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shimmer()
                        .padding(.horizontal)
                    
                    // Pulse effect
                    Circle()
                        .fill(.ultraThinMaterial)
                        .frame(width: 80, height: 80)
                        .overlay(
                            Image(systemName: "heart.fill")
                                .font(.largeTitle)
                                .foregroundColor(.pink)
                        )
                        .pulse()
                    
                    // Glow effect
                    Text("Glowing")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                        .glow(color: .cyan, radius: 15)
                    
                    // Float effect
                    Image(systemName: "cloud.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.white.opacity(0.8))
                        .float()
                    
                    // Morphing border
                    Text("Morphing Border")
                        .padding(20)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .morphingBorder()
                    
                    // Toggle card
                    Button("Toggle Card") {
                        withAnimation(GlassAnimationPresets.bouncy) {
                            showCard.toggle()
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(Capsule())
                    
                    if showCard {
                        VStack {
                            Text("Animated Card")
                                .font(.headline)
                            Text("With glass transition")
                                .foregroundColor(.secondary)
                        }
                        .padding(30)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .transition(GlassTransitions.glassReveal)
                    }
                    
                    Spacer(minLength: 50)
                }
                .padding(.top, 40)
            }
        }
    }
}
#endif
