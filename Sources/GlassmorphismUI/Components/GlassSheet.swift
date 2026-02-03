//
//  GlassSheet.swift
//  GlassmorphismUI
//
//  A customizable bottom sheet component with glassmorphism styling.
//  Supports multiple detent heights, drag gestures, and smooth animations.
//

import SwiftUI

// MARK: - Sheet Detent

/// Defines the available height positions for the glass sheet.
public enum GlassSheetDetent: Hashable, Sendable {
    /// Sheet is hidden below the screen
    case hidden
    /// Small peek height, typically showing just a handle
    case small
    /// Medium height, approximately half screen
    case medium
    /// Large height, approximately 90% of screen
    case large
    /// Custom fraction of screen height (0.0 - 1.0)
    case fraction(CGFloat)
    /// Fixed point height in pixels
    case height(CGFloat)
    
    /// Returns the actual height for this detent given the container height
    public func height(in containerHeight: CGFloat) -> CGFloat {
        switch self {
        case .hidden:
            return 0
        case .small:
            return containerHeight * 0.15
        case .medium:
            return containerHeight * 0.5
        case .large:
            return containerHeight * 0.9
        case .fraction(let fraction):
            return containerHeight * min(max(fraction, 0), 1)
        case .height(let points):
            return min(points, containerHeight)
        }
    }
}

// MARK: - Sheet Configuration

/// Configuration options for customizing glass sheet appearance and behavior.
public struct GlassSheetConfiguration: Sendable {
    /// The blur intensity of the glass effect (0.0 - 1.0)
    public var blurIntensity: CGFloat
    /// The tint color applied to the glass surface
    public var tintColor: Color
    /// The opacity of the tint color
    public var tintOpacity: CGFloat
    /// Corner radius for the sheet
    public var cornerRadius: CGFloat
    /// Whether to show the drag indicator handle
    public var showsHandle: Bool
    /// The color of the drag handle
    public var handleColor: Color
    /// Whether background dimming is enabled
    public var dimBackground: Bool
    /// Maximum dimming opacity when sheet is at large detent
    public var maxDimOpacity: CGFloat
    /// Whether the sheet can be dismissed by dragging down
    public var allowsDismiss: Bool
    /// Animation used for sheet transitions
    public var animation: Animation
    /// Available detents for the sheet
    public var detents: Set<GlassSheetDetent>
    /// Whether to add haptic feedback on detent changes
    public var hapticFeedback: Bool
    /// Border width for the glass edge
    public var borderWidth: CGFloat
    /// Border color for the glass edge
    public var borderColor: Color
    /// Shadow configuration
    public var shadowRadius: CGFloat
    public var shadowColor: Color
    public var shadowOffset: CGSize
    
    /// Creates a new sheet configuration with default values
    public init(
        blurIntensity: CGFloat = 0.8,
        tintColor: Color = .white,
        tintOpacity: CGFloat = 0.1,
        cornerRadius: CGFloat = 24,
        showsHandle: Bool = true,
        handleColor: Color = .secondary,
        dimBackground: Bool = true,
        maxDimOpacity: CGFloat = 0.4,
        allowsDismiss: Bool = true,
        animation: Animation = .spring(response: 0.35, dampingFraction: 0.8),
        detents: Set<GlassSheetDetent> = [.medium, .large],
        hapticFeedback: Bool = true,
        borderWidth: CGFloat = 0.5,
        borderColor: Color = .white.opacity(0.3),
        shadowRadius: CGFloat = 20,
        shadowColor: Color = .black.opacity(0.15),
        shadowOffset: CGSize = CGSize(width: 0, height: -5)
    ) {
        self.blurIntensity = blurIntensity
        self.tintColor = tintColor
        self.tintOpacity = tintOpacity
        self.cornerRadius = cornerRadius
        self.showsHandle = showsHandle
        self.handleColor = handleColor
        self.dimBackground = dimBackground
        self.maxDimOpacity = maxDimOpacity
        self.allowsDismiss = allowsDismiss
        self.animation = animation
        self.detents = detents
        self.hapticFeedback = hapticFeedback
        self.borderWidth = borderWidth
        self.borderColor = borderColor
        self.shadowRadius = shadowRadius
        self.shadowColor = shadowColor
        self.shadowOffset = shadowOffset
    }
    
