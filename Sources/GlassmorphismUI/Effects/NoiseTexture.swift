//
//  NoiseTexture.swift
//  GlassmorphismUI
//
//  Procedural noise textures for adding subtle grain and texture
//  to glassmorphism effects. Supports various noise algorithms.
//

import SwiftUI
#if canImport(CoreGraphics)
import CoreGraphics
#endif

// MARK: - Noise Type

/// Available noise generation algorithms.
public enum NoiseType: String, CaseIterable, Sendable {
    /// White noise (random pixels)
    case white
    /// Perlin noise (smooth, natural)
    case perlin
    /// Simplex noise (improved Perlin)
    case simplex
    /// Worley/Voronoi noise (cellular)
    case worley
    /// Fractal Brownian motion
    case fbm
    /// Film grain effect
    case filmGrain
    /// Static/TV noise
    case staticNoise
}

// MARK: - Noise Configuration

/// Configuration options for noise texture generation.
public struct NoiseTextureConfiguration: Sendable {
    /// The type of noise to generate
    public var type: NoiseType
    /// Overall opacity of the noise (0.0 - 1.0)
    public var opacity: CGFloat
    /// Scale of the noise pattern (higher = smaller details)
    public var scale: CGFloat
    /// Number of octaves for fractal noise
    public var octaves: Int
    /// Persistence for fractal noise (amplitude falloff)
    public var persistence: CGFloat
    /// Lacunarity for fractal noise (frequency increase)
    public var lacunarity: CGFloat
    /// Whether the noise should animate
    public var animated: Bool
    /// Animation speed (frames per second)
    public var animationSpeed: Double
    /// Blend mode for compositing
    public var blendMode: BlendMode
    /// Color for monochrome noise
    public var color: Color
    /// Whether to use color noise vs monochrome
    public var isMonochrome: Bool
    /// Seed for reproducible noise
    public var seed: UInt64
    
    /// Creates a new noise configuration.
    public init(
        type: NoiseType = .white,
        opacity: CGFloat = 0.05,
        scale: CGFloat = 1.0,
        octaves: Int = 4,
        persistence: CGFloat = 0.5,
        lacunarity: CGFloat = 2.0,
        animated: Bool = false,
        animationSpeed: Double = 24.0,
        blendMode: BlendMode = .overlay,
        color: Color = .white,
        isMonochrome: Bool = true,
        seed: UInt64 = 0
    ) {
        self.type = type
        self.opacity = opacity
        self.scale = scale
        self.octaves = octaves
        self.persistence = persistence
        self.lacunarity = lacunarity
        self.animated = animated
        self.animationSpeed = animationSpeed
        self.blendMode = blendMode
        self.color = color
        self.isMonochrome = isMonochrome
        self.seed = seed
    }
    
    /// Subtle noise preset for glass effects
    public static var subtle: NoiseTextureConfiguration {
        NoiseTextureConfiguration(opacity: 0.03, scale: 1.0)
    }
    
    /// Visible grain preset
    public static var grain: NoiseTextureConfiguration {
        NoiseTextureConfiguration(type: .filmGrain, opacity: 0.08, scale: 0.5)
    }
    
    /// Frosted glass texture preset
    public static var frosted: NoiseTextureConfiguration {
        NoiseTextureConfiguration(type: .perlin, opacity: 0.05, scale: 2.0)
    }
    
    /// Animated static preset
    public static var animatedStatic: NoiseTextureConfiguration {
        NoiseTextureConfiguration(
            type: .staticNoise,
            opacity: 0.1,
            animated: true,
            animationSpeed: 12.0
        )
    }
}

// MARK: - Noise Generator

/// A utility class for generating procedural noise values.
public final class NoiseGenerator: @unchecked Sendable {
    private var permutation: [Int]
    private let seed: UInt64
    
    /// Creates a noise generator with a seed.
    public init(seed: UInt64 = 0) {
        self.seed = seed
        self.permutation = Self.generatePermutation(seed: seed)
    }
    
