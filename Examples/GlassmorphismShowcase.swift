//
//  GlassmorphismShowcase.swift
//  GlassmorphismUI Examples
//
//  A comprehensive showcase demonstrating all glassmorphism components
//  and effects available in the GlassmorphismUI framework.
//

import SwiftUI
import GlassmorphismUI

// MARK: - Main Showcase View

/// A showcase view demonstrating all GlassmorphismUI components.
public struct GlassmorphismShowcase: View {
    @State private var selectedTab = 0
    
    public init() {}
    
    public var body: some View {
        TabView(selection: $selectedTab) {
            ComponentsShowcase()
                .tabItem {
                    Label("Components", systemImage: "square.stack.3d.up")
                }
                .tag(0)
            
            EffectsShowcase()
                .tabItem {
                    Label("Effects", systemImage: "sparkles")
                }
                .tag(1)
            
            AnimationsShowcase()
                .tabItem {
                    Label("Animations", systemImage: "wand.and.stars")
                }
                .tag(2)
            
            ThemesShowcase()
                .tabItem {
                    Label("Themes", systemImage: "paintpalette")
                }
                .tag(3)
        }
    }
}

// MARK: - Components Showcase

struct ComponentsShowcase: View {
    @State private var showSheet = false
    @State private var sheetDetent: GlassSheetDetent = .medium
    @State private var showMenu = false
    @State private var segmentSelection = 0
    @State private var date = Date()
    @State private var toggleOn = true
    @State private var sliderValue = 0.5
    
    var body: some View {
        ZStack {
            backgroundGradient
            
            ScrollView {
                VStack(spacing: 32) {
                    headerSection
                    
                    // Glass Cards Section
                    sectionHeader("Glass Cards")
                    glassCardsSection
                    
                    // Glass Buttons Section
                    sectionHeader("Glass Buttons")
                    glassButtonsSection
                    
                    // Glass Pickers Section
                    sectionHeader("Glass Pickers")
                    glassPickersSection
                    
                    // Glass Controls Section
                    sectionHeader("Glass Controls")
                    glassControlsSection
                    
                    // Interactive Section
                    sectionHeader("Interactive Components")
                    interactiveSection
                    
                    Spacer(minLength: 100)
                }
                .padding()
            }
            
            // Glass Sheet
            GlassSheet(
                isPresented: $showSheet,
                currentDetent: $sheetDetent
            ) {
                sheetContent
            }
        }
    }
    
    // MARK: - Background
    