    /// Preset configuration for a minimal glass sheet
    public static var minimal: GlassSheetConfiguration {
        GlassSheetConfiguration(
            blurIntensity: 0.6,
            tintOpacity: 0.05,
            showsHandle: false,
            dimBackground: false,
            borderWidth: 0
        )
    }
    
    /// Preset configuration for a prominent glass sheet
    public static var prominent: GlassSheetConfiguration {
        GlassSheetConfiguration(
            blurIntensity: 0.95,
            tintOpacity: 0.15,
            cornerRadius: 32,
            maxDimOpacity: 0.6,
            borderWidth: 1,
            shadowRadius: 30
        )
    }
    
    /// Preset configuration for dark mode optimized sheet
    public static var dark: GlassSheetConfiguration {
        GlassSheetConfiguration(
            blurIntensity: 0.7,
            tintColor: .black,
            tintOpacity: 0.3,
            handleColor: .white.opacity(0.5),
            borderColor: .white.opacity(0.1),
            shadowColor: .black.opacity(0.3)
        )
    }
}

// MARK: - Drag Handle View

/// The drag indicator handle displayed at the top of the sheet
private struct GlassSheetHandle: View {
    let color: Color
    let isInteracting: Bool
    
    var body: some View {
        Capsule()
            .fill(color)
            .frame(width: isInteracting ? 50 : 36, height: 5)
            .animation(.spring(response: 0.25), value: isInteracting)
            .padding(.top, 8)
            .padding(.bottom, 4)
    }
}

// MARK: - Glass Sheet View

/// A bottom sheet component with customizable glassmorphism styling.
///
/// `GlassSheet` provides a modern, iOS-style bottom sheet with glass effect
/// that can snap to multiple height positions (detents).
///
/// Example usage:
/// ```swift
/// struct ContentView: View {
///     @State private var showSheet = false
///     @State private var currentDetent: GlassSheetDetent = .medium
///
///     var body: some View {
///         ZStack {
///             // Your main content
///             GlassSheet(
///                 isPresented: $showSheet,
///                 currentDetent: $currentDetent
///             ) {
///                 Text("Sheet Content")
///             }
///         }
///     }
/// }
/// ```
public struct GlassSheet<Content: View>: View {
    // MARK: - Properties
    
    @Binding private var isPresented: Bool
    @Binding private var currentDetent: GlassSheetDetent
    private let configuration: GlassSheetConfiguration
    private let content: () -> Content
    
    @State private var dragOffset: CGFloat = 0
    @State private var isDragging: Bool = false
    @GestureState private var gestureState: CGFloat = 0
    
    // MARK: - Initialization
    
    /// Creates a new glass sheet.
    /// - Parameters:
    ///   - isPresented: Binding controlling sheet visibility
    ///   - currentDetent: Binding for the current detent position
    ///   - configuration: Configuration options for appearance and behavior
    ///   - content: The content to display inside the sheet
    public init(
        isPresented: Binding<Bool>,
        currentDetent: Binding<GlassSheetDetent>,
        configuration: GlassSheetConfiguration = GlassSheetConfiguration(),
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._isPresented = isPresented
        self._currentDetent = currentDetent
        self.configuration = configuration
        self.content = content
    }
    
    // MARK: - Body
    