    private static func generatePermutation(seed: UInt64) -> [Int] {
        var perm = Array(0..<256)
        var rng = SeededRandomGenerator(seed: seed)
        perm.shuffle(using: &rng)
        return perm + perm // Double the array for easier indexing
    }
    
    /// Generates white noise at a point.
    public func whiteNoise(x: CGFloat, y: CGFloat) -> CGFloat {
        let xi = Int(x * 12.9898 + y * 78.233) & 255
        let yi = Int(x * 78.233 + y * 12.9898) & 255
        let index = (permutation[xi] + yi) & 255
        return CGFloat(permutation[index]) / 255.0
    }
    
    /// Generates Perlin noise at a point.
    public func perlinNoise(x: CGFloat, y: CGFloat) -> CGFloat {
        let xi = Int(floor(x)) & 255
        let yi = Int(floor(y)) & 255
        
        let xf = x - floor(x)
        let yf = y - floor(y)
        
        let u = fade(xf)
        let v = fade(yf)
        
        let aa = permutation[permutation[xi] + yi]
        let ab = permutation[permutation[xi] + yi + 1]
        let ba = permutation[permutation[xi + 1] + yi]
        let bb = permutation[permutation[xi + 1] + yi + 1]
        
        let x1 = lerp(grad(aa, x: xf, y: yf), grad(ba, x: xf - 1, y: yf), t: u)
        let x2 = lerp(grad(ab, x: xf, y: yf - 1), grad(bb, x: xf - 1, y: yf - 1), t: u)
        
        return (lerp(x1, x2, t: v) + 1) / 2
    }
    
    /// Generates simplex noise at a point.
    public func simplexNoise(x: CGFloat, y: CGFloat) -> CGFloat {
        let F2: CGFloat = 0.5 * (sqrt(3.0) - 1.0)
        let G2: CGFloat = (3.0 - sqrt(3.0)) / 6.0
        
        let s = (x + y) * F2
        let i = floor(x + s)
        let j = floor(y + s)
        
        let t = (i + j) * G2
        let X0 = i - t
        let Y0 = j - t
        let x0 = x - X0
        let y0 = y - Y0
        
        var i1: CGFloat, j1: CGFloat
        if x0 > y0 {
            i1 = 1; j1 = 0
        } else {
            i1 = 0; j1 = 1
        }
        
        let x1 = x0 - i1 + G2
        let y1 = y0 - j1 + G2
        let x2 = x0 - 1.0 + 2.0 * G2
        let y2 = y0 - 1.0 + 2.0 * G2
        
        let ii = Int(i) & 255
        let jj = Int(j) & 255
        
        let gi0 = permutation[ii + permutation[jj]] % 12
        let gi1 = permutation[ii + Int(i1) + permutation[jj + Int(j1)]] % 12
        let gi2 = permutation[ii + 1 + permutation[jj + 1]] % 12
        
        var n0: CGFloat = 0, n1: CGFloat = 0, n2: CGFloat = 0
        
        var t0 = 0.5 - x0 * x0 - y0 * y0
        if t0 >= 0 {
            t0 *= t0
            n0 = t0 * t0 * dot(grad3[gi0], x: x0, y: y0)
        }
        
        var t1 = 0.5 - x1 * x1 - y1 * y1
        if t1 >= 0 {
            t1 *= t1
            n1 = t1 * t1 * dot(grad3[gi1], x: x1, y: y1)
        }
        
        var t2 = 0.5 - x2 * x2 - y2 * y2
        if t2 >= 0 {
            t2 *= t2
            n2 = t2 * t2 * dot(grad3[gi2], x: x2, y: y2)
        }
        
        return (70.0 * (n0 + n1 + n2) + 1) / 2
    }
    