    private var backgroundGradient: some View {
        LinearGradient(
            colors: [
                Color(red: 0.4, green: 0.2, blue: 0.8),
                Color(red: 0.2, green: 0.4, blue: 0.9),
                Color(red: 0.3, green: 0.6, blue: 0.8)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    // MARK: - Header
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("Components")
                .font(.largeTitle)
                .fontWeight(.bold)
            Text("Glass UI Elements")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .foregroundColor(.white)
        .padding(.top, 20)
    }
    
    // MARK: - Section Header
    
    private func sectionHeader(_ title: String) -> some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.white.opacity(0.9))
            Spacer()
        }
    }
    
    // MARK: - Glass Cards Section
    
    private var glassCardsSection: some View {
        VStack(spacing: 16) {
            // Standard Card
            GlassCard {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Standard Glass Card")
                        .font(.headline)
                    Text("A versatile container with frosted glass effect")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
            }
            
            // Card with custom configuration
            HStack(spacing: 16) {
                GlassCard(configuration: .minimal) {
                    VStack {
                        Image(systemName: "star.fill")
                            .font(.title)
                            .foregroundColor(.yellow)
                        Text("Minimal")
                            .font(.caption)
                    }
                    .padding()
                }
                
                GlassCard(configuration: .prominent) {
                    VStack {
                        Image(systemName: "heart.fill")
                            .font(.title)
                            .foregroundColor(.pink)
                        Text("Prominent")
                            .font(.caption)
                    }
                    .padding()
                }
            }
        }
    }
    
    // MARK: - Glass Buttons Section
    
    private var glassButtonsSection: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                GlassButton("Primary") {
                    print("Primary tapped")
                }
                
                GlassButton("Secondary", style: .secondary) {
                    print("Secondary tapped")
                }
            }
            
            HStack(spacing: 16) {
                GlassButton("With Icon", icon: "arrow.right") {
                    print("Icon button tapped")
                }
                
                GlassButton("Destructive", style: .destructive) {
                    print("Destructive tapped")
                }
            }
        }
    }
    
    // MARK: - Glass Pickers Section
    
    private var glassPickersSection: some View {
        VStack(spacing: 16) {
            // Segmented Picker
            GlassSegmentedPicker(
                selection: $segmentSelection,
                options: ["Day", "Week", "Month"]
            )
            
            // Date Picker
            GlassDatePicker("Select Date", selection: $date, displayedComponents: .date)
        }
    }
    
    // MARK: - Glass Controls Section
    
    private var glassControlsSection: some View {
        VStack(spacing: 16) {
            GlassToggle("Enable Notifications", icon: "bell.fill", isOn: $toggleOn)
            
            GlassSlider("Volume", value: $sliderValue, in: 0...1, valueFormat: "%.0f%%")
        }
    }
    
    // MARK: - Interactive Section
    
    private var interactiveSection: some View {
        VStack(spacing: 16) {
            // Sheet trigger
            GlassButton("Show Glass Sheet", icon: "rectangle.bottomhalf.inset.filled") {
                showSheet = true
            }
            
            // Menu trigger
            GlassDropdownMenu(items: sampleMenuItems) {
                HStack {
                    Text("Open Menu")
                    Image(systemName: "chevron.down")
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(.ultraThinMaterial)
                .clipShape(Capsule())
            }
        }
    }
    
    // MARK: - Sheet Content
    
    private var sheetContent: some View {
        VStack(spacing: 20) {
            Text("Glass Sheet")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Drag up and down to change height")
                .foregroundColor(.secondary)
            
            Divider()
            
            ForEach(0..<5) { index in
                HStack {
                    Circle()
                        .fill(Color.blue.opacity(0.3))
                        .frame(width: 40, height: 40)
                    
                    VStack(alignment: .leading) {
                        Text("Item \(index + 1)")
                            .fontWeight(.medium)
                        Text("Description text here")
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
    
    // MARK: - Sample Menu Items
    
    private var sampleMenuItems: [GlassMenuItem] {
        [
            GlassMenuItem(title: "Copy", icon: "doc.on.doc") { print("Copy") },
            GlassMenuItem(title: "Share", icon: "square.and.arrow.up") { print("Share") },
            .divider,
            GlassMenuItem(title: "Edit", icon: "pencil") { print("Edit") },
            GlassMenuItem(title: "Delete", icon: "trash", isDestructive: true) { print("Delete") }
        ]
    }
}

// MARK: - Effects Showcase

struct EffectsShowcase: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.orange, .pink, .purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 32) {
                    Text("Effects")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 20)
                    
                    // Blur Effects
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Blur Effects")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        HStack(spacing: 16) {
                            blurEffectCard("Light", config: .light)
                            blurEffectCard("Regular", config: .regular)
                        }
                        
                        HStack(spacing: 16) {
                            blurEffectCard("Heavy", config: .heavy)
                            blurEffectCard("Frosted", config: .frosted)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Noise Textures
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Noise Textures")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            noiseTextureCard("White", type: .white)
                            noiseTextureCard("Perlin", type: .perlin)
                            noiseTextureCard("Worley", type: .worley)
                            noiseTextureCard("Film Grain", type: .filmGrain)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Combined Effects
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Combined Effects")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        VStack(spacing: 12) {
                            Text("Glass with Noise")
                                .font(.subheadline)
                            Text("Subtle texture overlay for realistic glass")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(30)
                        .frame(maxWidth: .infinity)
                        .frostedBlur()
                        .glassNoise(opacity: 0.05)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                    .padding(.horizontal)
                    
                    Spacer(minLength: 100)
                }
            }
        }
    }
    
    private func blurEffectCard(_ title: String, config: AdvancedBlurConfiguration) -> some View {
        VStack {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 80)
        .advancedBlur(config)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private func noiseTextureCard(_ title: String, type: NoiseType) -> some View {
        VStack {
            NoiseTextureView(
                configuration: NoiseTextureConfiguration(
                    type: type,
                    opacity: 0.5,
                    scale: 2.0
                )
            )
            .frame(height: 60)
            .background(Color.gray.opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            Text(title)
                .font(.caption)
                .foregroundColor(.white)
        }
    }
}

// MARK: - Animations Showcase

struct AnimationsShowcase: View {
    @State private var showCard = true
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.cyan, .blue, .indigo],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 32) {
                    Text("Animations")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 20)
                    
                    // Shimmer Effect
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Shimmer Effect")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Text("Loading placeholder...")
                            .font(.subheadline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shimmer()
                    }
                    .padding(.horizontal)
                    
                    // Pulse Effect
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Pulse Effect")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        HStack {
                            Spacer()
                            Circle()
                                .fill(.ultraThinMaterial)
                                .frame(width: 80, height: 80)
                                .overlay(
                                    Image(systemName: "heart.fill")
                                        .font(.title)
                                        .foregroundColor(.pink)
                                )
                                .pulse()
                            Spacer()
                        }
                    }
                    .padding(.horizontal)
                    
                    // Glow Effect
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Glow Effect")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        HStack {
                            Spacer()
                            Text("Glowing Text")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding()
                                .background(.ultraThinMaterial)
                                .clipShape(Capsule())
                                .glow(color: .cyan, radius: 15)
                            Spacer()
                        }
                    }
                    .padding(.horizontal)
                    
                    // Float Effect
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Float Effect")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        HStack {
                            Spacer()
                            Image(systemName: "cloud.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.white.opacity(0.8))
                                .float()
                            Spacer()
                        }
                        .frame(height: 100)
                    }
                    .padding(.horizontal)
                    
                    // Morphing Border
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Morphing Border")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Text("Animated gradient border")
                            .padding(20)
                            .frame(maxWidth: .infinity)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .morphingBorder(colors: [.cyan, .blue, .purple, .pink, .cyan])
                    }
                    .padding(.horizontal)
                    
                    // Transitions
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Transitions")
                            .font(.headline)
                            .foregroundColor(.white)
                        
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
                                Text("With glass reveal transition")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(30)
                            .frame(maxWidth: .infinity)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .transition(GlassTransitions.glassReveal)
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer(minLength: 100)
                }
            }
        }
    }
}