    public var body: some View {
        GeometryReader { geometry in
            let containerHeight = geometry.size.height
            let sheetHeight = currentDetent.height(in: containerHeight)
            let effectiveOffset = sheetHeight - dragOffset
            
            ZStack(alignment: .bottom) {
                // Background dim layer
                if configuration.dimBackground && isPresented {
                    Color.black
                        .opacity(dimOpacity(for: effectiveOffset, containerHeight: containerHeight))
                        .ignoresSafeArea()
                        .onTapGesture {
                            if configuration.allowsDismiss {
                                dismissSheet()
                            }
                        }
                        .animation(configuration.animation, value: isPresented)
                }
                
                // Sheet content
                if isPresented {
                    sheetContent(containerHeight: containerHeight, sheetHeight: sheetHeight)
                        .transition(.move(edge: .bottom))
                }
            }
            .animation(isDragging ? nil : configuration.animation, value: currentDetent)
            .animation(configuration.animation, value: isPresented)
        }
    }
    
    // MARK: - Sheet Content
    
    @ViewBuilder
    private func sheetContent(containerHeight: CGFloat, sheetHeight: CGFloat) -> some View {
        VStack(spacing: 0) {
            // Drag handle
            if configuration.showsHandle {
                GlassSheetHandle(color: configuration.handleColor, isInteracting: isDragging)
            }
            
            // User content
            content()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(height: sheetHeight)
        .frame(maxWidth: .infinity)
        .background(glassBackground)
        .clipShape(RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous))
        .overlay(borderOverlay)
        .shadow(
            color: configuration.shadowColor,
            radius: configuration.shadowRadius,
            x: configuration.shadowOffset.width,
            y: configuration.shadowOffset.height
        )
        .offset(y: dragOffset)
        .gesture(dragGesture(containerHeight: containerHeight))
    }
    
    // MARK: - Glass Background
    
