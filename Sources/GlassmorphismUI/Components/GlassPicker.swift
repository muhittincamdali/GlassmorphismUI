//
//  GlassPicker.swift
//  GlassmorphismUI
//
//  A collection of picker components with glassmorphism styling.
//  Includes segmented picker, wheel picker, and date picker variants.
//

import SwiftUI

// MARK: - Picker Style

/// Available styles for glass pickers.
public enum GlassPickerStyle: Sendable {
    /// Segmented control style with horizontal segments
    case segmented
    /// Inline picker with compact appearance
    case inline
    /// Menu-based picker that expands on tap
    case menu
    /// Wheel-style picker with scrolling selection
    case wheel
}

// MARK: - Picker Configuration

/// Configuration options for customizing glass picker appearance.
public struct GlassPickerConfiguration: Sendable {
    /// The blur intensity of the glass effect
    public var blurIntensity: CGFloat
    /// The tint color applied to the glass surface
    public var tintColor: Color
    /// The opacity of the tint color
    public var tintOpacity: CGFloat
    /// Corner radius for the picker
    public var cornerRadius: CGFloat
    /// The accent color for selected state
    public var accentColor: Color
    /// The color for selected segment background
    public var selectedBackgroundColor: Color
    /// Border width for the glass edge
    public var borderWidth: CGFloat
    /// Border color for the glass edge
    public var borderColor: Color
    /// Height of the picker (for segmented style)
    public var height: CGFloat
    /// Padding inside the picker
    public var padding: CGFloat
    /// Animation for selection changes
    public var animation: Animation
    /// Whether to enable haptic feedback
    public var hapticFeedback: Bool
    /// Font for picker labels
    public var font: Font
    /// Font weight for selected state
    public var selectedFontWeight: Font.Weight
    /// Shadow radius
    public var shadowRadius: CGFloat
    /// Shadow color
    public var shadowColor: Color
    
    /// Creates a new picker configuration with default values.
    public init(
        blurIntensity: CGFloat = 0.8,
        tintColor: Color = .white,
        tintOpacity: CGFloat = 0.1,
        cornerRadius: CGFloat = 12,
        accentColor: Color = .blue,
        selectedBackgroundColor: Color = .white,
        borderWidth: CGFloat = 0.5,
        borderColor: Color = .white.opacity(0.3),
        height: CGFloat = 44,
        padding: CGFloat = 4,
        animation: Animation = .spring(response: 0.3, dampingFraction: 0.7),
        hapticFeedback: Bool = true,
        font: Font = .system(size: 15, weight: .medium),
        selectedFontWeight: Font.Weight = .semibold,
        shadowRadius: CGFloat = 8,
        shadowColor: Color = .black.opacity(0.1)
    ) {
        self.blurIntensity = blurIntensity
        self.tintColor = tintColor
        self.tintOpacity = tintOpacity
        self.cornerRadius = cornerRadius
        self.accentColor = accentColor
        self.selectedBackgroundColor = selectedBackgroundColor
        self.borderWidth = borderWidth
        self.borderColor = borderColor
        self.height = height
        self.padding = padding
        self.animation = animation
        self.hapticFeedback = hapticFeedback
        self.font = font
        self.selectedFontWeight = selectedFontWeight
        self.shadowRadius = shadowRadius
        self.shadowColor = shadowColor
    }
    
    /// Preset for a subtle picker style
    public static var subtle: GlassPickerConfiguration {
        GlassPickerConfiguration(
            blurIntensity: 0.6,
            tintOpacity: 0.05,
            selectedBackgroundColor: .white.opacity(0.8),
            borderWidth: 0,
            shadowRadius: 4
        )
    }
    
    /// Preset for a vibrant picker style
    public static var vibrant: GlassPickerConfiguration {
        GlassPickerConfiguration(
            blurIntensity: 0.95,
            tintOpacity: 0.15,
            cornerRadius: 16,
            selectedBackgroundColor: .white,
            borderWidth: 1,
            shadowRadius: 12
        )
    }
}

// MARK: - Picker Option Protocol

/// Protocol for items that can be displayed in a glass picker.
public protocol GlassPickerOption: Hashable, Identifiable {
    /// The display title for this option
    var title: String { get }
    /// Optional SF Symbol icon name
    var icon: String? { get }
}

/// Default implementation for GlassPickerOption
public extension GlassPickerOption {
    var icon: String? { nil }
}

