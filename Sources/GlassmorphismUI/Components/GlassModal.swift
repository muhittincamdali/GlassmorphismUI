// GlassModal.swift
// GlassmorphismUI - Production-ready glassmorphism effects for SwiftUI
// Copyright (c) 2024-2025 Muhittin Camdali. MIT License.

import SwiftUI

// MARK: - GlassModal

/// A modal/sheet component with glass styling.
///
/// ## Example
///
/// ```swift
/// @State private var showModal = false
///
/// Button("Show Modal") { showModal = true }
///     .glassModal(isPresented: $showModal) {
///         Text("Modal Content")
///     }
/// ```
public struct GlassModal<Content: View>: View {
    
    // MARK: - Properties
    
    @Binding private var isPresented: Bool
    private let style: GlassStyle
    private let cornerRadius: CGFloat
    private let showHandle: Bool
    private let dismissible: Bool
    private let content: Content
    
    @State private var dragOffset: CGFloat = 0
    @GestureState private var isDragging: Bool = false
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.glassConfiguration) private var configuration
    
    // MARK: - Initialization
    
    /// Creates a glass modal.
    ///
    /// - Parameters:
    ///   - isPresented: Binding to control presentation.
    ///   - style: The glass style. Default is `.prominent`.
    ///   - cornerRadius: The corner radius. Default is 24.
    ///   - showHandle: Whether to show a drag handle. Default is true.
    ///   - dismissible: Whether dragging down dismisses. Default is true.
    ///   - content: The modal content.
    public init(
        isPresented: Binding<Bool>,
        style: GlassStyle = .prominent,
        cornerRadius: CGFloat = 24,
        showHandle: Bool = true,
        dismissible: Bool = true,
        @ViewBuilder content: () -> Content
    ) {
        self._isPresented = isPresented
        self.style = style
        self.cornerRadius = cornerRadius
        self.showHandle = showHandle
        self.dismissible = dismissible
        self.content = content()
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(spacing: 0) {
            // Handle
            if showHandle {
                handleView
            }
            
            // Content
            content
                .frame(maxWidth: .infinity)
        }
        .glass(
            style: style,
            cornerStyle: .continuous(cornerRadius)
        )
        .offset(y: dragOffset)
        .gesture(dismissGesture)
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
    
    // MARK: - Private Views
    
    @ViewBuilder
    private var handleView: some View {
        Capsule()
            .fill(Color.secondary.opacity(0.4))
            .frame(width: 36, height: 5)
            .padding(.top, 8)
            .padding(.bottom, 4)
    }
    
    // MARK: - Gestures
    
    private var dismissGesture: some Gesture {
        DragGesture()
            .updating($isDragging) { _, state, _ in
                state = true
            }
            .onChanged { value in
                guard dismissible else { return }
                let translation = value.translation.height
                if translation > 0 {
                    dragOffset = translation * 0.5
                }
            }
            .onEnded { value in
                guard dismissible else { return }
                
                let velocity = value.predictedEndTranslation.height
                let shouldDismiss = velocity > 500 || value.translation.height > 150
                
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    if shouldDismiss {
                        isPresented = false
                    }
                    dragOffset = 0
                }
            }
    }
}

// MARK: - Glass Modal Modifier

/// A view modifier that presents a glass modal.
public struct GlassModalModifier<ModalContent: View>: ViewModifier {
    
    @Binding var isPresented: Bool
    let style: GlassStyle
    let cornerRadius: CGFloat
    let showHandle: Bool
    let dismissible: Bool
    let modalContent: () -> ModalContent
    
    @State private var opacity: CGFloat = 0
    
