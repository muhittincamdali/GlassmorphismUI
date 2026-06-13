import SwiftUI

/// Visual Proof of GlassmorphismUI superiority.
/// 
/// Shows the "Liquid Glass" effect compared to standard SwiftUI Material.
public struct VisualProofShowcase: View {
    public init() {}
    
    public var body: some View {
        ZStack {
            LinearGradient(colors: [.blue, .purple, .pink], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Text("World-Class UI")
                    .font(.system(size: 44, weight: .black))
                    .foregroundStyle(.white)
                
                HStack(spacing: 20) {
                    VStack {
                        Text("Standard")
                            .font(.caption.bold())
                            .foregroundStyle(.white.opacity(0.6))
                        RoundedRectangle(cornerRadius: 24)
                            .fill(.ultraThinMaterial)
                            .frame(width: 150, height: 150)
                            .overlay(Text("Apple Native").font(.system(size: 12)))
                    }
                    
                    VStack {
                        Text("GlassmorphismUI")
                            .font(.caption.bold())
                            .foregroundStyle(.white.opacity(0.6))
                        RoundedRectangle(cornerRadius: 24)
                            .fill(.white.opacity(0.1))
                            .background(.ultraThinMaterial)
                            .overlay {
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(.white.opacity(0.2), lineWidth: 0.5)
                            }
                            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                            .frame(width: 150, height: 150)
                            .overlay(Text("Liquid Glass").font(.system(size: 12, weight: .bold)))
                    }
                }
                
                Text("100% Swift 6 • Zero Bloat • iOS 26 Ready")
                    .font(.subheadline.monospaced())
                    .foregroundStyle(.white.opacity(0.8))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background(.white.opacity(0.1))
                    .clipShape(Capsule())
            }
        }
    }
}