    /// Generates Worley (cellular) noise at a point.
    public func worleyNoise(x: CGFloat, y: CGFloat) -> CGFloat {
        let xi = Int(floor(x))
        let yi = Int(floor(y))
        
        var minDist: CGFloat = .infinity
        
        for dx in -1...1 {
            for dy in -1...1 {
                let cellX = xi + dx
                let cellY = yi + dy
                
                // Generate cell point using permutation
                let hash = permutation[(permutation[cellX & 255] + (cellY & 255)) & 255]
                let px = CGFloat(cellX) + CGFloat(hash) / 255.0
                let py = CGFloat(cellY) + CGFloat(permutation[hash]) / 255.0
                
                let dist = sqrt(pow(x - px, 2) + pow(y - py, 2))
                minDist = min(minDist, dist)
            }
        }
        
        return min(minDist, 1.0)
    }
    
    /// Generates fractal Brownian motion noise.
    public func fbmNoise(x: CGFloat, y: CGFloat, octaves: Int, persistence: CGFloat, lacunarity: CGFloat) -> CGFloat {
        var total: CGFloat = 0
        var amplitude: CGFloat = 1
        var frequency: CGFloat = 1
        var maxValue: CGFloat = 0
        
        for _ in 0..<octaves {
            total += perlinNoise(x: x * frequency, y: y * frequency) * amplitude
            maxValue += amplitude
            amplitude *= persistence
            frequency *= lacunarity
        }
        
        return total / maxValue
    }
    
    // MARK: - Helper Functions
    
    private func fade(_ t: CGFloat) -> CGFloat {
        t * t * t * (t * (t * 6 - 15) + 10)
    }
    
    private func lerp(_ a: CGFloat, _ b: CGFloat, t: CGFloat) -> CGFloat {
        a + t * (b - a)
    }
    
    private func grad(_ hash: Int, x: CGFloat, y: CGFloat) -> CGFloat {
        let h = hash & 3
        let u = h < 2 ? x : y
        let v = h < 2 ? y : x
        return ((h & 1) == 0 ? u : -u) + ((h & 2) == 0 ? v : -v)
    }
    
    private let grad3: [(CGFloat, CGFloat)] = [
        (1, 1), (-1, 1), (1, -1), (-1, -1),
        (1, 0), (-1, 0), (0, 1), (0, -1),
        (1, 1), (-1, 1), (1, -1), (-1, -1)
    ]
    
    private func dot(_ g: (CGFloat, CGFloat), x: CGFloat, y: CGFloat) -> CGFloat {
        g.0 * x + g.1 * y
    }
}

// MARK: - Seeded Random Generator

private struct SeededRandomGenerator: RandomNumberGenerator {
    var state: UInt64
    
    init(seed: UInt64) {
        self.state = seed == 0 ? 12345678 : seed
    }
    
    mutating func next() -> UInt64 {
        state = state &* 6364136223846793005 &+ 1442695040888963407
        return state
    }
}

// MARK: - Noise Texture View

/// A view that displays procedural noise texture.
public struct NoiseTextureView: View {
    private let configuration: NoiseTextureConfiguration
    @State private var animationPhase: Double = 0
    
    /// Creates a noise texture view.
    /// - Parameter configuration: The noise configuration
    public init(configuration: NoiseTextureConfiguration = .subtle) {
        self.configuration = configuration
    }
    
    public var body: some View {
        if configuration.animated {
            animatedNoiseView
        } else {
            staticNoiseView
        }
    }
    
    private var staticNoiseView: some View {
        Canvas { context, size in
            drawNoise(context: context, size: size, time: 0)
        }
        .opacity(configuration.opacity)
        .blendMode(configuration.blendMode)
    }
    
    private var animatedNoiseView: some View {
        TimelineView(.animation(minimumInterval: 1.0 / configuration.animationSpeed)) { timeline in
            Canvas { context, size in
                let time = timeline.date.timeIntervalSinceReferenceDate
                drawNoise(context: context, size: size, time: time)
            }
        }
        .opacity(configuration.opacity)
        .blendMode(configuration.blendMode)
    }
    
