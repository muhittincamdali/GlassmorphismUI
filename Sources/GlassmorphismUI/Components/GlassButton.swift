import SwiftUI

/// A button with a glassmorphism background.
///
/// ```swift
/// GlassButton("Continue", icon: "arrow.right") {
///     print("Tapped")
/// }
/// ```
public struct GlassButton: View {
    // MARK: - Properties

    private let title: String
    private let icon: String?
    private let material: GlassMaterial
    private let action: () -> Void

    @State private var isPressed = false
    @Environment(\.colorScheme) private var colorScheme

    // MARK: - Initialization

    /// Creates a glass button.
    ///
    /// - Parameters:
    ///   - title: The button label text.
    ///   - icon: An optional SF Symbol name displayed beside the title.
    ///   - material: The glass material. Defaults to `.regular`.
    ///   - action: The action to perform on tap.
    public init(
        _ title: String,
        icon: String? = nil,
        material: GlassMaterial = .regular,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.material = material
        self.action = action
    }

    // MARK: - Body

    public var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Text(title)
                    .font(.body.weight(.semibold))

                if let icon {
                    Image(systemName: icon)
                        .font(.body.weight(.semibold))
                }
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 14)
            .glass(
                configuration: .init(
                    cornerRadius: 14,
                    shadowRadius: isPressed ? 2 : 6,
                    shadowOpacity: isPressed ? 0.05 : 0.1
                ),
                material: material
            )
            .scaleEffect(isPressed ? 0.96 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: isPressed)
        }
        .buttonStyle(.plain)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}

// MARK: - Previews

#if DEBUG
#Preview("GlassButton") {
    ZStack {
        LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()

        VStack(spacing: 16) {
            GlassButton("Get Started", icon: "arrow.right") {}
            GlassButton("Settings", icon: "gearshape") {}
            GlassButton("Download", material: .thick) {}
        }
    }
}
#endif
