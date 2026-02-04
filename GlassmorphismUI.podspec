Pod::Spec.new do |s|
  s.name             = 'GlassmorphismUI'
  s.version          = '1.0.0'
  s.summary          = 'Glassmorphism UI components for SwiftUI'
  s.description      = 'Glassmorphism UI components for SwiftUI. Built with modern Swift.'
  s.homepage         = 'https://github.com/muhittincamdali/GlassmorphismUI'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Muhittin Camdali' => 'contact@muhittincamdali.com' }
  s.source           = { :git => 'https://github.com/muhittincamdali/GlassmorphismUI.git', :tag => s.version.to_s }
  s.ios.deployment_target = '15.0'
  s.swift_versions = ['5.9', '5.10', '6.0']
  s.source_files = 'Sources/**/*.swift'
end