    private func drawNoise(context: GraphicsContext, size: CGSize, time: TimeInterval) {
        let generator = NoiseGenerator(seed: configuration.seed &+ UInt64(time * 1000))
        let step = max(1, configuration.scale)
        
        for x in stride(from: 0, to: size.width, by: step) {
            for y in stride(from: 0, to: size.height, by: step) {
                let noiseValue = generateNoiseValue(
                    generator: generator,
                    x: x / size.width,
                    y: y / size.height,
                    time: time
                )
                
                let color = configuration.isMonochrome
                    ? configuration.color.opacity(noiseValue)
                    : Color(
                        red: noiseValue,
                        green: generateNoiseValue(generator: generator, x: x / size.width + 100, y: y / size.height, time: time),
                        blue: generateNoiseValue(generator: generator, x: x / size.width, y: y / size.height + 100, time: time)
                    )
                
                let rect = CGRect(x: x, y: y, width: step, height: step)
                context.fill(Path(rect), with: .color(color))
            }
        }
    }
    
    private func generateNoiseValue(generator: NoiseGenerator, x: CGFloat, y: CGFloat, time: TimeInterval) -> CGFloat {
        let scale = configuration.scale * 10
        let scaledX = x * scale
        let scaledY = y * scale
        
        switch configuration.type {
        case .white:
            return generator.whiteNoise(x: scaledX + CGFloat(time), y: scaledY)
            
        case .perlin:
            return generator.perlinNoise(x: scaledX, y: scaledY)
            
        case .simplex:
            return generator.simplexNoise(x: scaledX, y: scaledY)
            
        case .worley:
            return generator.worleyNoise(x: scaledX, y: scaledY)
            
        case .fbm:
            return generator.fbmNoise(
                x: scaledX,
                y: scaledY,
                octaves: configuration.octaves,
                persistence: configuration.persistence,
                lacunarity: configuration.lacunarity
            )
            
        case .filmGrain:
            let base = generator.whiteNoise(x: scaledX + CGFloat(time * 100), y: scaledY)
            return pow(base, 2) // Darker overall with occasional bright spots
            
        case .staticNoise:
            let t = CGFloat(time * 60).truncatingRemainder(dividingBy: 1000)
            return generator.whiteNoise(x: scaledX + t, y: scaledY + t * 0.5)
        }
    }
}

// MARK: - Noise Overlay Modifier

/// A modifier that adds a noise texture overlay to a view.
public struct NoiseOverlayModifier: ViewModifier {
    private let configuration: NoiseTextureConfiguration
    
    /// Creates a noise overlay modifier.
    /// - Parameter configuration: The noise configuration
    public init(configuration: NoiseTextureConfiguration = .subtle) {
        self.configuration = configuration
    }
    
    public func body(content: Content) -> some View {
        content
            .overlay(
                NoiseTextureView(configuration: configuration)
                    .allowsHitTesting(false)
            )
    }
}

// MARK: - Grain Effect Modifier

/// A modifier that adds film grain effect to a view.
public struct GrainEffectModifier: ViewModifier {
    private let intensity: CGFloat
    private let animated: Bool
    
    /// Creates a grain effect modifier.
    /// - Parameters:
    ///   - intensity: Intensity of the grain (0.0 - 1.0)
    ///   - animated: Whether the grain should animate
    public init(intensity: CGFloat = 0.1, animated: Bool = false) {
        self.intensity = intensity
        self.animated = animated
    }
    
    public func body(content: Content) -> some View {
        content
            .overlay(
                NoiseTextureView(
                    configuration: NoiseTextureConfiguration(
                        type: .filmGrain,
                        opacity: intensity,
                        scale: 0.5,
                        animated: animated,
                        animationSpeed: 24.0,
                        blendMode: .overlay
                    )
                )
                .allowsHitTesting(false)
            )
    }
}

// MARK: - Texture Patterns