// MARK: - Simple Option Implementation

/// A simple implementation of GlassPickerOption using a string.
public struct SimplePickerOption: GlassPickerOption {
    public let id: String
    public let title: String
    public let icon: String?
    
    public init(id: String? = nil, title: String, icon: String? = nil) {
        self.id = id ?? title
        self.title = title
        self.icon = icon
    }
}

// MARK: - Glass Segmented Picker

/// A segmented control picker with glassmorphism styling.
///
/// Example usage:
/// ```swift
/// @State private var selection = 0
/// let options = ["Day", "Week", "Month"]
///
/// GlassSegmentedPicker(selection: $selection, options: options)
/// ```
public struct GlassSegmentedPicker<Option: GlassPickerOption>: View {
    // MARK: - Properties
    
    @Binding private var selection: Option
    private let options: [Option]
    private let configuration: GlassPickerConfiguration
    
    @Namespace private var namespace
    
    // MARK: - Initialization
    
    /// Creates a new segmented picker.
    /// - Parameters:
    ///   - selection: Binding to the currently selected option
    ///   - options: Array of available options
    ///   - configuration: Configuration options for appearance
    public init(
        selection: Binding<Option>,
        options: [Option],
        configuration: GlassPickerConfiguration = GlassPickerConfiguration()
    ) {
        self._selection = selection
        self.options = options
        self.configuration = configuration
    }
    
    // MARK: - Body
    