    public func body(content: Content) -> some View {
        ZStack {
            content
            
            if isPresented {
                // Backdrop
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        if dismissible {
                            withAnimation(.easeOut(duration: 0.2)) {
                                isPresented = false
                            }
                        }
                    }
                    .transition(.opacity)
                
                // Modal
                VStack {
                    Spacer()
                    
                    GlassModal(
                        isPresented: $isPresented,
                        style: style,
                        cornerRadius: cornerRadius,
                        showHandle: showHandle,
                        dismissible: dismissible,
                        content: modalContent
                    )
                }
                .ignoresSafeArea(.container, edges: .bottom)
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.85), value: isPresented)
    }
}

// MARK: - View Extension

public extension View {
    
    /// Presents a glass modal sheet.
    ///
    /// ## Example
    ///
    /// ```swift
    /// @State private var showModal = false
    ///
    /// Button("Show") { showModal = true }
    ///     .glassModal(isPresented: $showModal) {
    ///         VStack {
    ///             Text("Hello!")
    ///             Button("Dismiss") { showModal = false }
    ///         }
    ///         .padding()
    ///     }
    /// ```
    ///
    /// - Parameters:
    ///   - isPresented: Binding to control presentation.
    ///   - style: The glass style. Default is `.prominent`.
    ///   - cornerRadius: Corner radius. Default is 24.
    ///   - showHandle: Show drag handle. Default is true.
    ///   - dismissible: Allow drag to dismiss. Default is true.
    ///   - content: The modal content.
    /// - Returns: A view that can present a glass modal.
    func glassModal<Content: View>(
        isPresented: Binding<Bool>,
        style: GlassStyle = .prominent,
        cornerRadius: CGFloat = 24,
        showHandle: Bool = true,
        dismissible: Bool = true,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        modifier(GlassModalModifier(
            isPresented: isPresented,
            style: style,
            cornerRadius: cornerRadius,
            showHandle: showHandle,
            dismissible: dismissible,
            modalContent: content
        ))
    }
}

// MARK: - GlassAlert

/// A glass-styled alert dialog.
public struct GlassAlert<Actions: View>: View {
    
    private let title: String
    private let message: String?
    private let actions: Actions
    
    @Environment(\.colorScheme) private var colorScheme
    
    public init(
        title: String,
        message: String? = nil,
        @ViewBuilder actions: () -> Actions
    ) {
        self.title = title
        self.message = message
        self.actions = actions()
    }
    
    public var body: some View {
        VStack(spacing: 16) {
            // Title
            Text(title)
                .font(.headline)
                .multilineTextAlignment(.center)
            
            // Message
            if let message = message {
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            // Actions
            actions
        }
        .padding(20)
        .frame(minWidth: 280)
        .glass(style: .prominent, cornerRadius: 16)
    }
}

// MARK: - GlassAlertModifier

public struct GlassAlertModifier<Actions: View>: ViewModifier {
    
    @Binding var isPresented: Bool
    let title: String
    let message: String?
    let actions: () -> Actions
    
    public func body(content: Content) -> some View {
        ZStack {
            content
            
            if isPresented {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture { isPresented = false }
                    .transition(.opacity)
                
                GlassAlert(title: title, message: message, actions: actions)
                    .transition(.scale(scale: 0.9).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isPresented)
    }
}

public extension View {
    
    /// Presents a glass-styled alert.
    func glassAlert<Actions: View>(
        isPresented: Binding<Bool>,
        title: String,
        message: String? = nil,
        @ViewBuilder actions: @escaping () -> Actions
    ) -> some View {
        modifier(GlassAlertModifier(
            isPresented: isPresented,
            title: title,
            message: message,
            actions: actions
        ))
    }
}

// MARK: - Preview

#if DEBUG
struct GlassModal_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            LinearGradient(
                colors: [.purple, .blue],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            Text("Background Content")
        }
        .glassModal(isPresented: .constant(true)) {
            VStack(spacing: 16) {
                Text("Modal Title")
                    .font(.title2.bold())
                
                Text("This is the modal content with glass styling.")
                    .multilineTextAlignment(.center)
                
                GlassButton("Dismiss") { }
            }
            .padding()
            .padding(.bottom, 20)
        }
    }
}
#endif