/// Pre-built texture patterns for common use cases.
public enum TexturePattern {
    /// Subtle noise for glass surfaces
    case glassNoise
    /// Paper texture
    case paper
    /// Fabric/canvas texture
    case fabric
    /// Metal brushed texture
    case brushedMetal
    /// Concrete texture
    case concrete
    
    /// Returns the configuration for this pattern.
    public var configuration: NoiseTextureConfiguration {
        switch self {
        case .glassNoise:
            return NoiseTextureConfiguration(
                type: .white,
                opacity: 0.03,
                scale: 1.0,
                blendMode: .overlay,
                color: .white
            )
            
        case .paper:
            return NoiseTextureConfiguration(
                type: .fbm,
                opacity: 0.08,
                scale: 3.0,
                octaves: 5,
                persistence: 0.6,
                blendMode: .multiply,
                color: .brown
            )
            
        case .fabric:
            return NoiseTextureConfiguration(
                type: .perlin,
                opacity: 0.1,
                scale: 5.0,
                blendMode: .softLight
            )
            
        case .brushedMetal:
            return NoiseTextureConfiguration(
                type: .perlin,
                opacity: 0.05,
                scale: 0.5,
                blendMode: .overlay,
                color: .gray
            )
            
        case .concrete:
            return NoiseTextureConfiguration(
                type: .worley,
                opacity: 0.06,
                scale: 2.0,
                blendMode: .multiply,
                color: .gray
            )
        }
    }
}

// MARK: - View Extensions

public extension View {
    /// Adds a noise texture overlay.
    /// - Parameter configuration: The noise configuration
    func noiseTexture(_ configuration: NoiseTextureConfiguration = .subtle) -> some View {
        modifier(NoiseOverlayModifier(configuration: configuration))
    }
    
    /// Adds a predefined texture pattern.
    /// - Parameter pattern: The texture pattern to apply
    func texturePattern(_ pattern: TexturePattern) -> some View {
        modifier(NoiseOverlayModifier(configuration: pattern.configuration))
    }
    
    /// Adds a film grain effect.
    /// - Parameters:
    ///   - intensity: Intensity of the grain
    ///   - animated: Whether the grain should animate
    func filmGrain(intensity: CGFloat = 0.1, animated: Bool = false) -> some View {
        modifier(GrainEffectModifier(intensity: intensity, animated: animated))
    }
    
    /// Adds subtle glass noise for glassmorphism effects.
    /// - Parameter opacity: Opacity of the noise
    func glassNoise(opacity: CGFloat = 0.03) -> some View {
        var config = NoiseTextureConfiguration.subtle
        config.opacity = opacity
        return modifier(NoiseOverlayModifier(configuration: config))
    }
}

// MARK: - Preview Provider

#if DEBUG
struct NoiseTexture_Previews: PreviewProvider {
    static var previews: some View {
        NoiseTexturePreviewContainer()
    }
}

private struct NoiseTexturePreviewContainer: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Noise Textures")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                // Noise type samples
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(NoiseType.allCases, id: \.self) { type in
                        VStack {
                            NoiseTextureView(
                                configuration: NoiseTextureConfiguration(
                                    type: type,
                                    opacity: 0.5,
                                    scale: 2.0
                                )
                            )
                            .frame(height: 100)
                            .background(Color.gray.opacity(0.3))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            
                            Text(type.rawValue.capitalized)
                                .font(.caption)
                        }
                    }
                }
                .padding(.horizontal)
                
                // Glass card with noise
                VStack {
                    Text("Glass with Noise")
                        .font(.headline)
                    Text("Subtle texture overlay")
                        .foregroundColor(.secondary)
                }
                .padding(30)
                .background(.ultraThinMaterial)
                .glassNoise()
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.horizontal)
                
                // Animated noise
                Text("Animated Static")
                    .font(.headline)
                
                NoiseTextureView(configuration: .animatedStatic)
                    .frame(height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .background(
            LinearGradient(
                colors: [.blue.opacity(0.3), .purple.opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
    }
}
#endif