    public var body: some View {
        GeometryReader { geometry in
            let segmentWidth = (geometry.size.width - configuration.padding * 2) / CGFloat(options.count)
            
            ZStack(alignment: .leading) {
                // Glass background
                glassBackground
                
                // Selected indicator
                if let selectedIndex = options.firstIndex(of: selection) {
                    RoundedRectangle(cornerRadius: configuration.cornerRadius - configuration.padding, style: .continuous)
                        .fill(configuration.selectedBackgroundColor)
                        .frame(width: segmentWidth - 4, height: configuration.height - configuration.padding * 2 - 4)
                        .shadow(color: configuration.shadowColor, radius: configuration.shadowRadius / 2, x: 0, y: 2)
                        .offset(x: CGFloat(selectedIndex) * segmentWidth + configuration.padding + 2)
                        .animation(configuration.animation, value: selection)
                }
                
                // Segments
                HStack(spacing: 0) {
                    ForEach(options) { option in
                        segmentButton(for: option, width: segmentWidth)
                    }
                }
                .padding(configuration.padding)
            }
            .clipShape(RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous))
            .overlay(borderOverlay)
        }
        .frame(height: configuration.height)
    }
    
    // MARK: - Segment Button
    
    private func segmentButton(for option: Option, width: CGFloat) -> some View {
        Button {
            selectOption(option)
        } label: {
            HStack(spacing: 6) {
                if let icon = option.icon {
                    Image(systemName: icon)
                        .font(.system(size: 14))
                }
                
                Text(option.title)
                    .font(configuration.font)
                    .fontWeight(selection == option ? configuration.selectedFontWeight : .regular)
            }
            .foregroundColor(selection == option ? .primary : .secondary)
            .frame(width: width - 4)
            .frame(height: configuration.height - configuration.padding * 2 - 4)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Glass Background
    
    private var glassBackground: some View {
        ZStack {
            RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
                .fill(.ultraThinMaterial)
                .opacity(configuration.blurIntensity)
            
            RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
                .fill(configuration.tintColor.opacity(configuration.tintOpacity))
        }
    }
    
    // MARK: - Border Overlay
    
    private var borderOverlay: some View {
        RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
            .stroke(configuration.borderColor, lineWidth: configuration.borderWidth)
    }
    
    // MARK: - Selection Handler
    
    private func selectOption(_ option: Option) {
        guard option != selection else { return }
        
        if configuration.hapticFeedback {
            triggerHaptic()
        }
        
        withAnimation(configuration.animation) {
            selection = option
        }
    }
    
    private func triggerHaptic() {
        #if os(iOS)
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
        #endif
    }
}

// MARK: - String-Based Segmented Picker

/// Convenience initializer for string-based options
public extension GlassSegmentedPicker where Option == SimplePickerOption {
    /// Creates a segmented picker with string options.
    /// - Parameters:
    ///   - selection: Binding to the selected index
    ///   - options: Array of string options
    ///   - configuration: Configuration options for appearance
    init(
        selection: Binding<Int>,
        options: [String],
        configuration: GlassPickerConfiguration = GlassPickerConfiguration()
    ) {
        let simpleOptions = options.enumerated().map { SimplePickerOption(id: "\($0.offset)", title: $0.element) }
        let selectedOption = Binding<SimplePickerOption>(
            get: { simpleOptions[min(selection.wrappedValue, simpleOptions.count - 1)] },
            set: { newValue in
                if let index = simpleOptions.firstIndex(of: newValue) {
                    selection.wrappedValue = index
                }
            }
        )
        self.init(selection: selectedOption, options: simpleOptions, configuration: configuration)
    }
}

// MARK: - Glass Wheel Picker

/// A wheel-style picker with glassmorphism container.
public struct GlassWheelPicker<Option: GlassPickerOption>: View {
    // MARK: - Properties
    
    @Binding private var selection: Option
    private let options: [Option]
    private let configuration: GlassPickerConfiguration
    private let rowHeight: CGFloat
    private let visibleRows: Int
    
    // MARK: - Initialization
    
    /// Creates a wheel-style picker.
    /// - Parameters:
    ///   - selection: Binding to the currently selected option
    ///   - options: Array of available options
    ///   - configuration: Configuration options for appearance
    ///   - rowHeight: Height of each row in the wheel
    ///   - visibleRows: Number of visible rows
    public init(
        selection: Binding<Option>,
        options: [Option],
        configuration: GlassPickerConfiguration = GlassPickerConfiguration(),
        rowHeight: CGFloat = 44,
        visibleRows: Int = 5
    ) {
        self._selection = selection
        self.options = options
        self.configuration = configuration
        self.rowHeight = rowHeight
        self.visibleRows = visibleRows
    }
    
    // MARK: - Body
    
    public var body: some View {
        ZStack {
            // Glass container
            glassBackground
            
            // Selection indicator
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(configuration.selectedBackgroundColor.opacity(0.3))
                .frame(height: rowHeight)
            
            // Picker wheel
            Picker("", selection: $selection) {
                ForEach(options) { option in
                    HStack(spacing: 8) {
                        if let icon = option.icon {
                            Image(systemName: icon)
                        }
                        Text(option.title)
                    }
                    .tag(option)
                }
            }
            .pickerStyle(.wheel)
            .onChange(of: selection) { _ in
                if configuration.hapticFeedback {
                    triggerHaptic()
                }
            }
        }
        .frame(height: rowHeight * CGFloat(visibleRows))
        .clipShape(RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous))
        .overlay(borderOverlay)
    }
    
    // MARK: - Glass Background
    
    private var glassBackground: some View {
        ZStack {
            RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
                .fill(.ultraThinMaterial)
                .opacity(configuration.blurIntensity)
            
            RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
                .fill(configuration.tintColor.opacity(configuration.tintOpacity))
        }
    }
    
    // MARK: - Border Overlay
    
    private var borderOverlay: some View {
        RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
            .stroke(configuration.borderColor, lineWidth: configuration.borderWidth)
    }
    
    private func triggerHaptic() {
        #if os(iOS)
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
        #endif
    }
}

// MARK: - Glass Date Picker

/// A date picker with glassmorphism styling.
public struct GlassDatePicker: View {
    // MARK: - Properties
    
    @Binding private var selection: Date
    private let displayedComponents: DatePickerComponents
    private let configuration: GlassPickerConfiguration
    private let label: String
    
    // MARK: - Initialization
    
    /// Creates a glass date picker.
    /// - Parameters:
    ///   - label: Label text for the picker
    ///   - selection: Binding to the selected date
    ///   - displayedComponents: Which date/time components to display
    ///   - configuration: Configuration options for appearance
    public init(
        _ label: String = "",
        selection: Binding<Date>,
        displayedComponents: DatePickerComponents = [.date, .hourAndMinute],
        configuration: GlassPickerConfiguration = GlassPickerConfiguration()
    ) {
        self.label = label
        self._selection = selection
        self.displayedComponents = displayedComponents
        self.configuration = configuration
    }
    
    // MARK: - Body
    
