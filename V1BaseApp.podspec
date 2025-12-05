Pod::Spec.new do |s|
  s.name             = 'V1BaseApp'
  s.version          = '0.1.5'
s.summary = 'This is a base library for using V1 style'
s.description = <<-DESC
Base library for V1 style apps. This pod provides foundational components, utilities, and extensions to streamline development of apps following the V1 design system. It includes helpers for UI styling, common networking patterns, and modular architecture support. Expand as needed for better App Store visibility and user discovery.
DESC

  s.homepage         = 'https://github.com/thainguyen2301/v1_base_app'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '141131796' => 'thainx23@gmail.com' }

  s.source           = { :git => 'https://github.com/thainguyen2301/v1_base_app.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.0'

  # Swift configuration
  s.swift_version = '5.0'
  s.requires_arc = true

  # Framework type (dynamic by default for Swift; explicit for clarity)
  s.static_framework = false

  # Module name for @import in consuming code
  s.module_name = 'V1BaseApp'

  # Source files (assumes V1BaseApp/Classes/ contains your .swift files)
  s.source_files = 'V1BaseApp/Classes/**/*'

  # Optional: If you have resources (e.g., assets, storyboards)
  # s.resource_bundles = { 'V1BaseApp' => ['V1BaseApp/Assets/*.xcassets'] }

  # Optional: Dependencies (add if your pod relies on others, e.g., Alamofire)
  # s.dependency 'Alamofire', '~> 5.0'
  s.dependency 'RxSwift', '~> 6.9.0'
  s.dependency 'RxCocoa', '~> 6.9.0'
end