// MARK: - Themes Showcase

struct ThemesShowcase: View {
    @State private var selectedTheme = GlassThemes.light
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: selectedTheme.backgroundColors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 0.3), value: selectedTheme)
            
            ScrollView {
                VStack(spacing: 24) {
                    Text("Themes")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(selectedTheme.primaryTextColor)
                        .padding(.top, 20)
                    
                    Text("Select a theme to preview")
                        .foregroundColor(selectedTheme.secondaryTextColor)
                    
                    // Theme Picker
                    GlassThemePicker(selection: $selectedTheme, columns: 4)
                        .padding(.horizontal)
                    
                    // Sample Card
                    VStack(spacing: 16) {
                        Text("Sample Card")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(selectedTheme.primaryTextColor)
                        
                        Text("This card adapts to the selected theme, demonstrating colors, blur intensity, and styling.")
                            .font(.subheadline)
                            .foregroundColor(selectedTheme.secondaryTextColor)
                            .multilineTextAlignment(.center)
                        
                        Divider()
                        
                        HStack(spacing: 12) {
                            Button("Primary") {}
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(selectedTheme.accentColor)
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                            
                            Button("Secondary") {}
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(selectedTheme.tintColor.opacity(0.2))
                                .foregroundColor(selectedTheme.primaryTextColor)
                                .clipShape(Capsule())
                        }
                    }
                    .padding(24)
                    .themedGlassBackground(selectedTheme)
                    .padding(.horizontal)
                    
                    // Theme Info
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Current Theme: \(selectedTheme.name)")
                            .font(.headline)
                        
                        Text("Blur: \(Int(selectedTheme.blurIntensity * 100))%")
                        Text("Tint Opacity: \(Int(selectedTheme.tintOpacity * 100))%")
                        Text("Corner Radius: \(Int(selectedTheme.cornerRadius))pt")
                    }
                    .font(.caption)
                    .foregroundColor(selectedTheme.secondaryTextColor)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(selectedTheme.tintColor.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)
                    
                    Spacer(minLength: 100)
                }
            }
        }
        .glassTheme(selectedTheme)
    }
}

// MARK: - Preview Provider

#if DEBUG
struct GlassmorphismShowcase_Previews: PreviewProvider {
    static var previews: some View {
        GlassmorphismShowcase()
    }
}
#endif