    public var body: some View {
        ZStack {
            glassBackground
            
            DatePicker(
                label,
                selection: $selection,
                displayedComponents: displayedComponents
            )
            .datePickerStyle(.compact)
            .padding(.horizontal, 16)
            .onChange(of: selection) { _ in
                if configuration.hapticFeedback {
                    triggerHaptic()
                }
            }
        }
        .frame(height: configuration.height)
        .clipShape(RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous))
        .overlay(borderOverlay)
    }
    
    // MARK: - Glass Background
    
    private var glassBackground: some View {
        ZStack {
            RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
                .fill(.ultraThinMaterial)
                .opacity(configuration.blurIntensity)
            
            RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
                .fill(configuration.tintColor.opacity(configuration.tintOpacity))
        }
    }
    
    // MARK: - Border Overlay
    
    private var borderOverlay: some View {
        RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
            .stroke(configuration.borderColor, lineWidth: configuration.borderWidth)
    }
    
    private func triggerHaptic() {
        #if os(iOS)
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
        #endif
    }
}

// MARK: - Glass Color Picker

/// A color picker with glassmorphism styling.
public struct GlassColorPicker: View {
    // MARK: - Properties
    
    @Binding private var selection: Color
    private let configuration: GlassPickerConfiguration
    private let supportsOpacity: Bool
    private let label: String
    
    // MARK: - Initialization
    
    /// Creates a glass color picker.
    /// - Parameters:
    ///   - label: Label text for the picker
    ///   - selection: Binding to the selected color
    ///   - supportsOpacity: Whether to allow opacity adjustment
    ///   - configuration: Configuration options for appearance
    public init(
        _ label: String = "Color",
        selection: Binding<Color>,
        supportsOpacity: Bool = true,
        configuration: GlassPickerConfiguration = GlassPickerConfiguration()
    ) {
        self.label = label
        self._selection = selection
        self.supportsOpacity = supportsOpacity
        self.configuration = configuration
    }
    
    // MARK: - Body
    
    public var body: some View {
        ZStack {
            glassBackground
            
            HStack {
                Text(label)
                    .font(configuration.font)
                    .foregroundColor(.primary)
                
                Spacer()
                
                ColorPicker("", selection: $selection, supportsOpacity: supportsOpacity)
                    .labelsHidden()
                    .onChange(of: selection) { _ in
                        if configuration.hapticFeedback {
                            triggerHaptic()
                        }
                    }
            }
            .padding(.horizontal, 16)
        }
        .frame(height: configuration.height)
        .clipShape(RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous))
        .overlay(borderOverlay)
    }
    
    // MARK: - Glass Background
    
    private var glassBackground: some View {
        ZStack {
            RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
                .fill(.ultraThinMaterial)
                .opacity(configuration.blurIntensity)
            
            RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
                .fill(configuration.tintColor.opacity(configuration.tintOpacity))
        }
    }
    
    // MARK: - Border Overlay
    
    private var borderOverlay: some View {
        RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
            .stroke(configuration.borderColor, lineWidth: configuration.borderWidth)
    }
    
    private func triggerHaptic() {
        #if os(iOS)
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
        #endif
    }
}

// MARK: - Glass Toggle Picker

/// A toggle switch with glassmorphism styling.
public struct GlassToggle: View {
    // MARK: - Properties
    
    @Binding private var isOn: Bool
    private let configuration: GlassPickerConfiguration
    private let label: String
    private let icon: String?
    
    // MARK: - Initialization
    
    /// Creates a glass toggle.
    /// - Parameters:
    ///   - label: Label text for the toggle
    ///   - icon: Optional SF Symbol icon name
    ///   - isOn: Binding to the toggle state
    ///   - configuration: Configuration options for appearance
    public init(
        _ label: String,
        icon: String? = nil,
        isOn: Binding<Bool>,
        configuration: GlassPickerConfiguration = GlassPickerConfiguration()
    ) {
        self.label = label
        self.icon = icon
        self._isOn = isOn
        self.configuration = configuration
    }
    
    // MARK: - Body
    