    private var glassBackground: some View {
        ZStack {
            // Blur effect
            Rectangle()
                .fill(.ultraThinMaterial)
                .opacity(configuration.blurIntensity)
            
            // Tint overlay
            Rectangle()
                .fill(configuration.tintColor.opacity(configuration.tintOpacity))
            
            // Gradient highlight
            LinearGradient(
                colors: [
                    Color.white.opacity(0.15),
                    Color.white.opacity(0.05),
                    Color.clear
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
    
    // MARK: - Border Overlay
    
    private var borderOverlay: some View {
        RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
            .stroke(
                LinearGradient(
                    colors: [
                        configuration.borderColor,
                        configuration.borderColor.opacity(0.5),
                        configuration.borderColor.opacity(0.2)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                ),
                lineWidth: configuration.borderWidth
            )
    }
    
    // MARK: - Drag Gesture
    
    private func dragGesture(containerHeight: CGFloat) -> some Gesture {
        DragGesture(minimumDistance: 10)
            .updating($gestureState) { value, state, _ in
                state = value.translation.height
            }
            .onChanged { value in
                isDragging = true
                dragOffset = max(0, value.translation.height)
            }
            .onEnded { value in
                isDragging = false
                handleDragEnd(translation: value.translation.height, velocity: value.predictedEndTranslation.height, containerHeight: containerHeight)
            }
    }
    
    // MARK: - Drag End Handling
    
    private func handleDragEnd(translation: CGFloat, velocity: CGFloat, containerHeight: CGFloat) {
        let currentHeight = currentDetent.height(in: containerHeight)
        let projectedHeight = currentHeight - translation - velocity * 0.3
        
        // Find the closest detent
        let sortedDetents = configuration.detents.sorted { lhs, rhs in
            lhs.height(in: containerHeight) < rhs.height(in: containerHeight)
        }
        
        var closestDetent: GlassSheetDetent = currentDetent
        var minDistance: CGFloat = .infinity
        
        for detent in sortedDetents {
            let detentHeight = detent.height(in: containerHeight)
            let distance = abs(projectedHeight - detentHeight)
            if distance < minDistance {
                minDistance = distance
                closestDetent = detent
            }
        }
        
        // Check for dismiss gesture
        if configuration.allowsDismiss && translation > containerHeight * 0.25 && velocity > 0 {
            dismissSheet()
        } else {
            // Snap to closest detent
            if closestDetent != currentDetent && configuration.hapticFeedback {
                triggerHaptic()
            }
            currentDetent = closestDetent
        }
        
        withAnimation(configuration.animation) {
            dragOffset = 0
        }
    }
    
    // MARK: - Helper Methods
    
    private func dimOpacity(for offset: CGFloat, containerHeight: CGFloat) -> CGFloat {
        let maxHeight = GlassSheetDetent.large.height(in: containerHeight)
        let progress = offset / maxHeight
        return configuration.maxDimOpacity * min(max(progress, 0), 1)
    }
    
    private func dismissSheet() {
        if configuration.hapticFeedback {
            triggerHaptic()
        }
        isPresented = false
    }
    
    private func triggerHaptic() {
        #if os(iOS)
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        #endif
    }
}

// MARK: - View Extension

public extension View {
    /// Presents a glass sheet over the current view.
    /// - Parameters:
    ///   - isPresented: Binding controlling sheet visibility
    ///   - currentDetent: Binding for the current detent position
    ///   - configuration: Configuration options for appearance
    ///   - content: The content to display inside the sheet
    func glassSheet<Content: View>(
        isPresented: Binding<Bool>,
        currentDetent: Binding<GlassSheetDetent>,
        configuration: GlassSheetConfiguration = GlassSheetConfiguration(),
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        ZStack {
            self
            
            GlassSheet(
                isPresented: isPresented,
                currentDetent: currentDetent,
                configuration: configuration,
                content: content
            )
        }
    }
    
    /// Presents a simple glass sheet with automatic detent management.
    /// - Parameters:
    ///   - isPresented: Binding controlling sheet visibility
    ///   - configuration: Configuration options for appearance
    ///   - content: The content to display inside the sheet
    func glassSheet<Content: View>(
        isPresented: Binding<Bool>,
        configuration: GlassSheetConfiguration = GlassSheetConfiguration(),
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        GlassSheetWrapper(
            isPresented: isPresented,
            configuration: configuration,
            mainContent: { self },
            sheetContent: content
        )
    }
}

// MARK: - Sheet Wrapper (Internal)

private struct GlassSheetWrapper<MainContent: View, SheetContent: View>: View {
    @Binding var isPresented: Bool
    let configuration: GlassSheetConfiguration
    let mainContent: () -> MainContent
    let sheetContent: () -> SheetContent
    
    @State private var currentDetent: GlassSheetDetent = .medium
    
    var body: some View {
        ZStack {
            mainContent()
            
            GlassSheet(
                isPresented: $isPresented,
                currentDetent: $currentDetent,
                configuration: configuration,
                content: sheetContent
            )
        }
    }
}

// MARK: - Preview Provider

#if DEBUG
struct GlassSheet_Previews: PreviewProvider {
    static var previews: some View {
        GlassSheetPreviewContainer()
    }
}

private struct GlassSheetPreviewContainer: View {
    @State private var showSheet = true
    @State private var currentDetent: GlassSheetDetent = .medium
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.purple, .blue, .cyan],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack {
                Text("Background Content")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Button("Toggle Sheet") {
                    showSheet.toggle()
                }
                .buttonStyle(.borderedProminent)
            }
            
            GlassSheet(
                isPresented: $showSheet,
                currentDetent: $currentDetent
            ) {
                VStack(spacing: 20) {
                    Text("Glass Sheet")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("Drag to change height")
                        .foregroundColor(.secondary)
                    
                    ForEach(0..<5) { index in
                        HStack {
                            Circle()
                                .fill(Color.blue.opacity(0.3))
                                .frame(width: 40, height: 40)
                            
                            VStack(alignment: .leading) {
                                Text("Item \(index + 1)")
                                    .fontWeight(.medium)
                                Text("Description text")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                }
                .padding(.top)
            }
        }
    }
}
#endif