    public var body: some View {
        ZStack {
            glassBackground
            
            HStack(spacing: 12) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 18))
                        .foregroundColor(configuration.accentColor)
                        .frame(width: 28)
                }
                
                Text(label)
                    .font(configuration.font)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Toggle("", isOn: $isOn)
                    .labelsHidden()
                    .tint(configuration.accentColor)
                    .onChange(of: isOn) { _ in
                        if configuration.hapticFeedback {
                            triggerHaptic()
                        }
                    }
            }
            .padding(.horizontal, 16)
        }
        .frame(height: configuration.height)
        .clipShape(RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous))
        .overlay(borderOverlay)
    }
    
    // MARK: - Glass Background
    
    private var glassBackground: some View {
        ZStack {
            RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
                .fill(.ultraThinMaterial)
                .opacity(configuration.blurIntensity)
            
            RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
                .fill(configuration.tintColor.opacity(configuration.tintOpacity))
        }
    }
    
    // MARK: - Border Overlay
    
    private var borderOverlay: some View {
        RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
            .stroke(configuration.borderColor, lineWidth: configuration.borderWidth)
    }
    
    private func triggerHaptic() {
        #if os(iOS)
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        #endif
    }
}

// MARK: - Glass Slider

/// A slider with glassmorphism styling.
public struct GlassSlider: View {
    // MARK: - Properties
    
    @Binding private var value: Double
    private let range: ClosedRange<Double>
    private let step: Double?
    private let configuration: GlassPickerConfiguration
    private let label: String
    private let showValue: Bool
    private let valueFormat: String
    
    // MARK: - Initialization
    
    /// Creates a glass slider.
    /// - Parameters:
    ///   - label: Label text for the slider
    ///   - value: Binding to the current value
    ///   - range: The range of valid values
    ///   - step: Optional step increment
    ///   - showValue: Whether to display the current value
    ///   - valueFormat: Format string for displaying the value
    ///   - configuration: Configuration options for appearance
    public init(
        _ label: String,
        value: Binding<Double>,
        in range: ClosedRange<Double> = 0...1,
        step: Double? = nil,
        showValue: Bool = true,
        valueFormat: String = "%.1f",
        configuration: GlassPickerConfiguration = GlassPickerConfiguration()
    ) {
        self.label = label
        self._value = value
        self.range = range
        self.step = step
        self.showValue = showValue
        self.valueFormat = valueFormat
        self.configuration = configuration
    }
    
    // MARK: - Body
    
    public var body: some View {
        ZStack {
            glassBackground
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(label)
                        .font(configuration.font)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    if showValue {
                        Text(String(format: valueFormat, value))
                            .font(.system(size: 14, weight: .medium, design: .monospaced))
                            .foregroundColor(.secondary)
                    }
                }
                
                if let step = step {
                    Slider(value: $value, in: range, step: step)
                        .tint(configuration.accentColor)
                } else {
                    Slider(value: $value, in: range)
                        .tint(configuration.accentColor)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .clipShape(RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous))
        .overlay(borderOverlay)
    }
    
    // MARK: - Glass Background
    
    private var glassBackground: some View {
        ZStack {
            RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
                .fill(.ultraThinMaterial)
                .opacity(configuration.blurIntensity)
            
            RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
                .fill(configuration.tintColor.opacity(configuration.tintOpacity))
        }
    }
    
    // MARK: - Border Overlay
    
    private var borderOverlay: some View {
        RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
            .stroke(configuration.borderColor, lineWidth: configuration.borderWidth)
    }
}

// MARK: - Preview Provider

#if DEBUG
struct GlassPicker_Previews: PreviewProvider {
    static var previews: some View {
        GlassPickerPreviewContainer()
    }
}

private struct GlassPickerPreviewContainer: View {
    @State private var segmentSelection = 0
    @State private var date = Date()
    @State private var color = Color.blue
    @State private var toggleOn = true
    @State private var sliderValue = 0.5
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.indigo, .purple, .pink],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    Text("Glass Pickers")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    // Segmented picker
                    GlassSegmentedPicker(
                        selection: $segmentSelection,
                        options: ["Day", "Week", "Month", "Year"]
                    )
                    .padding(.horizontal)
                    
                    // Date picker
                    GlassDatePicker("Date", selection: $date)
                        .padding(.horizontal)
                    
                    // Color picker
                    GlassColorPicker("Theme Color", selection: $color)
                        .padding(.horizontal)
                    
                    // Toggle
                    GlassToggle("Notifications", icon: "bell.fill", isOn: $toggleOn)
                        .padding(.horizontal)
                    
                    // Slider
                    GlassSlider("Volume", value: $sliderValue, in: 0...100, step: 1, valueFormat: "%.0f%%")
                        .padding(.horizontal)
                    
                    Spacer(minLength: 50)
                }
                .padding(.top, 40)
            }
        }
    }
}
#endif
